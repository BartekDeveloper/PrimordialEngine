package objects

import "core:fmt"
import tf "vendor:cgltf"
import s "../../shared"

joint :: #type u8

PrimitiveType :: enum u8{
    Invalid,
    Point,
    Line,
    Triangle,
    TriangleStrip,
    TriangleFan
}

Mesh :: #type struct{
    vertices: []s.Vertex,
    indices:  []u32,
    joints:   []joint,
    verticesCount: u32,
    indicesCount: u32,
    type:     PrimitiveType,
}

SceneFlag :: enum u8{
    ReLoad,
    Invalid
}
SceneFlags :: #type bit_set[SceneFlag]

Model :: #type struct{
    name: cstring,
    meshes: map[string]Mesh,
}
Models :: #type map[string]Model

SceneData :: #type struct{
    path: string,
    objects: Models,
    flags: SceneFlags,
}

modelGroups: map[string]SceneData = {}
modelExists: map[string]b8        = {}
allLoaded:   bool                 = false

ConvertPrimitive_fromTfToUnified :: proc(
    from: tf.primitive_type,
) -> (to: PrimitiveType = nil) {
    #partial switch from {
        case .invalid:        to =  nil
        case .points:         to = .Point
        case .lines:          to = .Line
        case .triangle_fan:   to = .TriangleFan
        case .triangle_strip: to = .TriangleStrip
        case .triangles:      to = .Triangle
    }
    if to == nil do fmt.eprintfln("![!! WARN !!]! PRIMITIVE CONVERSION FAILED, TYPE IS NIL ![!! WARN !!]!") 

    return
}

ConvertPrimitive_fromUnifiedToTf :: proc(
    from: PrimitiveType,
) -> (to: tf.primitive_type = nil) {
    #partial switch from {
        case .Point:         to = .points
        case .Line:          to = .lines
        case .Triangle:      to = .triangles
        case .TriangleStrip: to = .triangle_strip
        case .TriangleFan:   to = .triangle_fan
    }
    if to == nil do fmt.eprintfln("![!! WARN !!]! PRIMITIVE CONVERSION FAILED, TYPE IS NIL ![!! WARN !!]!") 

    return
}

ConvertPrimitive :: proc{
    ConvertPrimitive_fromTfToUnified,
    ConvertPrimitive_fromUnifiedToTf,
}
