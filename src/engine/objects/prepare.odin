package objects

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"
import path "core:path/filepath"

// Global model storage - matches your existing pattern
modelModules: map[string]SceneData = {}
modelExists:  map[string]b8        = {}
allLoaded:    bool                 = false

// Get a loaded model by name
GetModel :: proc(name: string) -> (model: SceneData, ok: bool) {
    if modelModules[name] == {} {
        log.errorf("Model '%s' not found!", name)
        return {}, false
    }
    return modelModules[name], true
}

// Check if a model exists
ModelExists :: proc(name: string) -> bool {
    return modelExists[name]
}

// Main interface to load all models from directory - following shader pattern
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
    
    // Support common 3D model formats
    validExts := []string{".gltf", ".glb", ".obj", ".fbx"}
    isValidExt := false
    for validExt in validExts {
        if ext == validExt {
            isValidExt = true
            break
        }
    }
    
    if !isValidExt do return

    log.infof("Found model: %s", f.name)
    
    // Build full path
    fullPath := strings.join({dir, f.name}, "/")
    defer delete(fullPath)
    
    // Use your existing Load_fromFile function
    modelData, loadOk := Load_fromFile(fullPath)
    if !loadOk {
        log.errorf("Failed to load model: %s", f.name)
        return false
    }

    // Use filename without extension as key
    basename := path.base(f.name)
    modelName := basename[:len(basename)-len(ext)]
    
    // Store in global maps
    modelModules[modelName] = modelData
    modelExists[modelName] = true
    
    log.infof("Successfully loaded model: %s", modelName)
    return
}

PrintAllModels :: proc() -> () {
    if len(modelModules) == 0 {
        fmt.eprintln("No models loaded!")
        return
    }
    
    fmt.eprintln("\n=== All Loaded Models ===")
    for name, sceneData in modelModules {
        fmt.eprintfln("Model: %s (from: %s)", name, sceneData.path)
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

ListModelNames :: proc() -> []string {
    names := make([]string, len(modelModules))
    i := 0
    for name in modelModules {
        names[i] = name
        i += 1
    }
    return names
}

CleanUpModels :: proc() -> () {
    // Use your existing CleanUp function for the scenes map
    // CleanUp()
    
    // Clean up our local storage
    for name in modelModules {
        modelExists[name] = false
    }
    
    delete(modelModules)
    delete(modelExists)
    allLoaded = false
    
    log.info("Cleaned up all model modules")
}
