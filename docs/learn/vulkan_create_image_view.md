# `image_view.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan image views.

## `ImageView` procedure group

This procedure group provides two ways to create Vulkan image views:

-   **`ImageView_return`:** This procedure creates a `vk.ImageView` and returns it along with a boolean indicating success. It takes various parameters such as the image, format, aspect mask, and mipmap levels.
-   **`ImageView_modify`:** This procedure creates a `vk.ImageView` and modifies a provided `vk.ImageView` pointer to store the created image view. It returns a boolean indicating success.

Both procedures handle the creation of the image view, which provides a way to interpret the image data.
