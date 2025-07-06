# `command_buffers.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan command buffers.

## `CommandBuffers` procedure

This procedure creates the primary command buffers used for rendering. It allocates a command buffer for each frame in flight from the global command pool. These command buffers are used to record drawing commands and other Vulkan operations.

## `CommandBuffer` procedure

This is a helper procedure that allocates Vulkan command buffers based on the provided `vk.CommandBufferAllocateInfo`. It returns a boolean indicating the success of the allocation.
