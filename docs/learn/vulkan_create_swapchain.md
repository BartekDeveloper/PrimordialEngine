# `swapchain.odin` (in `vulkan/create`)

This file handles the creation of the Vulkan swapchain, which is responsible for presenting rendered images to the screen.

## `Swapchain` procedure

This procedure creates the Vulkan swapchain. It performs the following steps:

1.  **Chooses Swapchain Properties:** It uses helper procedures from the `choose` package to determine the optimal swapchain extent (resolution), surface format (color space and format), and present mode (how images are presented to the screen).
2.  **Determines Image Count:** It calculates the number of images the swapchain should contain, based on the physical device capabilities.
3.  **Configures Swapchain Create Info:** It populates a `vk.SwapchainCreateInfoKHR` struct with all the chosen properties, including image usage, sharing mode, and pre-transform.
4.  **Creates Swapchain:** It calls `vk.CreateSwapchainKHR` to create the Vulkan swapchain.
5.  **Retrieves Swapchain Images:** It calls `SwapchainImages` to get the handles to the images owned by the swapchain.

## `SwapchainImages` procedure

This procedure retrieves the images from the created swapchain and creates image views for each of them. These image views are then used as color attachments in the rendering process.
