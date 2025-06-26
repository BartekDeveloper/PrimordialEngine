package objects

import "core:fmt"
import "core:strings"

import tf "vendor:cgltf"

import emath "../../maths"
import s "../../shared"

ModelDataType :: #type struct {
    vertices: [dynamic]s.Vertex,
    indices:  [dynamic]u32,
    type:     tf.primitive_type,
}
ModelData :: #type ModelDataType

SceneData :: #type struct {
    meshes:  map[cstring][dynamic]ModelDataType,
}

defaultOptions: tf.options = {}
defaultOptionsPtr := &defaultOptions

scenes: map[string]SceneData = {}

Load_fromFile   :: proc(file: string = "", sceneName: string = "unnamed", options: tf.options = defaultOptions) -> (outModelData: ModelData = {}, good: bool = true) #optional_ok {
    path, err := strings.clone_to_cstring(file, context.temp_allocator)
    if err != nil {
        panic("Failed to make file path cstring!")
    }
    fmt.eprintfln("Name: %s\tFile path: %s", sceneName, path)


    data, result := tf.parse_file(options, path)
    defer tf.free(data)
    if result != .success {
        panic("Failed to parse model data from file!")
    }
    fmt.eprintfln("Parsed `%s`\t@ path` `%s` model data from file!", sceneName, file)


    buffer_result := tf.load_buffers(options, data, path)
    if buffer_result != .success {
        panic("Failed to load model buffers from file!")
    }
    fmt.eprintfln("Loaded buffers for `%s`\t@ path` `%s`!", sceneName, file)


    ProcessData(data, sceneName)
    return
}

Load_fromMemory :: proc(buffer: []byte = {}, sceneName: string = "unnamed", options: tf.options = defaultOptions) -> (outModelData: ModelData = {}, good: bool = true) #optional_ok {
    
    data, result := tf.parse(options, raw_data(buffer), len(buffer))
    defer tf.free(data)
    if result != .success {
        panic("Failed to parse model data from memory!")
    }
    fmt.eprintfln("Parsed `%s` model data from memory!", sceneName)


    buffer_result := tf.load_buffers(options, data, nil)
    if buffer_result != .success {
        panic("Failed to load model buffers from memory!")
    }
    fmt.eprintfln("Loaded buffers for `%s`!", sceneName)
    
    
    ProcessData(data, sceneName)
    return
}

Load :: proc{
    Load_fromFile,
    Load_fromMemory,
}

ProcessData :: proc(data: ^tf.data, sceneName: string) -> () {
    fmt.eprintfln("* -=-=-=-> Model Data <-=-=-=- *")
    defer fmt.eprintfln("* -=-=-=-> ---------- <-=-=-=- *")
    

    meshes: map[cstring][dynamic]ModelDataType = {}
    for &mesh, i in data.meshes {
        ProcessMesh(&meshes, &mesh)
    }
    scenes[sceneName] = { meshes = meshes } 

    return
}

ProcessMesh :: proc(
    meshes: ^map[cstring][dynamic]ModelDataType,
    mesh: ^tf.mesh,
    name: cstring = "unnamed"
) -> () {
    models: [dynamic]ModelDataType = {}
    defer delete(models)

    indices: map[s.Vertex]u32 = {}
    for &prime, j in mesh.primitives {
        ProcessPrimitive(&models, &prime)
    }
    fmt.eprintfln("{}", mesh.name)

    if meshes == nil do panic("No meshes map specified!")
    meshes[mesh.name] = models

    return
}

ProcessPrimitive :: proc(
    models: ^[dynamic]ModelDataType,
    prime: ^tf.primitive,
) -> () {
    model: ModelData = {}
    model.type = prime.type
    defer delete(model.vertices)
    defer delete(model.indices)

    accessorsMap: map[cstring]tf.accessor = {}
    defer delete(accessorsMap)

    ok: b32 = true
    for &attr, k in prime.attributes {
        MapAccessor(&accessorsMap, &attr)
    }

    for k, _ in accessorsMap {
        fmt.eprintfln("\t{}", k)
    }

    position, uv0, uv1, normal, tangent, color: ^tf.accessor = nil, nil, nil, nil, nil, nil
    position = CheckAccessor("POSITION",   &accessorsMap, )
    uv0      = CheckAccessor("TEXCOORD_0", &accessorsMap)
    uv1      = CheckAccessor("TEXCOORD_1", &accessorsMap)
    normal   = CheckAccessor("NORMAL",     &accessorsMap)
    tangent  = CheckAccessor("TANGENT",    &accessorsMap)
    color    = CheckAccessor("COLOR_0",    &accessorsMap)

    if position == nil {
        panic("Failed to find position data!")
    }

    vertexCount := position.count
    fmt.eprintfln("\t\tVertex count: {}", vertexCount)

    SetIndex(0)
    for l in 0..<vertexCount {
        ProcessVertex(
            &model.vertices,
            position, normal,
            tangent, color,
            uv0
        )
    }

    if models == nil do panic("No models array specified!")
    append(models, model)

    return
}

ProcessVertex :: proc(
    vertices: ^[dynamic]s.Vertex,
    
    acPosition: ^tf.accessor,
    acNormal:   ^tf.accessor,
    acTangent:  ^tf.accessor,
    acColor:    ^tf.accessor,
    acUv0:      ^tf.accessor,
) -> () {
    if vertices == nil do panic("No vertices array specified!")

    vertex: s.Vertex = {}
    ReadVec3(acPosition, &vertex.pos)
    ReadVec3(acNormal,   &vertex.norm)
    ReadVec3(acTangent,  &vertex.tan)
    ReadVec3(acColor,    &vertex.color)
    ReadVec2(acUv0,      &vertex.uv0)
    
    append(vertices, vertex)
    AddIndex()

    return
}

currentIndex: u32 = 0
SetIndex :: proc "c" (index: u32) { currentIndex = index }
GetIndex :: proc "c" () -> u32    { return currentIndex  }
AddIndex :: proc "c" ()           { currentIndex += 1    }

ReadFloat :: proc(accessor: ^tf.accessor, data: [^]f32, #any_int count: u32) {
    if accessor == nil {
        return
    }

    ok := tf.accessor_read_float(accessor, auto_cast currentIndex, data, auto_cast count)
    if !ok {
        panic("Failed to read accessor data!")
    }
}
ReadUint :: proc(accessor: ^tf.accessor, data: [^]u32, #any_int count: u32) {
    if accessor == nil {
        return
    }
    
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
    if ok {
        return oAccessor
    } else {
        panic("Failed to find accessor!")
    }

    return
}


CleanUp :: proc() {
    for _, v in scenes {
        delete(v.meshes)
    }
    delete(scenes)
}