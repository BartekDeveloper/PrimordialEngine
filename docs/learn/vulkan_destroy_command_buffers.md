# `command_buffers.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan command buffers.

## `CommandBuffers` procedure

This procedure iterates through all command buffers stored in `data.commandBuffers` and deletes the underlying memory for each. Finally, it deletes the `commandBuffers` map itself. Note that Vulkan command buffers are implicitly freed when their parent command pool is destroyed, so this primarily cleans up the Odin-side memory.
