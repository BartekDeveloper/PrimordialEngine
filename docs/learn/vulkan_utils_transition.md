# `transition.odin` (in `vulkan/utils`)

This file provides a utility procedure for performing image layout transitions using Vulkan pipeline barriers.

## `Transition` procedure

This procedure inserts an image memory barrier into a command buffer to transition an image's layout. It takes the following parameters:

-   `data`: A pointer to the `t.VulkanData` struct.
-   `cmd`: The command buffer to record the barrier into.
-   `image`: The image to transition.
-   `srcStage`: The source pipeline stage.
-   `dstStage`: The destination pipeline stage.
-   `srcAccessMask`: The source access mask.
-   `dstAccessMask`: The destination access mask.
-   `srcLayout`: The old image layout.
-   `dstLayout`: The new image layout.
-   `srcQueueFamilyIndex`: The source queue family index (for ownership transfers).
-   `dstQueueFamilyIndex`: The destination queue family index (for ownership transfers).
-   `aspectMask`: The image aspect mask.
-   `baseMipLevel`: The base mipmap level.
-   `levelCount`: The number of mipmap levels.
-   `baseArrayLayer`: The base array layer.
-   `layerCount`: The number of array layers.

This procedure is crucial for ensuring that image layouts are correct before they are accessed by different pipeline stages or queues, preventing validation errors and ensuring proper rendering.
