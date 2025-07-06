# `buffers.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan buffers and their associated memory.

## `UniformBuffers` procedure

This procedure iterates through all uniform buffers stored in `data.uniformBuffers` and calls the `Buffers` procedure to destroy each one. Finally, it deletes the `uniformBuffers` map itself.

## `Buffer` procedure

This procedure destroys a single Vulkan buffer and frees its associated device memory. It takes the `VulkanData` struct and a pointer to a `t.Buffer` struct as input. It checks if the buffer and memory handles are valid before destroying them using `vk.DestroyBuffer` and `vk.FreeMemory`.

## `Buffers` procedure

This procedure iterates through a slice of `t.Buffer` structs and calls the `Buffer` procedure to destroy each individual buffer.
