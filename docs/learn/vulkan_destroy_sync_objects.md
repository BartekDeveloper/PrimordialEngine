# `sync_objects.odin` (in `vulkan/destroy`)

This file provides a procedure for destroying Vulkan synchronization objects (semaphores and fences).

## `SyncObjects` procedure

This procedure destroys all semaphores and fences created for synchronization. It iterates through the `semaphores` and `fences` slices within the `t.SyncObjects` struct and calls `vk.DestroySemaphore` and `vk.DestroyFence` respectively to destroy the underlying Vulkan objects. Finally, it deletes the slices themselves.
