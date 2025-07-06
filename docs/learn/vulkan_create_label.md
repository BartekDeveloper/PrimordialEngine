# `label.odin` (in `vulkan/create`)

This file provides helper procedures for setting debug names (labels) for Vulkan objects. These labels are useful for debugging and profiling Vulkan applications, as they allow you to identify specific objects in tools like RenderDoc.

## `Label` procedure group

This procedure group provides several ways to set labels for Vulkan objects:

-   **`Label_single`:** Sets a label for a single Vulkan object. It takes the device, a string for the label, the object's handle, and its type as input.
-   **`Label_mutliple_1`:** Sets labels for multiple Vulkan objects provided as a slice of handles. It appends an index to each label.
-   **`Label_mutliple_2`:** Sets labels for multiple Vulkan objects provided as a pointer to an array of handles and a count. It appends an index to each label.
-   **`Label_gbuffer`:** Sets labels for the images, image views, and memory associated with a G-Buffer. It appends an index to each label.

These procedures are only active when the `ODIN_DEBUG` flag is enabled during compilation.
