# `framebuffers.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan framebuffers.

## `Framebuffers` procedure

This procedure creates the framebuffers for both the geometry and lighting render passes. Framebuffers are collections of image views that serve as rendering targets for a render pass.

For the geometry pass, it creates framebuffers that attach the G-Buffer images (position, albedo, normal, and depth). For the lighting pass, it creates framebuffers that attach the swapchain images and a depth buffer.

## `FrameBuffer` procedure

This is a helper procedure that creates a single Vulkan framebuffer based on the provided `vk.FramebufferCreateInfo`. It takes the Vulkan data, the size of the framebuffer, the render pass it will be used with, and a list of image views to attach as input.
