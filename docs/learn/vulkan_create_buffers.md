# `buffers.odin` (in `vulkan/create`)

This file provides procedures for creating and managing Vulkan buffers, particularly uniform buffers.

## `UniformBuffers` procedure

This procedure creates uniform buffers for the application. It allocates a uniform buffer for each frame in flight, maps its memory, and stores it in the `uniformBuffers` map within the `VulkanData` struct. These buffers are used to store data that is frequently updated and accessed by shaders, such as camera matrices and lighting parameters.

## `Buffer` procedure group

This procedure group provides two ways to create Vulkan buffers:

-   **`Buffer_return`:** This procedure creates a `vk.Buffer` and allocates device memory for it. It returns the created buffer and a boolean indicating success. It takes the Vulkan data, size, usage flags, and memory properties as input.
-   **`Buffer_modify`:** This procedure creates a `vk.Buffer` and allocates device memory for it, similar to `Buffer_return`. However, instead of returning the buffer, it modifies a provided `t.Buffer` struct to store the created buffer and its associated memory. It returns a boolean indicating success.

Both procedures handle the creation of the buffer, querying memory requirements, allocating memory, and binding the memory to the buffer.

## `MapMemory` procedure

This procedure maps a region of device memory into host-accessible memory. This allows the CPU to write data directly to the GPU's memory. It takes the Vulkan data, a `t.Buffer` struct, the size of the memory to map, and memory map flags as input. It returns a `vk.Result` indicating the success or failure of the operation.
