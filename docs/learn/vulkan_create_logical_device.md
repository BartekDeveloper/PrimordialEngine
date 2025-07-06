# `logical_device.odin` (in `vulkan/create`)

This file handles the creation of the Vulkan logical device, which is the software interface to the physical device (GPU).

## `LogicalDevice` procedure

This procedure creates the Vulkan logical device. It performs the following steps:

1.  **Configures Queue Create Infos:** It sets up `vk.DeviceQueueCreateInfo` structs for each unique queue family (graphics, present, compute, transfer) found on the physical device. This specifies the queues that the logical device will expose.
2.  **Configures Device Create Info:** It populates a `vk.DeviceCreateInfo` struct with information about the requested queues, enabled extensions (like `VK_KHR_SWAPCHAIN_EXTENSION_NAME`), enabled validation layers (if `ENABLE_VALIDATION_LAYERS` is true), and enabled physical device features (like `samplerAnisotropy`).
3.  **Creates Logical Device:** It calls `vk.CreateDevice` to create the Vulkan logical device.
4.  **Loads Device Addresses:** It loads the Vulkan function pointers specific to the created logical device.
5.  **Retrieves Queues:** It retrieves the handles to the graphics, present, compute, and transfer queues from the logical device.
