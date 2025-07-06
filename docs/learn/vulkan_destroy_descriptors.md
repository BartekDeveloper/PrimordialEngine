# `descriptors.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan descriptors and descriptor pools.

## `Descriptors` procedure

This procedure iterates through all descriptors stored in `data.descriptors`. For each descriptor, it calls `DescriptorSetLayout` to destroy its layout and then deletes the associated Odin-side memory (bindings, sets, setsLayouts, writes). Finally, it deletes the `descriptors` map itself.

## `DescriptorPools` procedure

This procedure iterates through all descriptor pools stored in `data.descriptorPools` and calls the `DescriptorPool` procedure to destroy each one. Finally, it deletes the `descriptorPools` map itself.

## `DescriptorSetLayout` procedure

This procedure destroys a single Vulkan descriptor set layout. It checks if the `setLayout` handle is valid before destroying it using `vk.DestroyDescriptorSetLayout`.

## `DescriptorPool` procedure

This procedure destroys a single Vulkan descriptor pool. It clears the `createInfo` and `poolCount` fields of the `t.DescriptorPool` struct and then calls `vk.DestroyDescriptorPool` to destroy the underlying Vulkan object.
