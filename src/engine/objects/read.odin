package objects

import "core:debug/pe"
import "core:fmt"
import "core:strings"
import "core:mem"
import path "core:path/filepath"

import tf "vendor:cgltf"

import emath "../../maths"
import s "../../shared"

defaultOptions: tf.options = {}
defaultOptionsPtr := &defaultOptions

Load_fromFile :: proc(
    file: string = "",
    options: tf.options = defaultOptions
) -> (
    outSceneData: SceneData = {},
    good: bool = true
) #optional_ok {

    basename: string = path.base(file)
    if basename == "." do panic("Invalid file name!")
    ext: string = path.ext(file)
    
    // defer panic("TODO: Finish me!")
    filename: string = basename[:len(basename)-len(ext)]
    // fmt.eprintfln("a\t\n\tfilename:\t\n\t\t {}\n\t\nb", filename)

    path, err := strings.clone_to_cstring(file, context.temp_allocator)
    if err != nil {
        panic("Failed to make file path cstring!")
    }


    data, result := tf.parse_file(options, path)
    defer tf.free(data)
    if result != .success {
        panic("Failed to parse model data from file!")
    }


    buffer_result := tf.load_buffers(options, data, path)
    if buffer_result != .success {
        panic("Failed to load model buffers from file!")
    }

    outSceneData = ProcessData(data, filename, file)
    return
}

Load_fromMemory :: proc(
    buffer: []byte = {},
    name: string = "unnamed",
    options: tf.options = defaultOptions
) -> (outSceneData: SceneData = {}, good: bool = true) #optional_ok {

    data, result := tf.parse(options, raw_data(buffer), len(buffer))
    defer tf.free(data)
    if result != .success {
        panic("Failed to parse model data from memory!")
    }

    buffer_result := tf.load_buffers(options, data, nil)
    if buffer_result != .success {
        panic("Failed to load model buffers from memory!")
    }
    
    outSceneData = ProcessData(data, name, "@MEMORY@")
    return
}

Load :: proc{
    Load_fromFile,
    Load_fromMemory,
}

ProcessData :: proc(data: ^tf.data, name: string, path: string) -> (sceneData: SceneData) {
    fmt.eprintfln("Loading `{}` model data...", name)
    fmt.eprintfln("* -=-=-=-> Model Data <-=-=-=- *")
    defer fmt.eprintfln("* -=-=-=-> ---------- <-=-=-=- *")
    
    sceneData.path    = strings.clone(path, context.allocator)
    sceneData.objects = {}
    sceneData.flags   = {}

    models: Models = {}
    for &mesh, i in data.meshes {
        
        modelsKeyName: string = ""
        if name == "" {
            modelsKeyName = fmt.tprintf("mesh_#%d", i)
        } else {
            modelsKeyName = fmt.tprintf("mesh_%s_#%d", name, i)
        }
        model := ProcessMesh(&mesh)
        models[modelsKeyName] = model
    }
    
    sceneData.objects = models

    modelNameKey := strings.clone(name, context.temp_allocator)
    modelGroups[modelNameKey] = sceneData

    return
}

ProcessMesh :: proc(mesh: ^tf.mesh) -> (model: Model) {
    model.name = mesh.name
    model.meshes = {}

    for &prime, j in mesh.primitives {
        meshData := ProcessPrimitive(&prime)
        primitiveKey := fmt.aprintf("{}_{}", mesh.name, j)
        model.meshes[primitiveKey] = meshData
    }
    fmt.eprintfln("{}", mesh.name)

    return
}

ProcessPrimitive :: proc(prime: ^tf.primitive) -> (mesh: Mesh) {
    
    fmt.eprintfln("Processing primitive type: {}", prime.type)
    mesh.type = ConvertPrimitive(prime.type)
    mesh.vertices = {}
    mesh.indices = {}
    mesh.joints = {}

    accessorsMap: map[cstring]tf.accessor = {}
    defer delete(accessorsMap)

    for &attr, k in prime.attributes {
        MapAccessor(&accessorsMap, &attr)
    }

    for k, _ in accessorsMap {
        fmt.eprintfln("\t{}", k)
    }

    position, uv0, uv1, normal, tangent, color, joint: ^tf.accessor = nil, nil, nil, nil, nil, nil, nil
    position = CheckAccessor("POSITION",   &accessorsMap)
    uv0      = CheckAccessor("TEXCOORD_0", &accessorsMap)
    uv1      = CheckAccessor("TEXCOORD_1", &accessorsMap)
    normal   = CheckAccessor("NORMAL",     &accessorsMap)
    tangent  = CheckAccessor("TANGENT",    &accessorsMap)
    color    = CheckAccessor("COLOR_0",    &accessorsMap)
    joint    = CheckAccessor("JOINTS_0",   &accessorsMap)

    if position == nil {
        panic("Failed to find position data!")
    }

    vertexCount := position.count
    fmt.eprintfln("\t\tVertex count: {}", vertexCount)

    mesh.vertices = make([]s.Vertex, vertexCount)

    SetIndex(0)
    for l in 0..<vertexCount {
        ProcessVertex(
            &mesh.vertices,
            position, normal,
            tangent, color,
            uv0, joint
        )
        AddIndex()
    }

    return
}

