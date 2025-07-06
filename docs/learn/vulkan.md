# `vulkan.odin`

This file is the heart of the Vulkan renderer. It contains the main `Render` procedure, which is called on every frame to draw the scene.

## `Render` procedure

The `Render` procedure orchestrates the entire rendering process for a single frame. Here's a breakdown of its key responsibilities:

1.  **Synchronization:** It waits for the previous frame to finish rendering before starting a new one, using fences.
2.  **Acquire Swapchain Image:** It acquires the next available image from the swapchain to render into.
3.  **Update Uniform Buffer:** It updates the Uniform Buffer Object (UBO) with the latest data, such as the camera matrices, lighting information, and other global variables.
4.  **Record Command Buffer:** It records a new command buffer for the current frame. This involves:
    *   **Geometry Pass:**
        *   Begins the geometry render pass.
        *   Binds the geometry pipeline.
        *   Binds the UBO descriptor set.
        *   Draws all the objects in the scene.
        *   Ends the geometry render pass.
    *   **Lighting Pass:**
        *   Begins the lighting render pass.
        *   Binds the lighting pipeline.
        *   Binds the UBO and G-Buffer descriptor sets.
        *   Draws a full-screen quad to apply lighting to the scene.
        *   Ends the lighting render pass.
5.  **Submit Command Buffer:** It submits the recorded command buffer to the graphics queue for execution.
6.  **Present Image:** It presents the rendered image to the screen.

## `Wait` procedure

This procedure simply waits for the GPU to finish all its work. It's called before the application exits to ensure that all rendering commands have been processed.

## Global Variables

-   `vkData`: A `t.VulkanData` struct that holds all the core Vulkan data, such as the logical device, swapchain, render passes, and pipelines.
-   `worldTime`: An integer that's incremented on every frame, which can be used for animations.
-   `ii`: The index of the current swapchain image.
