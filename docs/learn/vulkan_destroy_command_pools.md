# `command_pools.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan command pools.

## `CommandPools` procedure

This procedure iterates through all command pools stored in `data.commandPools` and calls the `CommandPool` procedure to destroy each one. Finally, it deletes the `commandPools` map itself.

## `CommandPool` procedure

This procedure destroys a single Vulkan command pool. It sets the `createInfo` field of the `t.CommandPool` struct to an empty struct and then calls `vk.DestroyCommandPool` to destroy the underlying Vulkan object.
