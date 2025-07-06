# `renderpass.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan render passes.

## `RenderPasses` procedure

This procedure iterates through all render passes stored in `data.passes` and calls the `RenderPass` procedure to destroy each one. It then deletes the `passes` map itself.

## `RenderPass` procedure

This procedure destroys a single Vulkan render pass. It checks if the `renderPass` handle is valid before destroying it using `vk.DestroyRenderPass`.
