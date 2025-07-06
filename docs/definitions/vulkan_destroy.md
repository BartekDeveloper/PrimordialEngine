package vk_destroy
	procedures
		AdditionalData :: proc(data: ^t.VulkanData = nil) ->  {...}
		AppInfo :: proc(data: ^t.VulkanData = nil) ->  {...}
		Buffer :: proc(data: ^t.VulkanData = nil, buffer: ^t.Buffer = nil) ->  {...}
		Buffers :: proc(data: ^t.VulkanData = nil, buffers: ^t.Buffers = nil) ->  {...}
		CommandBuffers :: proc(data: ^t.VulkanData = nil) ->  {...}
		CommandPool :: proc(data: ^t.VulkanData = nil, pool: ^t.CommandPool = nil) ->  {...}
		CommandPools :: proc(data: ^t.VulkanData = nil) ->  {...}
		DescriptorPool :: proc(data: ^t.VulkanData = nil, pool: ^t.DescriptorPool = nil) ->  {...}
		DescriptorPools :: proc(data: ^t.VulkanData = nil) ->  {...}
		DescriptorSetLayout :: proc(data: ^t.VulkanData = nil, descriptor: ^t.Descriptor = nil) ->  {...}
		Descriptors :: proc(data: ^t.VulkanData = nil) ->  {...}
		FrameBuffer :: proc(data: ^t.VulkanData = nil, fb: ^vk.Framebuffer = nil) ->  {...}
		FrameBuffers :: proc(data: ^t.VulkanData = nil, ctx: rn.Context = {}) ->  {...}
		GBuffer :: proc(data: ^t.VulkanData = nil, gBuffer: ^t.GBuffer = nil) ->  {...}
		Image :: proc(data: ^t.VulkanData = nil, image: ^vk.Image = nil, ctx: rn.Context = {}) ->  {...}
		ImageView :: proc(data: ^t.VulkanData = nil, view: ^vk.ImageView = nil, ctx: rn.Context = {}) ->  {...}
		Instance :: proc(data: ^t.VulkanData = nil) ->  {...}
		LogicalDevice :: proc(data: ^t.VulkanData = nil) ->  {...}
		Memory :: proc(data: ^t.VulkanData = nil, memory: ^vk.DeviceMemory = nil, ctx: rn.Context = {}) ->  {...}
		PhysicalDeviceData :: proc(data: ^t.VulkanData = nil) ->  {...}
		Pipeline :: proc(data: ^t.VulkanData = nil, pipeline: ^t.Pipeline = nil) ->  {...}
		PipelineLayout :: proc(data: ^t.VulkanData = nil, pipelineLayout: ^vk.PipelineLayout = nil) ->  {...}
		Pipelines :: proc(data: ^t.VulkanData = nil) ->  {...}
		RenderPass :: proc(data: ^t.VulkanData = nil, renderPass: ^t.RenderPass = nil) ->  {...}
		RenderPasses :: proc(data: ^t.VulkanData = nil) ->  {...}
		Resources :: proc(data: ^t.VulkanData = nil) ->  {...}
		Samplers :: proc(data: ^t.VulkanData = nil) ->  {...}
		Shaders :: proc(data: ^t.VulkanData = nil) ->  {...}
		Surface :: proc(data: ^t.VulkanData = nil) ->  {...}
		Swapchain :: proc(data: ^t.VulkanData = nil) ->  {...}
		SyncObjects :: proc(data: ^t.VulkanData = nil) ->  {...}
		UniformBuffers :: proc(data: ^t.VulkanData = nil, ctx: rn.Context = {}) ->  {...}


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan/destroy
	files:
		additional_data.odin
		appinfo.odin
		buffers.odin
		command_buffers.odin
		command_pools.odin
		descriptors.odin
		framebuffers.odin
		image.odin
		image_view.odin
		instance.odin
		logical_device.odin
		memory.odin
		physical_device_data.odin
		pipelines.odin
		renderpass.odin
		resources.odin
		samplers.odin
		shaders.odin
		surface.odin
		swapchain.odin
		sync_objects.odin
