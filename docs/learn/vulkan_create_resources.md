# `resources.odin` (in `vulkan/create`)

This file is responsible for creating various Vulkan resources, primarily the G-Buffers.

## `Resources` procedure

This procedure creates the G-Buffers used in the deferred rendering pipeline. It initializes several `t.GBuffer` structs and then calls the `GBuffer` helper procedure to create the images, image views, and memory for each G-Buffer.

The G-Buffers created include:

-   **`geometry.position`**: Stores the world-space position of each fragment.
-   **`geometry.albedo`**: Stores the base color (albedo) of each fragment.
-   **`geometry.normal`**: Stores the world-space normal of each fragment.
-   **`geometry.depth`**: Stores the depth information for the geometry pass.
-   **`light.color`**: Stores the final lit color output of the lighting pass.
-   **`light.depth`**: Stores the depth information for the lighting pass.

Each G-Buffer is created with specific formats, usage flags, and memory properties suitable for its purpose.

## `GBuffer` procedure

This is a helper procedure that creates a G-Buffer. It allocates images, image views, and device memory for the specified G-Buffer. It takes the Vulkan data, a `t.GBuffer` struct, format, dimensions, tiling, usage flags, memory flags, and aspect mask as input.
