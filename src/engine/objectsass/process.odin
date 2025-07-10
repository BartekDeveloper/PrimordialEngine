package eobjects

import "core:c"
import "core:fmt"
import "core:strings"
import "core:slice"
import "core:math/linalg"

import ass "../../../external/assimp/odin-assimp"

// Global storage for processed scene data
sceneDataMap: map[cstring]SceneData = {}

/*
    @description Processes vertices from assimp mesh
    @input mesh: ^ass.Mesh
    @output vertices: []Vertex
*/
ProcessVertices :: proc(mesh: ^ass.Mesh) -> []Vertex {
    vertices := make([]Vertex, mesh.mNumVertices)
    
    for i in 0..<mesh.mNumVertices {
        vertex := &vertices[i]
        
        // Position (always present)
        if mesh.mVertices != nil {
            pos := mesh.mVertices[i]
            vertex.position = {pos.x, pos.y, pos.z}
        }
        
        // Normals
        if mesh.mNormals != nil {
            normal := mesh.mNormals[i]
            vertex.normal = {normal.x, normal.y, normal.z}
        }
        
        // Texture coordinates (first UV set)
        if mesh.mTextureCoords != nil && mesh.mTextureCoords[0] != nil {
            tex_coord := mesh.mTextureCoords[0][i]
            vertex.tex_coords = {tex_coord.x, tex_coord.y}
        }
        
        // Tangents
        if mesh.mTangents != nil {
            tangent := mesh.mTangents[i]
            vertex.tangent = {tangent.x, tangent.y, tangent.z}
        }
        
        // Bitangents
        if mesh.mBitangents != nil {
            bitangent := mesh.mBitangents[i]
            vertex.bitangent = {bitangent.x, bitangent.y, bitangent.z}
        }
        
        // Initialize bone data
        vertex.bone_ids = {-1, -1, -1, -1}
        vertex.bone_weights = {0, 0, 0, 0}
    }
    
    return vertices
}

/*
    @description Processes indices from assimp mesh
    @input mesh: ^ass.Mesh
    @output indices: []u32
*/
ProcessIndices :: proc(mesh: ^ass.Mesh) -> []u32 {
    indices := make([]u32, mesh.mNumFaces * 3) // Assuming triangulated
    
    for i in 0..<mesh.mNumFaces {
        face := mesh.mFaces[i]
        if face.mNumIndices == 3 {
            indices[i * 3 + 0] = face.mIndices[0]
            indices[i * 3 + 1] = face.mIndices[1]
            indices[i * 3 + 2] = face.mIndices[2]
        }
    }
    
    return indices
}

/*
    @description Converts assimp string to odin string
    @input str: ass.String
    @output ostr: string
*/
AssStringToOdinString :: proc(str: ass.String) -> (ostr: string = "") {
    for i in 0..<str.length {
        ostr = fmt.tprintf("%s%s", ostr, (rune)(str.data[i]))
    }
    fmt.eprintfln("String: %s", ostr)

    return
}

/*
    @description Converts assimp string to c string
    @input str: ass.String
    @output ocstr: cstring
*/
AssStringToCString :: proc(str: ass.String) -> (ocstr: cstring = "") {
    ostr: string = ""
    for i in 0..<str.length {
        ostr = fmt.tprintf("%s%s", ostr, (rune)(str.data[i]))
    }
    fmt.eprintfln("String: %s", ostr)

    ocstr = strings.clone_to_cstring(ostr)
    defer delete_string(ostr)

    return
}

/*
    @description Processes bone data from assimp mesh
    @input mesh: ^ass.Mesh
    @input vertices: []Vertex (modified in place)
    @output bone_mapping: map[cstring]u32
*/
ProcessBones :: proc(mesh: ^ass.Mesh, vertices: []Vertex) -> map[cstring]u32 {
    bone_mapping := make(map[cstring]u32)
    
    for i in 0..<mesh.mNumBones {
        bone := mesh.mBones[i]
        
        boneName := AssStringToCString(bone.mName)
        bone_mapping[boneName] = u32(i)
        
        // Process bone weights
        for j in 0..<bone.mNumWeights {
            weight := bone.mWeights[j]
            vertex_id := weight.mVertexId
            
            if vertex_id < u32(len(vertices)) {
                vertex := &vertices[vertex_id]
                
                // Find empty slot for bone weight
                for k in 0..<4 {
                    if vertex.bone_weights[k] == 0 {
                        vertex.bone_ids[k] = i32(i)
                        vertex.bone_weights[k] = weight.mWeight
                        break
                    }
                }
            }
        }
    }
    
    return bone_mapping
}

