# `init.odin` (in `vulkan`)

This file contains the `Init` and `InitFromZero` procedures, which are responsible for initializing the Vulkan renderer.

## `Init` procedure

This procedure is the main entry point for initializing the Vulkan renderer. It simply calls the `InitFromZero` procedure.

## `InitFromZero` procedure

This procedure performs the bulk of the Vulkan initialization. It creates all the necessary Vulkan objects, in the correct order, by calling a series of `create` procedures (defined in `src/engine/vulkan/create/`). This includes:

-   The Vulkan instance
-   The window surface
-   The physical and logical devices
-   The swapchain
-   The render passes
-   The descriptor set layouts
-   The pipelines
-   The framebuffers
-   The command pools and buffers
-   The uniform buffers
-   The descriptor pools
-   The samplers
-   The descriptor sets
-   The synchronization objects (semaphores and fences)

It also loads the shaders and creates the vertex and index buffers for all the 3D models.
