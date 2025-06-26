package objects

import "core:fmt"
import tf "vendor:cgltf"

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