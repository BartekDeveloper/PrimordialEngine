package eobjects

import "core:c"
import "core:io"
import "core:fmt"
import "core:strings"
import "core:slice"
import "core:math/linalg"

import ass "../../../external/assimp/odin-assimp"

// Global storage for processed scene data
sceneDataMap: map[cstring]SceneData = {}


ProcessVertices :: proc(mesh: ^ass.Mesh) -> []Vertex {
    vertices := make([]Vertex, mesh.mNumVertices)
    for i in 0..<mesh.mNumVertices {
        vertex := &vertices[i]
        if mesh.mVertices != nil {
            pos := mesh.mVertices[i]
            vertex.pos = {pos.x, pos.y, pos.z}
        }
        if mesh.mNormals != nil {
            normal := mesh.mNormals[i]
            vertex.norm = {normal.x, normal.y, normal.z}
        }
        if mesh.mTextureCoords != nil && mesh.mTextureCoords[0] != nil {
            tex_coord := mesh.mTextureCoords[0][i]
            vertex.uv0 = {tex_coord.x, tex_coord.y}
        }
        if mesh.mTangents != nil {
            tangent := mesh.mTangents[i]
            vertex.tan = {tangent.x, tangent.y, tangent.z}
        }
        // Uncomment if your Vertex struct includes bitangent
        // if mesh.mBitangents != nil {
        //     bitangent := mesh.mBitangents[i]
        //     vertex.btan = {bitangent.x, bitangent.y, bitangent.z}
        // }
        vertex.boneId     = {-1, -1, -1, -1}
        vertex.boneWeight = {0, 0, 0, 0}
    }
    return vertices
}


ProcessIndices :: proc(mesh: ^ass.Mesh) -> []u32 {
    indices := make([]u32, mesh.mNumFaces * 3)
    for i in 0..<mesh.mNumFaces {
        face := mesh.mFaces[i]
        if face.mNumIndices == 3 {
            indices[i * 3 + 0] = face.mIndices[0]
            indices[i * 3 + 1] = face.mIndices[1]
            indices[i * 3 + 2] = face.mIndices[2]
        } else if face.mNumIndices == 2 {
            indices[i * 2 + 0] = face.mIndices[0]
            indices[i * 2 + 1] = face.mIndices[1]
        } else if face.mNumIndices == 1 {
            indices[i * 1 + 0] = face.mIndices[0]
        } else if face.mNumIndices == 4 {
            indices[i * 4 + 0] = face.mIndices[0]
            indices[i * 4 + 1] = face.mIndices[1]
            indices[i * 4 + 2] = face.mIndices[2]
            indices[i * 4 + 3] = face.mIndices[3]
        } else {
            fmt.eprintfln("WARNING: Face has {} indices! Skipping...", face.mNumIndices)
            continue
        }
    }
    return indices
}


AssStringToCString :: proc(str: ass.String) -> (ocstr: cstring = "") {
    ostr: string = ""
    for i in 0..<str.length {
        letterBuilder := strings.builder_make_len(1, context.temp_allocator)
        defer strings.builder_destroy(&letterBuilder)

        letter: rune = (rune)(str.data[i])
        
        err: io.Error = nil
        _, err = strings.write_rune(&letterBuilder, letter)
        if err != nil {
            fmt.eprintln("Error writing rune to string builder!")
            panic("Error writing rune to string builder!")
        }

        letterStr: string = strings.to_string(letterBuilder)
        ostr = fmt.tprintf("%s%s", ostr, letterStr)
    }

    fmt.eprintfln("\n\n\n Assimp string: %s\n", ostr)

    ocstr = strings.clone_to_cstring(ostr)
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
        for j in 0..<bone.mNumWeights {
            weight := bone.mWeights[j]
            vertex_id := weight.mVertexId
            if vertex_id < u32(len(vertices)) {
                vertex := &vertices[vertex_id]
                for k in 0..<4 {
                    if vertex.boneWeight[k] == 0 {
                        vertex.boneId[k] = i32(i)
                        vertex.boneWeight[k] = weight.mWeight
                        break
                    }
                }
            }
        }
    }
    return bone_mapping
}


ProcessMaterial :: proc(material: ^ass.Material) -> MaterialData {
    mat_data := MaterialData{}

    // Diffuse color
    if diffuse_color, ok := GetMaterialColor(material, "$clr.diffuse"); ok {
        mat_data.diffuse_color = diffuse_color
    } else {
        mat_data.diffuse_color = [4]f32{1.0, 1.0, 1.0, 1.0}
    }

    // Specular color
    if specular_color, ok := GetMaterialColor(material, "$clr.specular"); ok {
        mat_data.specular_color = [3]f32{specular_color[0], specular_color[1], specular_color[2]}
    } else {
        mat_data.specular_color = [3]f32{1.0, 1.0, 1.0}
    }

    // Shininess
    if shininess, ok := GetMaterialFloat(material, "$mat.shininess"); ok {
        mat_data.shininess = shininess
    } else {
        mat_data.shininess = 32.0
    }

    // Opacity
    if opacity, ok := GetMaterialFloat(material, "$mat.opacity"); ok {
        mat_data.opacity = opacity
    } else {
        mat_data.opacity = 1.0
    }

    // Texture paths
    mat_data.diffuse_texture  = GetMaterialTexture(material, ass.Texture_Type.DIFFUSE)
    mat_data.specular_texture = GetMaterialTexture(material, ass.Texture_Type.SPECULAR)
    mat_data.normal_texture   = GetMaterialTexture(material, ass.Texture_Type.NORMALS)
    mat_data.height_texture   = GetMaterialTexture(material, ass.Texture_Type.HEIGHT)

    return mat_data
}

