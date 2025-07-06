# `samplers.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan samplers.

## `Samplers` procedure

This procedure creates the samplers used in the application. Currently, it creates a sampler specifically for the G-Buffers. Samplers define how texture data is sampled in shaders, including filtering, addressing modes, and anisotropy.

The G-Buffer sampler is configured with:

-   **Linear filtering:** For both magnification and minification.
-   **Clamp to edge addressing mode:** For all U, V, and W coordinates.
-   **Anisotropy disabled:** For simplicity.
-   **Opaque black border color:** For sampling outside the texture coordinates.
-   **No unnormalized coordinates:** Coordinates are expected to be in the [0, 1) range.
-   **No compare enable:** Not used for depth comparison.
-   **Linear mipmap mode:** For mipmap level selection.
