package eobjects

import "core:c"
import "core:os"
import "core:io"
import "core:fmt"
import "core:strings"

import ass "../../../external/assimp/odin-assimp"

allLoaded: bool = false


ReadFromFile :: proc(
    file: string,
    models_dir: string = "./assets/models",
) -> (scene: ^ass.Scene = nil) {

    strpath: string = ""
    path: cstring = ""

    strpath = strings.join({ models_dir, file }, "/", context.temp_allocator,)
    path    = strings.clone_to_cstring(strpath, context.temp_allocator)

    fmt.eprintln("Scene path: ", strpath)
    fmt.eprintln("Scene c path: ", path)

    fmt.eprintln("Loading scene from file...")
    flags: ass.Post_Process_Step_Flags = { .Triangulate, .FlipUVs, .GenNormals }


    scene = ass.ImportFile(
        path,
        flags
    )
    if scene == nil {
        fmt.eprintln("Failed to load scene from file!")
        fmt.eprintfln("\t {}", ass.GetErrorString())
        return
    }

    fmt.eprintln("Scene loaded from file!")


    return
}



ReadFromMemory :: proc(
    buffer: cstring,
    size: u32,
) -> (scene: ^ass.Scene = nil) {
    fmt.eprintln("Loading scene from file...")
    flags: ass.Post_Process_Step_Flags = { .Triangulate, .FlipUVs, .GenNormals }


    scene = ass.ImportFileFromMemory(
        buffer,
        size,
        flags,
        ""
    )
    if scene == nil {
        fmt.eprintln("Failed to load scene from file!")
        fmt.eprintfln("\t {}", ass.GetErrorString())
        return
    }

    fmt.eprintln("Scene loaded from file!")\

    return
}


ReadAllFilesFromDir :: proc(
    dir: string = "./assets/models",
) -> () {
    handle: os.Handle
    err:    os.Error
    files:  []os.File_Info


    fmt.eprintln("\n=== Loading Models ===")
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
        scene := ReadFromFile(f.name)
        _ = scene
        // ProcessData(scene, f.name, dir)
    }


    fmt.eprintfln("Loaded models: \n\t{}\n", loadedObjects)
    allLoaded = true


    return
}


ReadAllFilesFromMemory :: proc(
    buffer: []cstring,
    sizes:  []u32    ,
) -> () {

    fmt.eprintln("\n=== Loading Models ===")

    for &b, i in buffer {
        scene := ReadFromMemory(b, sizes[i])
        _ = scene
    }

    fmt.eprintfln("Loaded models: \n\t{}\n", loadedObjects)
    allLoaded = true


    return
}