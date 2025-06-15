package vk_load

import "core:log"
import "core:c"
import "core:os"
import "core:mem"
import "core:fmt"
import "core:strings"
import path "core:path/filepath"
import "base:runtime"

import vk "vendor:vulkan"
import t "../types"

shaderModules: map[string]vk.ShaderModule = {}
exists:        map[string]b8              = {}
allExits:      bool                       = false
data:          ^t.VulkanData              = nil

SetVulkanDataPointer    :: proc(pData: ^t.VulkanData) { data = pData }
RemoveVulkanDataPointer :: proc() { data = nil }

GetModule :: proc(
    pName: string
) -> (module: vk.ShaderModule) {   
    if shaderModules[pName] != {} {
        return shaderModules[pName]
    }

    when ODIN_DEBUG {
        panic("Shader module not found!")
    } else {
        return
    }
}

Shaders :: proc(
    dir:  string = "./assets/shaders",
) -> () {
    handle: os.Handle
    err:    os.Error
    files:  []os.File_Info
    
    fmt.eprintln("\n\n")

    handle, err = os.open(dir)
    if err != nil {
        log.error("Failed to open shaders directory!")
        return
    }

    files, err = os.read_dir(handle, -1)
    if err != nil {
        log.error("Failed to read shaders directory!")
        return
    }

    for f, i in files {
        if f.is_dir {
            continue
        }

        name := f.name
        ext  := strings.to_lower(path.ext(name))
        if ext != ".spv" {
            continue
        }
        log.infof("Found shader: %s", name)
        
        ok: bool = false
        shaderModules[name], ok = CreateShaderModule(name, dir)
        if ok {
            exists[name] = true
        } else {
            log.error("Failed to create shader module!")
        }
    }
    fmt.eprintln("Exists: \n\t", exists)
    fmt.eprintln("\n\n")

    return
}

CreateShaderModule :: proc(
    name:   string       = "shader",
    dir:    string       = "./assets/shaders"
) -> (module: vk.ShaderModule, good: bool = true) #optional_ok {
    module = vk.ShaderModule{}
    path := strings.join({ dir, name }, "/")
    
    fmt.eprintfln("Reading shader: %s", path)
    shaderCode, ok := os.read_entire_file_from_filename(path, context.temp_allocator)
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

    result := vk.CreateShaderModule(
        data.logical.device,
        &moduleInfo,   
        nil,
        &module
    )
    if result != .SUCCESS {
        log.error("Failed to create shader module!")
        return
    }
    log.infof("Created shader module: %s", name)

    return
}