/*
    @description Processes material data from assimp material
    @input material: ^ass.Material
    @output material_data: MaterialData
*/
ProcessMaterial :: proc(material: ^ass.Material) -> MaterialData {
    mat_data := MaterialData{}
    
    // Get material properties
    // Note: You'll need to implement GetMaterialProperty helper functions
    // based on your assimp binding
    
    // Diffuse color
    if diffuse_color, ok := GetMaterialColor(material, .DIFFUSE); ok {
        mat_data.diffuse_color = diffuse_color
    } else {
        mat_data.diffuse_color = {1.0, 1.0, 1.0, 1.0}
    }
    
    // Specular color
    if specular_color, ok := GetMaterialColor(material, ass.Material_Property_Type.SPECULAR); ok {
        mat_data.specular_color = specular_color[:3]
    } else {
        mat_data.specular_color = {1.0, 1.0, 1.0}
    }
    
    // Shininess
    if shininess, ok := GetMaterialFloat(material, ass.Material_Property_Type.SHININESS); ok {
        mat_data.shininess = shininess
    } else {
        mat_data.shininess = 32.0
    }
    
    // Opacity
    if opacity, ok := GetMaterialFloat(material, ass.Material_Property_Type.OPACITY); ok {
        mat_data.opacity = opacity
    } else {
        mat_data.opacity = 1.0
    }
    
    // Texture paths
    mat_data.diffuse_texture = GetMaterialTexture(material, ass.Texture_Type.DIFFUSE)
    mat_data.specular_texture = GetMaterialTexture(material, ass.Texture_Type.SPECULAR)
    mat_data.normal_texture = GetMaterialTexture(material, ass.Texture_Type.NORMALS)
    mat_data.height_texture = GetMaterialTexture(material, ass.Texture_Type.HEIGHT)
    
    return mat_data
}

/*
    @description Helper function to get material color property
    @input material: ^ass.Material
    @input prop_type: ass.Material_Property_Type
    @output color: [4]f32, ok: bool
*/
GetMaterialColor :: proc(material: ^ass.Material, prop_type: ass.Material_Property_Type) -> (color: [4]f32, ok: bool) {
    // Implementation depends on your assimp binding
    // This is a placeholder - adjust based on your binding
    return {1.0, 1.0, 1.0, 1.0}, true
}

/*
    @description Helper function to get material float property
    @input material: ^ass.Material
    @input prop_type: ass.Material_Property_Type
    @output value: f32, ok: bool
*/
GetMaterialFloat :: proc(material: ^ass.Material, prop_type: ass.Material_Property_Type) -> (value: f32, ok: bool) {
    // Implementation depends on your assimp binding
    return 1.0, true
}

/*
    @description Helper function to get material texture path
    @input material: ^ass.Material
    @input tex_type: ass.Texture_Type
    @output path: cstring
*/
GetMaterialTexture :: proc(material: ^ass.Material, tex_type: ass.Texture_Type) -> cstring {
    // Implementation depends on your assimp binding
    return ""
}

/*
    @description Main processing function - converts assimp scene to SceneData
    @input scene: ^ass.Scene
    @input scene_name: cstring
    @output success: bool
*/
ProcessSceneData :: proc(scene: ^ass.Scene, scene_name: cstring) -> bool {
    if scene == nil {
        fmt.eprintln("Cannot process nil scene")
        return false
    }
    
    scene_data := SceneData{}
    
    // Process meshes
    scene_data.meshes = make([]MeshData, scene.mNumMeshes)
    for i in 0..<scene.mNumMeshes {
        mesh := scene.mMeshes[i]
        mesh_data := &scene_data.meshes[i]
        
        // Process vertices and indices
        mesh_data.vertices = ProcessVertices(mesh)
        mesh_data.indices = ProcessIndices(mesh)
        mesh_data.material_index = mesh.mMaterialIndex
        
        // Process bones
        mesh_data.bone_mapping = ProcessBones(mesh, mesh_data.vertices)
    }
    
    // Process materials
    scene_data.materials = make([]MaterialData, scene.mNumMaterials)
    for i in 0..<scene.mNumMaterials {
        material := scene.mMaterials[i]
        scene_data.materials[i] = ProcessMaterial(material)
    }
    
    // Process embedded textures
    scene_data.textures = make([]TextureData, scene.mNumTextures)
    for i in 0..<scene.mNumTextures {
        texture := scene.mTextures[i]
        tex_data := &scene_data.textures[i]
        
        tex_data.width = texture.mWidth
        tex_data.height = texture.mHeight
        tex_data.channels = 4 // RGBA assumption
        
        // Uncompressed texture
        tex_data.data = make([]u8, texture.mWidth * texture.mHeight * 4)
        for j in 0..<(texture.mWidth * texture.mHeight) {
            texel := texture.pcData[j]
            tex_data.data[j * 4 + 0] = texel.b
            tex_data.data[j * 4 + 1] = texel.g
            tex_data.data[j * 4 + 2] = texel.r
            tex_data.data[j * 4 + 3] = texel.a
        }
    }
    
    // Store processed data
    sceneDataMap[scene_name] = scene_data
    modelExists[strings.clone_from_cstring(scene_name)] = true
    
    fmt.eprintfln("Successfully processed scene: {}", scene_name)
    return true
}

/*
    @description Get processed scene data by name
    @input scene_name: cstring
    @output scene_data: ^SceneData, ok: bool
*/
GetSceneData :: proc(scene_name: cstring) -> (scene_data: SceneData, ok: bool) {
    if data, exists := &sceneDataMap[scene_name]; exists {
        return data^, true
    }
    return {}, false
}

/*
    @description Clean up processed scene data
    @input scene_name: cstring
*/
CleanupSceneData :: proc(scene_name: cstring) {
    if data, exists := sceneDataMap[scene_name]; exists {
        // Free allocated memory
        for &mesh in data.meshes {
            delete(mesh.vertices)
            delete(mesh.indices)
            delete(mesh.bone_mapping)
        }
        delete(data.meshes)
        delete(data.materials)
        
        for &texture in data.textures {
            delete(texture.data)
        }
        delete(data.textures)
        delete(data.bones)
        
        delete_key(&sceneDataMap, scene_name)
    }
}
