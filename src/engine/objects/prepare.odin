package objects

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"
import path "core:path/filepath"

GetModel :: proc(name: string) -> (model: SceneData, ok: bool = true) {
    return modelGroups[name]
}

ModelExists :: proc(name: string) -> bool {
    return (bool)(modelExists[name])
}

LoadModels :: proc(
    dir: string = "./assets/models",
) -> () {
    handle: os.Handle
    err:    os.Error
    files:  []os.File_Info
    
    fmt.eprintln("\n=== Loading Models ===")

    handle, err = os.open(dir)
    defer os.close(handle)

    if err != nil {
        log.error("Failed to open models directory!")
        return
    }

    files, err = os.read_dir(handle, -1, context.temp_allocator)
    if err != nil {
        log.error("Failed to read models directory!")
        return
    }

    for &f, i in files {
        ProcessModelFile(&f, i, dir)
    }
    
    fmt.eprintfln("Loaded models: \n\t{}\n", modelExists)
    allLoaded = true
    return
}

ProcessModelFile :: proc(
    f: ^os.File_Info,
    #any_int index: u32,
    dir: string
) -> (ok: bool = true) {
    if f.is_dir do return
    
    ext := path.ext(f.name)
    ext = strings.to_lower(ext, context.temp_allocator)
    
    validExts := []string{ ".gltf", ".glb" }
    isValidExt := false
    for validExt in validExts {
        if ext == validExt {
            isValidExt = true
            break
        }
    }
    
    if !isValidExt do return

    log.infof("Found model: %s", f.name)
    
    fullPath := strings.join({dir, f.name}, "/")
    defer delete(fullPath)
    
    modelData, loadOk := Load_fromFile(fullPath)
    if !loadOk {
        log.errorf("Failed to load model: %s", f.name)
        return false
    }

    basename := path.base(f.name)
    modelName := basename[:len(basename)-len(ext)]
    
    modelGroups[modelName] = modelData
    modelExists[modelName] = true
    
    log.infof("Successfully loaded model: %s", modelName)
    return
}

PrintAllModels :: proc() -> () {
    if len(modelGroups) == 0 {
        fmt.eprintln("No models loaded!")
        return
    }

    fmt.eprintln("\n=== All Loaded Models ===")
    for name, sceneData in modelGroups {
        fmt.eprintfln("Scene: %s (from: %s)", name, sceneData.path)
        fmt.eprintfln("\tObjects count: %d", len(sceneData.objects))
        
        for modelName, model in sceneData.objects {
            fmt.eprintfln("\t\tModel: %s", modelName)
            fmt.eprintfln("\t\tMeshes count: %d", len(model.meshes))
            
            for meshName, mesh in model.meshes {
                fmt.eprintfln("\t\t\tMesh: %s", meshName)
                fmt.eprintfln("\t\t\t\tVertices: %d", len(mesh.vertices))
                fmt.eprintfln("\t\t\t\tIndices: %d", len(mesh.indices))
                fmt.eprintfln("\t\t\t\tType: %v", mesh.type)
            }
        }
    }
    fmt.eprintln("========================\n")
}

ListModelNames :: proc() -> (oNames: []string) {
    names: [dynamic]string = {}
    defer delete(names)
    i := 0
    for name in modelGroups {
        if name == "" || name == " " || strings.is_null(auto_cast name[0]) {
            continue
        }
        
        append(&names, name)
        
        i += 1
    }

    oNames = make([]string, len(names))
    for &name, i in names {
        oNames[i] = name
    }
    return
}

CleanUpModels :: proc() -> () { 
    CleanUp()

    for model, &exist in modelExists {
        exist = false
        delete_key(&modelExists, model)
    }
    if modelExists != nil do delete(modelExists)
    allLoaded = false
    
    fmt.eprintln("Cleaned up all model modules")
}
