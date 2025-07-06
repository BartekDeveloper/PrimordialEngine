# `vulkan.odin` (in `window`)

This file provides a bridge between the windowing system (SDL3) and the Vulkan renderer.

## `ProcAddr` variable

This variable stores a pointer to the `sdl.Vulkan_GetVkGetInstanceProcAddr` function, which is used by Vulkan to get the addresses of Vulkan functions.

## `VulkanCreateSurface` procedure

This procedure creates a Vulkan surface for the application window. The surface is an abstraction of the native window that Vulkan can render to.
