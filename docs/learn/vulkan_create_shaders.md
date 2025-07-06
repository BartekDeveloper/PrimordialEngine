# `shaders.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan shader stages.

## `ShaderStages` procedure

This procedure creates a slice of `vk.PipelineShaderStageCreateInfo` structs from a list of shader references. It takes the Vulkan data, a function to get the shader module, and a variadic list of `t.ShaderReference` structs as input. For each shader reference, it retrieves the corresponding shader module and creates a `vk.PipelineShaderStageCreateInfo` struct.

## `ShaderStage` procedure

This is a helper procedure that creates a single `vk.PipelineShaderStageCreateInfo` struct. This struct describes a single shader stage in a graphics pipeline, including the shader module, the shader stage (e.g., vertex, fragment), and the entry point function name.
