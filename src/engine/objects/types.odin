package objects

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
    vertices: [dynamic]s.Vertex,
    indices:  [dynamic]u32,
    joints:   [dynamic]joint,

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
Models :: #type map[cstring]Model

SceneData :: #type struct{
    path: string,
    name: string,
    objects: Models,
    flags: SceneFlags,
}
