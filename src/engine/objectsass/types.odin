package eobjects

import s  "../../shared"
import em "../../maths"

// Core vertex structure for rendering
Vertex :: #type s.Vertex

// Material data extracted from assimp
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

// Texture information
TextureData :: struct {
    width:      u32,
    height:     u32,
    channels:   u32,
    data:       []u8,
    path:       cstring,
}

// Bone/Joint data for skeletal animation
BoneData :: struct {
    name:           cstring,
    offset_matrix:  [4]em.Vec4,
    parent_index:   i32,
}

// Mesh data container
MeshData :: struct {
    vertices:       []Vertex,
    indices:        []u32,
    material_index: u32,
    bone_mapping:   map[cstring]u32,
}

// Complete scene data structure
SceneData :: struct {
    meshes:         []MeshData,
    materials:      []MaterialData,
    textures:       []TextureData,
    bones:          []BoneData,
    animations:     []AnimationData, // For future use
    root_transform: [4]em.Vec4,
}

// Animation data structure for future expansion
AnimationData :: struct {
    name:           cstring,
    duration:       f64,
    ticks_per_sec:  f64,
    // NOTE(me): Add animation channels here when needed
}