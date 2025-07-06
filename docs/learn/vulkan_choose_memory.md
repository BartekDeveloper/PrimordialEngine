# `memory.odin` (in `vulkan/choose`)

This file contains helper functions for choosing Vulkan memory types.

## `MemoryType` procedure group

This procedure group provides two ways to find a suitable memory type:

-   **`MemoryType_return`:** This procedure returns the index of the first suitable memory type it finds. It panics if no suitable memory type is found.
-   **`MemoryType_modify`:** This procedure modifies a pointer to a `u32` to store the index of the first suitable memory type it finds. It returns `false` if no suitable memory type is found.

Both procedures take a physical device, a type filter, and a set of memory properties as input. The type filter is a bitmask that specifies the allowed memory types. The memory properties specify the required properties of the memory, such as whether it should be host-visible or device-local.
