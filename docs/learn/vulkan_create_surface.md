# `surface.odin` (in `vulkan/create`)

This file contains the `Surface` procedure.

## `Surface` procedure

This procedure creates a Vulkan surface for the application window. It calls the `win.VulkanCreateSurface` procedure (defined in `src/engine/window/vulkan.odin`) to create the surface, which acts as a bridge between the Vulkan rendering system and the underlying windowing system.
