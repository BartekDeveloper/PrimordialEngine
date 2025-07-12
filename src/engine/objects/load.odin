package eobjects

import "core:c"
import "core:fmt"
import "core:strings"
import "core:os"

import ass "../../../external/assimp/odin-assimp"

loadedObjects: map[cstring]bool = {};


LoadAllObjects :: proc(dir: string = "./assets/models") {
    handle: os.Handle
    err:    os.Error
    files:  []os.File_Info

    fmt.eprintln("\n=== Loading All Objects ===")
    handle, err = os.open(dir)
    defer os.close(handle)

    if err != nil {
        fmt.eprintln("Failed to open models directory!")
        return
    }

    files, err = os.read_dir(handle, -1, context.temp_allocator)
    if err != nil {
        fmt.eprintln("Failed to read models directory!")
        return
    }

    for &f, i in files {
        if f.is_dir do continue

        scene := ReadFromFile(f.name, dir)
        if scene != nil {

            scene_key := strings.clone_to_cstring(f.name, context.temp_allocator)
            ok := ProcessSceneData(scene, scene_key)
            if ok do loadedObjects[scene_key] = true
        }
    }

    fmt.eprintfln("Loaded objects: \n\t{}\n", loadedObjects)
}


CleanAllObjects :: proc() {
    fmt.eprintln("\n=== Cleaning All Objects ===")
    for name, _ in loadedObjects {
        CleanupSceneData(name)
    }
    delete(loadedObjects)
    delete(sceneDataMap)
    
    fmt.eprintln("All objects cleaned.")
}
