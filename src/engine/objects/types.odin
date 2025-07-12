package eobjects

import s  "../../shared"
import em "../../maths"

Vertex :: #type s.Vertex

MaterialData :: struct {
    diffuse_color:    em.Vec4,
    specular_color:   em.Vec3,
    ambient_color:    em.Vec3,
    emissive_color:   em.Vec3,
    shininess:        f32,
    opacity:          f32,
    diffuse_texture:  cstring,
    specular_texture: cstring,
    normal_texture:   cstring,
    height_texture:   cstring,
}

TextureData :: struct {
    width:      u32,
    height:     u32,
    channels:   u32,
    data:       []u8,
    path:       cstring,
}

BoneData :: struct {
    name:           cstring,
    offset_matrix:  [4]em.Vec4,
    parent_index:   i32,
}

MeshData :: struct {
    vertices:       []Vertex,
    indices:        []u32,
    material_index: u32,
    bone_mapping:   map[cstring]u32,
    name:           cstring,
}

SceneData :: struct {
    meshes:         []MeshData,
    materials:      []MaterialData,
    textures:       []TextureData,
    bones:          []BoneData,
    animations:     []AnimationData,     root_transform: [4]em.Vec4,
}

AnimationData :: struct {
    name:           cstring,
    duration:       f64,
    ticks_per_sec:  f64,
    }
