# `framebuffers.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan framebuffers.

## `FrameBuffers` procedure

This procedure iterates through all render passes stored in `data.passes`. For each render pass, it iterates through its framebuffers and calls the `FrameBuffer` procedure to destroy each one. Finally, it deletes the `frameBuffers` slice and `clearValues` slice (if not empty) for each pass, and then deletes the `passes` map itself.

## `FrameBuffer` procedure

This procedure destroys a single Vulkan framebuffer. It checks if the `fb` handle is valid before destroying it using `vk.DestroyFramebuffer`.
