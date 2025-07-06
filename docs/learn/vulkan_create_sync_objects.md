# `sync_objects.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan synchronization objects, specifically semaphores and fences.

## `SyncObjects` procedure

This procedure creates the synchronization objects needed for the rendering loop. It creates:

-   **Semaphores:** One image available semaphore and one render finished semaphore for each swapchain image. Semaphores are used to signal when an image is available for rendering and when rendering to an image is complete.
-   **Fences:** One fence for each frame in flight. Fences are used to signal when the GPU has finished executing commands for a particular frame, allowing the CPU to safely reuse resources.
