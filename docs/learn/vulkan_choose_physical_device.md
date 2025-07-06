# `physical_device.odin` (in `vulkan/choose`)

This file contains the logic for selecting the most suitable physical device (i.e., GPU) for the application.

## `PhysicalDevicesData` procedure

This procedure enumerates all available physical devices and scores them based on their capabilities. The device with the highest score is then selected for use.

The scoring is based on a number of factors, including:

-   **Device type:** Discrete GPUs are preferred over integrated GPUs.
-   **Queue families:** The device must support graphics, present, and compute queues.
-   **Features:** The device must support all the required features, such as sampler anisotropy.
-   **Properties:** The device's properties, such as the maximum image dimensions and the maximum number of samplers, are also taken into account.

The procedure returns a `t.PhysicalDeviceData` struct, which contains all the relevant information about the selected device.
