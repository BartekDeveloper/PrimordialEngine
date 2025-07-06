# `command_pools.odin` (in `vulkan/create`)

This file provides procedures for creating Vulkan command pools.

## `CommandPools` procedure

This procedure creates the command pools used by the application. Currently, it creates a single global graphics command pool. Command pools manage the memory from which command buffers are allocated.

## `CommandPool` procedure

This is a helper procedure that creates a Vulkan command pool based on the provided `vk.CommandPoolCreateInfo`. It returns a boolean indicating the success of the creation.
