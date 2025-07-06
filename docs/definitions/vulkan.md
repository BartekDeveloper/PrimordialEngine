package vulkan_renderer
	variables
		ii: u32 = 0
		vkData: t.VulkanData = {}
		worldTime: int = 0

	procedures
		Clean :: proc(data: ^s.RenderData) {...}
		Init :: proc(rData: ^s.RenderData) {...}
		InitFromZero :: proc(data: ^t.VulkanData = nil, rData: ^s.RenderData = nil) ->  {...}
		Render :: proc(rData: ^s.RenderData = nil) ->  {...}
		Wait :: proc() {...}


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan
	files:
		destroy.odin
		init.odin
		vulkan.odin
