# `image.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan images.

## `Image` procedure group

This procedure group provides two ways to create Vulkan images:

-   **`Image_return`:** This procedure creates a `vk.Image` and allocates device memory for it. It returns the created image and a boolean indicating success. It takes various parameters such as width, height, format, usage, and memory properties.
-   **`Image_modify`:** This procedure creates a `vk.Image` and allocates device memory for it, similar to `Image_return`. However, instead of returning the image, it modifies a provided `vk.Image` pointer to store the created image. It returns a boolean indicating success.

Both procedures handle the creation of the image, querying memory requirements, allocating memory, and binding the memory to the image.
