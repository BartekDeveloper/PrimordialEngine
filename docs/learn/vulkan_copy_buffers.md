# `buffers.odin` (in `vulkan/copy`)

This file contains helper functions for copying data to Vulkan buffers.

## `ToBuffer` procedure group

This procedure group provides two ways to copy data to a buffer:

-   **`ToBuffer_vulkan`:** This procedure takes a `vk.Buffer` and a `vk.DeviceMemory` object as input. It maps the memory, copies the data, and then unmaps the memory.
-   **`ToBuffer_unified`:** This procedure takes a `t.Buffer` struct as input. It maps the memory, copies the data, and then unmaps the memory.
