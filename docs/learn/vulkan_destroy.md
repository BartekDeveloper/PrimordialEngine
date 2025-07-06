# `destroy.odin` (in `vulkan`)

This file contains the `Clean` procedure, which is responsible for cleaning up all Vulkan resources.

## `Clean` procedure

This procedure is called when the application is shutting down. It calls a series of `destroy` procedures (defined in `src/engine/vulkan/destroy/`) to free all allocated Vulkan resources in the reverse order of their creation. This includes:

-   Buffers
-   Synchronization objects (semaphores and fences)
-   Samplers
-   Descriptor pools
-   Command pools and buffers
-   Framebuffers
-   Pipelines
-   Render passes
-   The swapchain
-   The logical and physical devices
-   The Vulkan instance
