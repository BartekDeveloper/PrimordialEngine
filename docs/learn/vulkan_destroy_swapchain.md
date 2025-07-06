# `swapchain.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying the Vulkan swapchain and its associated resources.

## `Swapchain` procedure

This procedure destroys the Vulkan swapchain. It performs the following steps:

1.  **Destroys Resources:** It calls the `Resources` procedure (from `src/engine/vulkan/destroy/resources.odin`) to destroy the G-Buffers and other resources associated with the swapchain.
2.  **Destroys Image Views:** It iterates through the swapchain image views and destroys each one using `vk.DestroyImageView`.
3.  **Frees Image Memory:** It frees the memory allocated for the swapchain images.
4.  **Destroys Swapchain:** It destroys the swapchain itself using `vk.DestroySwapchainKHR`.
