# `surface.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying the Vulkan surface.

## `Surface` procedure

This procedure destroys the Vulkan surface. It checks if the `surface` handle is valid before destroying it using `vk.DestroySurfaceKHR`.
