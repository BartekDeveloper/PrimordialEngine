# `physical_device_data.odin` (in `vulkan/create`)

This file contains the `PhysicalDeviceData` procedure.

## `PhysicalDeviceData` procedure

This procedure selects the most suitable physical device (GPU) for the application. It calls the `choose.PhysicalDevicesData` procedure to enumerate and score all available physical devices, and then stores the chosen device's data in the `physical` field of the `VulkanData` struct.
