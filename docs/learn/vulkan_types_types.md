# `types.odin` (in `vulkan/types`)

This file defines the various data structures used throughout the Vulkan renderer.

## `VulkanData` struct

This is the main struct that encapsulates all the core Vulkan-related data and objects. It acts as a central hub for managing the Vulkan state. Key fields include:

-   `renderData`: General rendering data (from `shared.odin`).
-   `appInfo`: Application information.
-   `instance`: Vulkan instance data.
-   `surface`: The window surface.
-   `physical`: Physical device data.
-   `logical`: Logical device data.
-   `swapchain`: Swapchain data.
-   `samplers`: Map of Vulkan samplers.
-   `passes`: Map of render passes.
-   `descriptorPools`: Map of descriptor pools.
-   `descriptors`: Map of descriptors.
-   `pipelines`: Map of graphics pipelines.
-   `gBuffers`: Map of G-Buffers.
-   `commandPools`: Map of command pools.
-   `commandBuffers`: Map of command buffers.
-   `viewports`: Map of viewports.
-   `scissors`: Map of scissors.
-   `syncObjects`: Synchronization objects (semaphores and fences).
-   `uniformBuffers`: Map of uniform buffers.
-   `frameResized`: Boolean indicating if the window has been resized.
-   `allocations`: Vulkan allocation callbacks.

## `Instance` struct

Stores data related to the Vulkan instance, including extensions, layers, create info, and the debug messenger.

## `Logical` struct

Stores data related to the Vulkan logical device, including queue create infos, extensions, requested features, and the device handle.

## `SwapchainFormats` struct

Stores the formats used by the swapchain, including the surface format, color format, and depth format.

## `Swapchain` struct

Stores data related to the Vulkan swapchain, including its formats, present mode, extent, image count, create info, and lists of images and image views.

## `DescriptorPool` struct

Stores data related to a Vulkan descriptor pool, including its create info, pool sizes, and the pool handle.

## `Descriptor` struct

Stores data related to a Vulkan descriptor set, including its pool name, layout, bindings, and allocated sets.

## `ColorPass` struct

Describes the color attachments and references for a render pass.

## `DepthPass` struct

Describes the depth attachment and reference for a render pass.

## `RenderPass` struct

Stores data related to a Vulkan render pass, including its color and depth passes, subpasses, dependencies, attachments, create info, and framebuffers.

## `PipelinesCreateInfos` union

A union of various Vulkan pipeline create info structs, allowing for flexible pipeline creation.

## `ShaderReference` struct

References a shader by its name and stage.

## `SemaphoreObject` struct

Stores data related to a Vulkan semaphore, including its handle and create info.

## `SemaphoresObjects` struct

Stores image available and render finished semaphores.

## `FenceObject` struct

Stores data related to a Vulkan fence, including its handle and create info.

## `SyncObjects` struct

Stores arrays of semaphore and fence objects for synchronization.

## `CommandPool` struct

Stores data related to a Vulkan command pool, including its create info and handle.

## `CommandBuffer` struct

Stores data related to Vulkan command buffers, including their allocate info and handles.

## `Pipeline` struct

Stores data related to a Vulkan pipeline, including its shaders, stages, layouts, cache, create info, and handle.

## `Buffer` struct

Stores data related to a Vulkan buffer, including its handle, device memory, and mapped pointer.

## `Buffers` struct

Stores create info and a slice of `Buffer` structs.

## `GBuffer` struct

Stores data related to a G-Buffer, including its images, image views, and device memories.

## Type Aliases

-   `vkad`: Alias for `vk.AttachmentDescription`.
-   `vkar`: Alias for `vk.AttachmentReference`.
-   `vibd`: Alias for `vk.VertexInputBindingDescription`.
-   `viad`: Alias for `vk.VertexInputAttributeDescription`.

## `PhysicalDeviceData` struct

Stores detailed information about the chosen physical device, including its features, properties, capabilities, memory properties, formats, modes, and queue families.

## `Queues` struct

Stores handles to the graphics, present, compute, and transfer queues.

## `QueueIndices` struct

Stores the family indices for the graphics, present, compute, and transfer queues.

## `GetModuleProc` procedure type

Defines the signature for a procedure that retrieves a shader module by name.

## `ShaderLang` enum

Defines an enumeration for shader languages (GLSL, SPIRV).
