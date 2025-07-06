# `resources.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan resources, primarily G-Buffers.

## `Resources` procedure

This procedure iterates through all G-Buffers stored in `data.gBuffers` and calls the `GBuffer` procedure to destroy each one. Finally, it deletes the `gBuffers` map itself.

## `GBuffer` procedure

This procedure destroys a single G-Buffer. It iterates through the images, image views, and memory associated with the G-Buffer and calls the respective `Image`, `ImageView`, and `Memory` destruction procedures for each. Finally, it deletes the slices holding the images, views, and memory.
