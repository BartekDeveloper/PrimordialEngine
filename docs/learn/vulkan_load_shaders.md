# `shaders.odin` (in `vulkan/load`)

This file is responsible for loading and managing Vulkan shader modules.

## Global Variables

-   `shaderModules`: A map that stores loaded shader modules, keyed by their filenames.
-   `exists`: A map that tracks whether a shader module exists, keyed by its filename.
-   `allExits`: A boolean flag, currently unused.
-   `data`: A pointer to the `t.VulkanData` struct, providing access to Vulkan-related data.

## `SetVulkanDataPointer` procedure

Sets the `data` global variable to the provided `t.VulkanData` pointer.

## `UnSetVulkanDataPointer` procedure

Sets the `data` global variable to `nil`.

## `GetModule` procedure

Retrieves a loaded shader module by its filename. Panics if the module is not found.

## `Shaders` procedure

This procedure loads all shader modules from a specified directory (defaults to `./assets/shaders`). It iterates through the files in the directory, processes each shader file, and creates a shader module for it.

## `ProcessShaderFile` procedure

This procedure processes a single shader file. It checks if the file has a `.spv` extension (SPIR-V bytecode) and then calls `CreateShaderModule` to create a Vulkan shader module from its contents.

## `CreateShaderModule` procedure

This procedure creates a Vulkan shader module from the provided shader code. It reads the shader code from the specified file, creates a `vk.ShaderModuleCreateInfo` struct, and then calls `vk.CreateShaderModule` to create the shader module.

## `CleanUpShaderModules` procedure

This procedure destroys all loaded shader modules and frees their associated resources. It iterates through the `shaderModules` map, destroys each module using `vk.DestroyShaderModule`, and then clears the `shaderModules` and `exists` maps.