ProcessVertex :: proc(
    vertices: ^[]s.Vertex,
    
    acPosition: ^tf.accessor,
    acNormal:   ^tf.accessor,
    acTangent:  ^tf.accessor,
    acColor:    ^tf.accessor,
    acUv0:      ^tf.accessor,
    acJoint:    ^tf.accessor,
) -> () {
    if vertices == nil do panic("No vertices array specified!")

    vertex: s.Vertex = {}

    ReadVec3(acPosition, &vertex.pos)
    ReadVec3(acNormal,   &vertex.norm)
    ReadVec3(acTangent,  &vertex.tan)
    ReadVec3(acColor,    &vertex.color)
    ReadVec2(acUv0,      &vertex.uv0)

    vertices[currentIndex] = vertex

    return
}

currentIndex: u32 = 0
SetIndex :: proc "c" (index: u32) { currentIndex = index }
GetIndex :: proc "c" () -> u32    { return currentIndex  }
AddIndex :: proc "c" ()           { currentIndex += 1    }

ReadFloat :: proc(accessor: ^tf.accessor, data: [^]f32, #any_int count: u32) {
    if accessor == nil do return

    ok := tf.accessor_read_float(accessor, auto_cast currentIndex, data, auto_cast count)
    if !ok {
        fmt.eprintfln("Failed to read accessor data! {}", accessor.name)
    }
}

ReadUint :: proc(accessor: ^tf.accessor, data: [^]u32, #any_int count: u32) {
    if accessor == nil do return
    
    ok := tf.accessor_read_uint(accessor, auto_cast currentIndex, data, auto_cast count)
    if !ok {
        panic("Failed to read accessor data!")
    }
}

ReadVec4 :: proc(accessor: ^tf.accessor, data: ^emath.Vec4) {
    ReadFloat(accessor, raw_data(data), 4)
}
ReadVec3 :: proc(accessor: ^tf.accessor, data: ^emath.Vec3) {
    ReadFloat(accessor, raw_data(data), 3)
}
ReadVec2 :: proc(accessor: ^tf.accessor, data: ^emath.Vec2) {
    ReadFloat(accessor, raw_data(data), 2)
}
ReadF32 :: proc(accessor: ^tf.accessor, data: ^f32) {
    ReadFloat(accessor, data, 1)
}

ReadVec4U :: proc(accessor: ^tf.accessor, data: ^emath.uVec4) {
    ReadUint(accessor, raw_data(data), 4)
}
ReadVec3U :: proc(accessor: ^tf.accessor, data: ^emath.uVec3) {
    ReadUint(accessor, raw_data(data), 3)
}
ReadVec2U :: proc(accessor: ^tf.accessor, data: ^emath.uVec2) {
    ReadUint(accessor, raw_data(data), 2)
}
ReadU32 :: proc(accessor: ^tf.accessor, data: ^u32) {
    ReadUint(accessor, data, 1)
}

Read :: proc{
    ReadVec4,
    ReadVec3,
    ReadVec2,
    ReadF32,
    ReadVec4U,
    ReadVec3U,
    ReadVec2U,
    ReadU32,
}

MapAccessor :: proc(
    mapping: ^map[cstring]tf.accessor = nil,
    attr: ^tf.attribute = nil
) -> () {
    if mapping == nil || attr == nil {
        return
    }

    mapping[attr.name] = attr.data^
    return
}

CheckAccessor :: #force_inline proc(
    name: cstring                     = "",  
    mapping: ^map[cstring]tf.accessor = nil,
) -> (oAccessor: ^tf.accessor) {
    if mapping == nil do panic("No mapping specified!")
    if mapping[name] == {} do return
    
    ok: bool = true
    oAccessor, ok = &mapping[name]
    
    if !ok do return nil
    return
}

CleanUp :: proc() -> () {
    // For Group
    for groupName, &group in modelGroups {
        
        // For Object
        for modelName, &object in group.objects {
            
            // For Mesh
            for meshName, &mesh in object.meshes {

                mesh.verticesCount = 0
                mesh.indicesCount  = 0
                mesh.type          = .Invalid
                
                if mesh.vertices != nil do delete(mesh.vertices)
                if mesh.indices  != nil do delete(mesh.indices)
                if mesh.joints   != nil do delete(mesh.joints)

                delete_key(&object.meshes, meshName)
            }
            
            delete_key(&group.objects, modelName)
            if object.meshes != nil do delete(object.meshes)
        }
        delete(group.path)
        
        delete_key(&modelGroups, groupName)
        if group.objects != nil do delete(group.objects)
    }
    if modelGroups != nil do delete(modelGroups)
    
    return
}