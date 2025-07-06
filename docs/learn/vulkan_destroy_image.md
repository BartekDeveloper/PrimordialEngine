# `image.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying Vulkan images.

## `Image` procedure

This procedure destroys a single Vulkan image. It takes the `VulkanData` struct and a pointer to a `vk.Image` handle as input. It calls `vk.DestroyImage` to destroy the underlying Vulkan image object.
