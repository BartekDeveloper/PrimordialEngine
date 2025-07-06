# `image_view.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying Vulkan image views.

## `ImageView` procedure

This procedure destroys a single Vulkan image view. It takes the `VulkanData` struct and a pointer to a `vk.ImageView` handle as input. It calls `vk.DestroyImageView` to destroy the underlying Vulkan image view object.
