package vk_choose
	procedures
		FindSupportedFormat :: proc(data: ^t.VulkanData = nil, candidates: []vk.Format = {}, tiling: vk.ImageTiling = .OPTIMAL, features: vk.FormatFeatureFlags = {}) -> (supportedFormat: vk.Format, ok: bool = true) {...}
		HasStencil :: proc(format: vk.Format) -> bool {...}
		MemoryType_modify :: proc(physicalDevice: vk.PhysicalDevice = nil, typeFilter: u32 = 0, properties: vk.MemoryPropertyFlags = {}, memoryTypeIndex: ^u32 = nil) -> (good: bool = true) {...}
		MemoryType_return :: proc(physicalDevice: vk.PhysicalDevice = nil, typeFilter: u32 = 0, properties: vk.MemoryPropertyFlags = {}) -> (memoryTypeIndex: u32, ok: bool) {...}
		PhysicalDevicesData :: proc(instance: vk.Instance, surface: vk.SurfaceKHR) -> (chosenPhysicalDeviceData: t.PhysicalDeviceData) {...}
		SwapchainDepthFormat :: proc(data: ^t.VulkanData) -> (found: vk.Format = .D32_SFLOAT_S8_UINT, good: bool = true) {...}
		SwapchainExtent :: proc(data: ^t.VulkanData) -> (extent: vk.Extent2D = {}) {...}
		SwapchainFormat :: proc(data: ^t.VulkanData) -> (surfaceFormat: vk.SurfaceFormatKHR) {...}
		SwapchainPresentMode :: proc(data: ^t.VulkanData) -> (presentMode: vk.PresentModeKHR) {...}

	proc_group
		MemoryType :: proc{MemoryType_return, MemoryType_modify}


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan/choose
	files:
		format.odin
		memory.odin
		physical_device.odin
		swapchain.odin