/*
    @description Helper function to get material color property
    @input material: ^ass.Material
    @input key: string
    @output color: [4]f32, ok: bool
*/
GetMaterialColor :: proc(material: ^ass.Material, key: string) -> ([4]f32, bool) {
    assert(material != nil, "Material is nil!")

    if material.mProperties == nil || material.mNumProperties == 0 {
        return [4]f32{}, false
    }

    for i in 0..<material.mNumProperties {
        fmt.eprintfln("material property index: {}", i)

        prop := material.mProperties[i]
        assert(prop != nil, "Property is nil!")

        if strings.compare(string(prop.mKey.data[:prop.mKey.length]), key) == 0 && prop.mType == .Float {
            n   := prop.mDataLength / size_of(f32)
            ptr := rawptr(prop.mData)
            color := [4]f32{}
            
            for j in 0..<4 {
                if n <= u32(j) {
                    color[j] = 0.0
                    continue
                }
                color[j] = (([^]f32)(ptr))[j]
            }
            return color, true
        }
    }
    return [4]f32{}, false
}

/*
    @description Helper function to get material float property
    @input material: ^ass.Material
    @input key: string
    @output value: f32, ok: bool
*/
GetMaterialFloat :: proc(material: ^ass.Material, key: string) -> (f32, bool) {
    if material.mProperties == nil || material.mNumProperties == 0 {
        return 0.0, false
    }

    for i in 0..<material.mNumProperties {
        prop := material.mProperties[i]
        if strings.compare(string(prop.mKey.data[:prop.mKey.length]), key) == 0 && prop.mType == .Float {
            n := prop.mDataLength / size_of(f32)
            if n > 0 {
                ptr := rawptr(prop.mData)
                return (([^]f32)(ptr))[0], true
            }
        }
    }
    return 0.0, false
}

/*
    @description Helper function to get material texture path
    @input material: ^ass.Material
    @input tex_type: ass.Texture_Type
    @output path: cstring
*/
GetMaterialTexture :: proc(material: ^ass.Material, tex_type: ass.Texture_Type) -> cstring {
    if material.mProperties == nil || material.mNumProperties == 0 {
        return ""
    }

    for i in 0..<material.mNumProperties {
        prop := material.mProperties[i]
        if prop.mSemantic == u32(tex_type) && prop.mType == .String {
            return AssStringToCString(((^ass.String)(rawptr(prop.mData)))^)
        }
    }
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
    sceneData: SceneData = {}
    sceneData.meshes = make([]MeshData, scene.mNumMeshes)
    for i in 0..<scene.mNumMeshes {
        mesh     := scene.mMeshes[i]
        meshData := &sceneData.meshes[i]


        meshData.vertices       = ProcessVertices(mesh)
        meshData.indices        = ProcessIndices(mesh)
        meshData.material_index = mesh.mMaterialIndex
        meshData.bone_mapping   = ProcessBones(mesh, meshData.vertices)


        if mesh.mName == {} {
            meshData.name = "mesh"
            continue
        }

        name: cstring = AssStringToCString(mesh.mName)
        meshData.name = name
    }

    sceneData.materials = make([]MaterialData, scene.mNumMaterials)
    for i in 0..<scene.mNumMaterials {
        material := scene.mMaterials[i]
        sceneData.materials[i] = ProcessMaterial(material)
    }

    // sceneData.textures = make([]TextureData, scene.mNumTextures)
    // for i in 0..<scene.mNumTextures {
    //     texture := scene.mTextures[i]
    //     texData := &sceneData.textures[i]
    //     texData.width = texture.mWidth
    //     texData.height = texture.mHeight
    //     texData.channels = 4 // BGRA
    //     texData.data = make([]u8, texture.mWidth * texture.mHeight * 4)

    //     for j in 0..<(texture.mWidth * texture.mHeight) {
    //         texel := texture.pcData[j]
    //         texData.data[j * 4 + 0] = texel.b
    //         texData.data[j * 4 + 1] = texel.g
    //         texData.data[j * 4 + 2] = texel.r
    //         texData.data[j * 4 + 3] = texel.a
    //     }
    // }

    sceneDataMap[scene_name]  = sceneData
    loadedObjects[scene_name] = true
    
    fmt.eprintfln("Successfully processed scene: {}", scene_name)
    return true
}

CleanupSceneData :: proc(scene_name: cstring) {
    if data, exists := sceneDataMap[scene_name]; exists {
        for &mesh in data.meshes {
            delete(mesh.vertices)
            delete(mesh.indices)
            for k, v in mesh.bone_mapping {
                delete(k)
                delete_key(&mesh.bone_mapping, k)
            }
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