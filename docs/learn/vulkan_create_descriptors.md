# `descriptors.odin` (in `vulkan/create`)

This file provides procedures for creating and managing Vulkan descriptors, which are used to bind resources like uniform buffers and sampled images to shaders.

## `ImageInfo` procedure

This procedure populates a `vk.DescriptorImageInfo` struct, which describes an image resource for a descriptor set. It specifies the image view, sampler, and image layout.

## `DescriptorSetLayouts` procedure

This procedure creates the descriptor set layouts used by the application. It sets up layouts for:

-   **Uniform Buffer Object (UBO):** Used to bind uniform buffers containing global data like camera matrices.
-   **G-Buffer Samplers:** Used to bind the G-Buffer images (position, albedo, normal) as sampled images in the lighting pass.

## `DescriptorPools` procedure

This procedure creates the descriptor pools. Descriptor pools are used to allocate individual descriptor sets. It creates a global descriptor pool with enough capacity for uniform buffers and combined image samplers for all frames in flight.

## `DescriptorSets` procedure

This procedure allocates and updates the descriptor sets. It performs the following steps:

1.  **Allocation:** Allocates descriptor sets for the UBO and G-Buffer samplers from the global descriptor pool.
2.  **Updating:** Updates the allocated descriptor sets with the actual buffer and image information. This involves creating `vk.WriteDescriptorSet` structs and calling `vk.UpdateDescriptorSets`.

## `BufferInfo` procedure

This procedure populates a `vk.DescriptorBufferInfo` struct, which describes a buffer resource for a descriptor set. It specifies the buffer, its size, and an offset.

## `DescriptorWrite` procedure

This procedure populates a `vk.WriteDescriptorSet` struct, which is used to update descriptor sets. It specifies the destination descriptor set, binding, type of descriptor, and the resource information (buffer, image, or texel buffer view).

## `DescriptorAllocateInfo` procedure

This procedure populates a `vk.DescriptorSetAllocateInfo` struct, which is used to specify how descriptor sets should be allocated from a descriptor pool.

## `DescriptorAllocate` procedure

This procedure allocates descriptor sets from a descriptor pool based on the provided `vk.DescriptorSetAllocateInfo`. It returns a boolean indicating the success of the allocation.

## `DescriptorPoolCreateInfo` procedure

This procedure populates a `vk.DescriptorPoolCreateInfo` struct, which is used to specify the parameters for creating a descriptor pool.

## `DescriptorPool` procedure

This procedure creates a Vulkan descriptor pool based on the provided `vk.DescriptorPoolCreateInfo`. It returns a `vk.Result` indicating the success or failure of the operation.

## `LayoutBinding` procedure group

This procedure group provides two ways to create `vk.DescriptorSetLayoutBinding` structs, which define the individual bindings within a descriptor set layout:

-   **`LayoutBinding_1`:** Populates a provided `vk.DescriptorSetLayoutBinding` pointer.
-   **`LayoutBinding_2`:** Returns a new `vk.DescriptorSetLayoutBinding` struct.

Both procedures take the binding number, descriptor type, shader stage flags, and descriptor count as input.

## `LayoutInfo` procedure group

This procedure group provides two ways to create `vk.DescriptorSetLayoutCreateInfo` structs, which define the overall layout of a descriptor set:

-   **`LayoutInfo_1`:** Returns a new `vk.DescriptorSetLayoutCreateInfo` struct from a slice of bindings.
-   **`LayoutInfo_2`:** Populates a provided `vk.DescriptorSetLayoutCreateInfo` pointer from a slice of bindings.

## `DescriptorSetLayout` procedure

This procedure creates a Vulkan descriptor set layout based on the provided `vk.DescriptorSetLayoutCreateInfo`. It returns a boolean indicating the success of the creation.
