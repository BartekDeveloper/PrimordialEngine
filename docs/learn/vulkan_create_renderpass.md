# `renderpass.odin` (in `vulkan/create`)

This file defines procedures for creating Vulkan render passes, which describe the rendering operations and their dependencies.

## `RenderPasses` procedure

This is the main procedure that creates the render passes for the application. It creates two main render passes:

1.  **Geometry Pass:** This render pass renders the scene geometry into multiple G-Buffer attachments (position, albedo, normal, and depth). The `finalLayout` for the color attachments is set to `SHADER_READ_ONLY_OPTIMAL`, making them ready for use as input to the lighting pass.
2.  **Light Pass:** This render pass takes the G-Buffer attachments as input and calculates the final lit image. It has a subpass dependency that ensures the geometry pass completes before the lighting pass begins.

## `AttachmentDescription` procedure

This is a helper procedure that creates a `vk.AttachmentDescription` struct. This struct describes a single attachment used in a render pass, including its format, load and store operations, and initial and final layouts.

## `Subpass` procedure

This is a helper procedure that creates a `vk.SubpassDescription` struct. This struct describes a subpass within a render pass, including its color and depth attachments.

## `SubpassDependency` procedure

This is a helper procedure that creates a `vk.SubpassDependency` struct. This struct defines a dependency between two subpasses, ensuring that one subpass completes before another begins. It specifies the source and destination subpasses, pipeline stages, and access masks.

## `RenderPass` procedure

This is a helper procedure that creates a `vk.RenderPass` object based on the provided `vk.RenderPassCreateInfo`. It returns a boolean indicating the success of the creation.
