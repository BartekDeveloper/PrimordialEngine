# `swapchain.odin` (in `vulkan/choose`)

This file contains helper functions for choosing swapchain properties.

## `SwapchainExtent` procedure

This procedure returns the extent (i.e., width and height) of the swapchain. It gets the framebuffer size from the window and returns it as a `vk.Extent2D`.

## `SwapchainFormat` procedure

This procedure chooses the best surface format for the swapchain. It queries the available surface formats and scores them based on a list of preferred formats. The format with the highest score is then returned.

## `SwapchainPresentMode` procedure

This procedure chooses the best present mode for the swapchain. It queries the available present modes and scores them based on a list of preferred modes. The mode with the highest score is then returned.

## `SwapchainDepthFormat` procedure

This procedure chooses the best depth format for the swapchain. It calls the `FindSupportedFormat` procedure to find the first supported depth format from a list of candidates.
