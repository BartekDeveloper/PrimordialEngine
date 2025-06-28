package vk_load

import path "core:path/filepath"
import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "core:strings"
import rn "base:runtime"

import vk "vendor:vulkan"
import t "../types"

shaderModules: map[string]vk.ShaderModule = {}
exists:        map[string]b8              = {}
allExits:      bool                       = false
data:          ^t.VulkanData              = nil

SetVulkanDataPointer    :: proc(pData: ^t.VulkanData) { data = pData }
UnSetVulkanDataPointer :: proc() { data = nil }

GetModule :: proc(
    pName: string 
) -> (module: vk.ShaderModule) {   
    if shaderModules[pName] != {} do return shaderModules[pName]
    panic("Shader module not found!")
}

Shaders :: proc(
    dir:  string = "./assets/shaders",
) -> () {
    handle: os.Handle
    err:    os.Error
    files:  []os.File_Info
    
    fmt.eprintln("\n\n")

    handle, err = os.open(dir)
    defer os.close(handle)

    if err != nil {
        log.error("Failed to open shaders directory!")
        return
    }

    files, err = os.read_dir(handle, -1, context.temp_allocator)
    if err != nil {
        log.error("Failed to read shaders directory!")
        return
    }

    for &f, i in files {
        ProcessShaderFile(&f, i, dir)
    }
    fmt.eprintfln("Exists: \n\t {}\n\n", exists)

    return
}

ProcessShaderFile :: proc(
    f: ^os.File_Info,
    #any_int index: u32,
    dir: string
) -> (ok: bool = true) {
    if f.is_dir do return
    
    ext := path.ext(f.name)
    ext = strings.to_lower(ext, context.temp_allocator)
    if ext != ".spv" do return

    log.infof("Found shader: %s", f.name)
    shaderModules[f.name], ok = CreateShaderModule(f.name, dir)
    if !ok {
        log.error("Failed to create shader module!")
        return
    }

    exists[f.name] = true
    return
}

CreateShaderModule :: proc(
    name: string,
    dir: string
) -> (module: vk.ShaderModule, good: bool = true) #optional_ok {

    module = vk.ShaderModule{}
    path := strings.join({ dir, name }, "/")
    defer delete(path)

    fmt.eprintfln("Reading shader: %s", path)
    shaderCode, ok := os.read_entire_file_from_filename(path)
    if shaderCode == nil {
        log.error("Failed to read shader code!")
        return
    }

    shaderCodeSize := len(shaderCode)    
    fmt.eprintfln("Shader code size: %d", shaderCodeSize)

    moduleInfo := vk.ShaderModuleCreateInfo{
        sType    = .SHADER_MODULE_CREATE_INFO,
        codeSize = shaderCodeSize,
        pCode    = ([^]u32)(raw_data(shaderCode)),
    }
    assert(data.logical.device != nil, "Initialize Vulkan device first!")
    defer delete(shaderCode)

    result := vk.CreateShaderModule(
        data.logical.device,
        &moduleInfo,   
        data.allocations,
        &module
    )
    if result != .SUCCESS {
        log.error("Failed to create shader module!")
        return
    }
    log.infof("Created shader module: %s", name)

    return
}

CleanUpShaderModules :: proc() -> () {
    for k, &module in shaderModules {
        vk.DestroyShaderModule(
            data.logical.device,
            module,
            data.allocations
        )
        shaderModules[k] = {}
        exists[k] = false
    }
    
    delete(shaderModules)
    delete(exists)

    return
}