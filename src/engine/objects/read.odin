package objects

import "core:fmt"
import "core:strings"

import tf "vendor:cgltf"

import emath "../../maths"
import s "../../shared"

@(private="file")
ModelDataType :: #type struct {
    vertices: [dynamic]s.Vertex,
    indices:  [dynamic]u32,
    type:     tf.primitive_type,
}

ModelData :: #type ModelDataType
Models    :: #type [dynamic]ModelDataType

SceneData :: #type struct {
    meshes:  map[cstring]Models,
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
    

    meshes: map[cstring]Models = {}
    for mesh, i in data.meshes {
        models: Models = {}
        defer delete(models)

        indices: map[s.Vertex]u32 = {}
        for prime, j in mesh.primitives {
            model: ModelData = {}
            model.type = prime.type
            defer delete(model.vertices)
            defer delete(model.indices)

            accessorsMap: map[cstring]tf.accessor = {}
            defer delete(accessorsMap)

            ok: b32 = true
            for attr, k in prime.attributes {                
                #partial switch attr.type {
                    case .position: {
                        accessorsMap[attr.name] = attr.data^
                        break
                    }
                    
                    case .normal: {
                        accessorsMap[attr.name] = attr.data^
                        break
                    }
                    
                    case .tangent: {
                        accessorsMap[attr.name] = attr.data^
                        break
                    }
                    
                    case .color: {
                        accessorsMap[attr.name] = attr.data^
                        break
                    }
                    
                    case .texcoord: {
                        accessorsMap[attr.name] = attr.data^
                        break
                    }
                    
                    case: {
                        accessorsMap[attr.name] = attr.data^
                        break
                    }
                }
            }
            for k, _ in accessorsMap {
                fmt.eprintfln("\t{}", k)
            }

            position: ^tf.accessor = nil
            uv0:      ^tf.accessor = nil
            uv1:      ^tf.accessor = nil
            normal:   ^tf.accessor = nil
            tangent:  ^tf.accessor = nil
            color:    ^tf.accessor = nil

            fmt.eprintln("Setting up accessors:")
            if accessorsMap["POSITION"]   != {} do position = &accessorsMap["POSITION"]
            if accessorsMap["TEXCOORD_0"] != {} do uv0      = &accessorsMap["TEXCOORD_0"]
            if accessorsMap["TEXCOORD_1"] != {} do uv1      = &accessorsMap["TEXCOORD_1"]
            if accessorsMap["NORMAL"]     != {} do normal   = &accessorsMap["NORMAL"]
            if accessorsMap["TANGENT"]    != {} do tangent  = &accessorsMap["TANGENT"]            
            if accessorsMap["COLOR_0"]    != {} do color    = &accessorsMap["COLOR_0"]
            fmt.eprintln("-----------------")

            fmt.eprintln("Checking position:")
            if position == nil {
                panic("Failed to find position data!")
            }
            // fmt.eprintln("-----------------")
            
            vertexCount := (position^).count
            fmt.eprintfln("Vertex count: {}", vertexCount)
            // fmt.eprintln("-----------------")
            
            // fmt.eprintln("Creating vertex:")
            for l in 0..<vertexCount {
                vertex:     s.Vertex = {}
                
                if position != nil {
                    // fmt.eprintln("Position")
                    if ok := tf.accessor_read_float(position, l, raw_data(&vertex.pos), 3); !ok{
                        panic("Failed to read position data!")
                    }
                    // fmt.eprintfln("----------")
                }

                if normal != nil {
                    // fmt.eprintln("Normal") 
                    if ok := tf.accessor_read_float(normal, l, raw_data(&vertex.norm), 3); !ok{
                        panic("Failed to read normal data!")
                    }
                    // fmt.eprintfln("----------")
                }

                if tangent != nil {
                    // fmt.eprintln("Tangent") 
                    if ok := tf.accessor_read_float(tangent, l, raw_data(&vertex.tan), 3); !ok{
                        panic("Failed to read tangent data!")
                    }
                    // fmt.eprintfln("----------")
                }

                if color != nil {
                    // fmt.eprintln("Color") 
                    if ok := tf.accessor_read_float(color, l, raw_data(&vertex.color), 3); !ok{
                        panic("Failed to read color data!")
                    }
                    // fmt.eprintfln("----------")
                }

                if uv0 != nil {
                    // fmt.eprintln("UV_0") 
                    if ok := tf.accessor_read_float(uv0, l, raw_data(&vertex.uv0), 2); !ok{
                        panic("Failed to read uv0 data!")
                    }
                    // fmt.eprintfln("----------")
                }

                if uv1 != nil {
                    // fmt.eprintln("UV_1") 
                    // if ok := tf.accessor_read_float(uv1, l, raw_data(&vertex.uv1), 2); !ok{
                    //     panic("Failed to read uv1 data!")
                    // }
                    // fmt.eprintfln("----------")
                }

                // fmt.eprintfln("\t\t{}\n", vertex)
                append(&model.vertices, vertex)
            }

            append(&models, model)
        }

        meshes[mesh.name] = models
    }
    scenes[sceneName] = { meshes = meshes } 

    return
}

CleanUp :: proc() {
    for _, v in scenes {
        delete(v.meshes)
    }
    delete(scenes)
}