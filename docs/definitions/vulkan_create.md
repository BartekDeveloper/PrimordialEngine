package vk_create
	constants
		ENABLE_VALIDATION_LAYERS: bool : true

	variables
		ctx: rn.Context 

	procedures
		AddAttribute_1 :: proc(data: ^PipelineVertexData, attribute: vk.VertexInputAttributeDescription) {...}
		AddAttributes_1 :: proc(data: ^PipelineVertexData, attributes: ..vk.VertexInputAttributeDescription) {...}
		AddAttributes_2 :: proc(data: ^PipelineVertexData, attributesCount: u32, attributes: [^]vk.VertexInputAttributeDescription) {...}
		AddAttributes_3 :: proc(data: ^PipelineVertexData, chain: ^ChainedAttributes) {...}
		AddBinding_1 :: proc(data: ^PipelineVertexData, binding: vk.VertexInputBindingDescription) {...}
		AddBindings_1 :: proc(data: ^PipelineVertexData, bindings: ..vk.VertexInputBindingDescription) {...}
		AddBindings_2 :: proc(data: ^PipelineVertexData, bindingsCount: u32, bindings: [^]vk.VertexInputBindingDescription) {...}
		AddBindings_3 :: proc(data: ^PipelineVertexData, chain: ^ChainedBindings) {...}
		AdditionalData :: proc(data: ^t.VulkanData) ->  {...}
		AppInfo :: proc(data: ^t.VulkanData) ->  {...}
		AttachmentDescription :: proc(format: vk.Format = .R8G8B8A8_UNORM, loadOp: vk.AttachmentLoadOp = .CLEAR, storeOp: vk.AttachmentStoreOp = .STORE, finalLayout: vk.ImageLayout = .SHADER_READ_ONLY_OPTIMAL, stencilLoadOp: vk.AttachmentLoadOp = .DONT_CARE, stencilStoreOp: vk.AttachmentStoreOp = .DONT_CARE, initialLayout: vk.ImageLayout = .UNDEFINED, samples: vk.SampleCountFlags = {._1}) -> (attachment: vk.AttachmentDescription) {...}
		BufferInfo :: proc(bufferInfo: ^vk.DescriptorBufferInfo = nil, buffer: t.Buffer = {}, size: int = 0, offset: vk.DeviceSize = 0) ->  {...}
		Buffer_modify :: proc(data: ^t.VulkanData = nil, buffer: ^t.Buffer = nil, size: vk.DeviceSize = 0, usage: vk.BufferUsageFlags = {}, properties: vk.MemoryPropertyFlags = {}) -> (good: bool = true) {...}
		Buffer_return :: proc(data: ^t.VulkanData = nil, size: vk.DeviceSize = 0, usage: vk.BufferUsageFlags = {}, properties: vk.MemoryPropertyFlags = {}, memory: ^vk.DeviceMemory = nil) -> (buffer: vk.Buffer, good: bool = true) {...}
		CleanPipelineVertexData :: proc(data: ^PipelineVertexData) {...}
		CommandBuffer :: proc(data: ^t.VulkanData = nil, createInfo: ^vk.CommandBufferAllocateInfo = nil, cmdBuffer_s: [^]vk.CommandBuffer = nil) -> (good: bool = true) {...}
		CommandBuffers :: proc(data: ^t.VulkanData) ->  {...}
		CommandPool :: proc(data: ^t.VulkanData = nil, createInfo: ^vk.CommandPoolCreateInfo = nil, pool: ^vk.CommandPool = nil) -> (good: bool = true) {...}
		CommandPools :: proc(data: ^t.VulkanData) ->  {...}
		DefaultBlendAttachment :: proc(blendEnable: b8 = false, colorWriteMask: vk.ColorComponentFlags = {.R, .G, .B, .A}, srcColorBlendFactor: vk.BlendFactor = .SRC_ALPHA, dstColorBlendFactor: vk.BlendFactor = .ONE_MINUS_SRC_ALPHA, colorBlendOp: vk.BlendOp = .ADD, srcAlphaBlendFactor: vk.BlendFactor = .ONE, dstAlphaBlendFactor: vk.BlendFactor = .ZERO, alphaBlendOp: vk.BlendOp = .ADD) -> (blendAttachment: vk.PipelineColorBlendAttachmentState) {...}
		DefaultColorBlending :: proc(#any_int attachmentsCount: u32 = 0, attachments: [^]vk.PipelineColorBlendAttachmentState = {}, logicOpEnable: b8 = false, logicOp: vk.LogicOp = .COPY, blendConstants: [4]f32 = {0, 0, 0, 0}, pNext: rawptr = nil, flags: vk.PipelineColorBlendStateCreateFlags = {}) -> (colorBlending: vk.PipelineColorBlendStateCreateInfo) {...}
		DefaultCreateDynamicStates :: proc(#any_int dynamicStatesCount: u32 = 0, pDynamicStates: [^]vk.DynamicState = nil, pNext: rawptr = nil, flags: vk.PipelineDynamicStateCreateFlags = {}) -> (dynamicStatesInfo: vk.PipelineDynamicStateCreateInfo) {...}
		DefaultDepthStencil :: proc(depthTestEnable: b8 = false, depthWriteEnable: b8 = false, depthCompareOp: vk.CompareOp = .LESS, depthBoundsTestEnable: b8 = false, stencilTestEnable: b8 = false, flags: vk.PipelineDepthStencilStateCreateFlags = {}, minDepthBounds: f32 = 0, maxDepthBounds: f32 = 1, front: vk.StencilOpState = {}, back: vk.StencilOpState = {}, pNext: rawptr = nil) -> (depthStencil: vk.PipelineDepthStencilStateCreateInfo) {...}
		DefaultDynamicStates :: proc(states: ^[2]vk.DynamicState = nil) -> (dynamicStatesInfo: vk.PipelineDynamicStateCreateInfo) {...}
		DefaultFillColorBlendAttachments :: proc(#any_int attachmentsCount: u32 = 0, colorWriteMask: vk.ColorComponentFlags = {.R, .G, .B, .A}, blendEnable: b8 = false) -> (colorBlendAttachments: []vk.PipelineColorBlendAttachmentState) {...}
		DefaultInputAssembly :: proc(topology: vk.PrimitiveTopology = .TRIANGLE_STRIP, restartEnable: b32 = false, flags: vk.PipelineInputAssemblyStateCreateFlags = {}) -> (inputAssembly: vk.PipelineInputAssemblyStateCreateInfo) {...}
		DefaultMultisample :: proc(rasterizationSamples: vk.SampleCountFlags = {._1}, sampleShadingEnable: b8 = false, minSampleShading: f32 = 1, alphaToCoverageEnable: b8 = false, alphaToOneEnable: b8 = false, pSampleMask: ^vk.SampleMask = nil, pNext: rawptr = nil, flags: vk.PipelineMultisampleStateCreateFlags = {}) -> (multisample: vk.PipelineMultisampleStateCreateInfo) {...}
		DefaultPipelineCacheInfo :: proc(#any_int initDataSize: int = 0, initData: rawptr = nil, flags: vk.PipelineCacheCreateFlags = {}, pNext: rawptr = nil) -> (pipelineCacheInfo: vk.PipelineCacheCreateInfo) {...}
		DefaultPipelineEmptyCacheCreateInfo :: proc() -> (pipelineCacheInfo: vk.PipelineCacheCreateInfo) {...}
		DefaultPipelineLayoutCreateInfo :: proc(#any_int setLayoutsCount: u32 = 0, setLayouts: [^]vk.DescriptorSetLayout = nil, pushConstantRangeCount: u32 = 0, pushConstantRanges: ^vk.PushConstantRange = nil, pNext: rawptr = nil, flags: vk.PipelineLayoutCreateFlags = {}) -> (pipelineLayoutInfo: vk.PipelineLayoutCreateInfo) {...}
		DefaultRasterization :: proc(cullMode: vk.CullModeFlags = nil, polygonMode: vk.PolygonMode = .FILL, lineWidth: f32 = 1.0, frontFace: vk.FrontFace = .COUNTER_CLOCKWISE, rasterizerDiscardEnable: b8 = false, depthBiasEnable: b8 = false, depthBiasConstantFactor: f32 = 0, depthBiasClamp: f32 = 0, depthBiasSlopeFactor: f32 = 0, flags: vk.PipelineRasterizationStateCreateFlags = {}, pNext: rawptr = nil) -> (rasterization: vk.PipelineRasterizationStateCreateInfo) {...}
		DefaultVertexInput :: proc(data: ^PipelineVertexData) -> (vertexInput: vk.PipelineVertexInputStateCreateInfo) {...}
		DefaultViewportState :: proc(viewportCount: u32 = 1, scissorCount: u32 = 1, viewports: ^vk.Viewport = nil, scissors: ^vk.Rect2D = nil, pNext: rawptr = nil, flags: vk.PipelineViewportStateCreateFlags = {}) -> (viewportState: vk.PipelineViewportStateCreateInfo) {...}
		DescriptorAllocate :: proc(data: ^t.VulkanData = nil, allocInfo: ^vk.DescriptorSetAllocateInfo = nil, sets: [^]vk.DescriptorSet = nil) -> (ok: bool = true) {...}
		DescriptorAllocateInfo :: proc(allocInfo: ^vk.DescriptorSetAllocateInfo = nil, pool: ^t.DescriptorPool = nil, layouts: [^]vk.DescriptorSetLayout = nil, count: u32 = 0, pNext: rawptr = nil) ->  {...}
		DescriptorPool :: proc(data: ^t.VulkanData, pool: ^t.DescriptorPool) -> (result: vk.Result = .SUCCESS) {...}
		DescriptorPoolCreateInfo :: proc(data: ^t.VulkanData = nil, pool: ^t.DescriptorPool = nil, pools: [^]vk.DescriptorPoolSize = nil, count: u32 = 0, flags: vk.DescriptorPoolCreateFlags = {}, pNext: rawptr = nil, maxSets: u32 = 0) -> (createInfo: vk.DescriptorPoolCreateInfo = {}) {...}
		DescriptorPools :: proc(data: ^t.VulkanData) ->  {...}
		DescriptorSetLayout :: proc(data: ^t.VulkanData = nil, info: ^vk.DescriptorSetLayoutCreateInfo = nil, setLayout: ^vk.DescriptorSetLayout = nil) -> (ok: bool = true) {...}
		DescriptorSetLayouts :: proc(data: ^t.VulkanData) ->  {...}
		DescriptorSets :: proc(data: ^t.VulkanData) ->  {...}
		DescriptorWrite :: proc(write: ^vk.WriteDescriptorSet = nil, set: ^vk.DescriptorSet = nil, descriptorType: vk.DescriptorType = .UNIFORM_BUFFER, binding: u32 = 0, arrayElement: u32 = 0, count: u32 = 1, bufferInfo: ^vk.DescriptorBufferInfo = nil, imageInfo: ^vk.DescriptorImageInfo = nil, texelBufferView: ^vk.BufferView = nil) ->  {...}
		FrameBuffer :: proc(data: ^t.VulkanData = nil, size: vk.Extent3D = {}, renderPass: t.RenderPass = {}, attachments: ^[]vk.ImageView = nil, frameBuffer: ^vk.Framebuffer = nil) ->  {...}
		Framebuffers :: proc(data: ^t.VulkanData) ->  {...}
		GBuffer :: proc(data: ^t.VulkanData = nil, gBuffer: ^t.GBuffer = nil, format: vk.Format = .R8G8B8A8_SINT, width: u32 = 0, height: u32 = 0, tiling: vk.ImageTiling = .OPTIMAL, usage: vk.ImageUsageFlags = {}, memoryFlags: vk.MemoryPropertyFlags = {}, aspectMask: vk.ImageAspectFlags = {}) -> (good: bool = true) {...}
		GraphicsPipeline :: proc(data: ^t.VulkanData = nil, pipeline: ^vk.Pipeline = nil, gpData: GraphicsPipelineData = {}) -> (ok: bool = true) {...}
		ImageInfo :: proc(imageInfo: ^vk.DescriptorImageInfo = nil, imageView: ^vk.ImageView = nil, sampler: ^vk.Sampler = nil, imageLayout: vk.ImageLayout = .SHADER_READ_ONLY_OPTIMAL) ->  {...}
		ImageView_modify :: proc(data: ^t.VulkanData = nil, imageView: ^vk.ImageView = nil, image: vk.Image = 0, format: vk.Format = vk.Format.R8G8B8A8_SINT, aspectMask: vk.ImageAspectFlags = {.COLOR}, mipLevels: u8 = 1, arrayLayers: u16 = 1, tiling: vk.ImageTiling = .OPTIMAL, baseMipLevel: u8 = 0, baseArrayLayer: u8 = 0, components: vk.ComponentMapping = {.R, .G, .B, .A}, viewType: vk.ImageViewType = .D2, flags: vk.ImageViewCreateFlags = {}) -> (good: bool = true) {...}
		ImageView_return :: proc(data: ^t.VulkanData = nil, image: vk.Image = 0, format: vk.Format = vk.Format.R8G8B8A8_SINT, aspectMask: vk.ImageAspectFlags = {.COLOR}, mipLevels: u8 = 1, arrayLayers: u16 = 1, tiling: vk.ImageTiling = .OPTIMAL, baseMipLevel: u8 = 0, baseArrayLayer: u8 = 0, components: vk.ComponentMapping = {.R, .G, .B, .A}, viewType: vk.ImageViewType = .D2, flags: vk.ImageViewCreateFlags = {}) -> (imageView: vk.ImageView, good: bool = true) {...}
		Image_modify :: proc(data: ^t.VulkanData = nil, image: ^vk.Image = nil, width: u32 = 0, height: u32 = 0, memory: ^vk.DeviceMemory = nil, memoryProperties: vk.MemoryPropertyFlags = {.HOST_VISIBLE, .HOST_COHERENT}, format: vk.Format = vk.Format.R8G8B8A8_SINT, usage: vk.ImageUsageFlags = {.COLOR_ATTACHMENT}, mipLevels: u8 = 1, arrayLayers: u16 = 1, imageType: vk.ImageType = .D2, tiling: vk.ImageTiling = .OPTIMAL, initialLayout: vk.ImageLayout = .UNDEFINED, flags: vk.ImageCreateFlags = {}, msaaSamples: vk.SampleCountFlags = {._1}, depth: u32 = 1) -> (good: bool = true) {...}
		Image_return :: proc(data: ^t.VulkanData = nil, width: u32 = 0, height: u32 = 0, memory: ^vk.DeviceMemory = nil, memoryProperties: vk.MemoryPropertyFlags = {.HOST_VISIBLE, .HOST_COHERENT}, format: vk.Format = .R8G8B8A8_SINT, usage: vk.ImageUsageFlags = {.COLOR_ATTACHMENT}, mipLevels: u8 = 1, arrayLayers: u16 = 1, imageType: vk.ImageType = .D2, tiling: vk.ImageTiling = .OPTIMAL, initialLayout: vk.ImageLayout = .UNDEFINED, flags: vk.ImageCreateFlags = {}, msaaSamples: vk.SampleCountFlags = {._1}, depth: u32 = 1) -> (image: vk.Image, good: bool = true) {...}
		Instance :: proc(data: ^t.VulkanData) {...}
		Label_gbuffer :: proc(device: vk.Device = nil, what: cstring = "", gbuffer: ^t.GBuffer = nil) ->  {...}
		Label_mutliple_1 :: proc(device: vk.Device = nil, what: cstring = "", handle: []u64 = {}, type: vk.ObjectType = .UNKNOWN) ->  {...}
		Label_mutliple_2 :: proc(device: vk.Device = nil, what: cstring = "", handle: [^]u64 = {}, #any_int count: u32 = 0, type: vk.ObjectType = .UNKNOWN) ->  {...}
		Label_single :: proc(device: vk.Device = nil, what: cstring = "", #any_int handle: u64 = 0, type: vk.ObjectType = .UNKNOWN) ->  {...}
		LayoutBinding_1 :: proc(binding: u32 = 0, type: vk.DescriptorType = .UNIFORM_BUFFER, stageFlags: vk.ShaderStageFlags = {.FRAGMENT}, count: u32 = 1, layoutBinding: ^vk.DescriptorSetLayoutBinding = nil, immutableSamplers: [^]vk.Sampler = nil) ->  {...}
		LayoutBinding_2 :: proc(binding: u32 = 0, type: vk.DescriptorType = .UNIFORM_BUFFER, stageFlags: vk.ShaderStageFlags = {.FRAGMENT}, count: u32 = 1, immutableSamplers: [^]vk.Sampler = nil) -> (layoutBinding: vk.DescriptorSetLayoutBinding) {...}
		LayoutInfo_1 :: proc(bindings: []vk.DescriptorSetLayoutBinding = {}) -> (layoutInfo: vk.DescriptorSetLayoutCreateInfo) {...}
		LayoutInfo_2 :: proc(binding: []vk.DescriptorSetLayoutBinding = {}, layoutInfo: ^vk.DescriptorSetLayoutCreateInfo = nil) ->  {...}
		LogicalDevice :: proc(data: ^t.VulkanData) ->  {...}
		MapMemory :: proc(data: ^t.VulkanData = nil, buffer: ^t.Buffer = nil, size: vk.DeviceSize = 0, flags: vk.MemoryMapFlags = {}) -> (result: vk.Result = .SUCCESS) {...}
		PhysicalDeviceData :: proc(data: ^t.VulkanData) ->  {...}
		PipelineCache :: proc(data: ^t.VulkanData = nil, info: ^vk.PipelineCacheCreateInfo = nil, cache: ^vk.PipelineCache = nil) -> (ok: bool = true) {...}
		PipelineLayout :: proc(data: ^t.VulkanData = nil, info: ^vk.PipelineLayoutCreateInfo = nil, layout: ^vk.PipelineLayout = nil) -> (ok: bool = true) {...}
		Pipelines :: proc(data: ^t.VulkanData) ->  {...}
		RenderPass :: proc(data: ^t.VulkanData = nil, createInfo: ^vk.RenderPassCreateInfo = nil, renderPass: ^vk.RenderPass = nil) -> (good: bool = true) {...}
		RenderPasses :: proc(data: ^t.VulkanData) ->  {...}
		Resources :: proc(data: ^t.VulkanData) ->  {...}
		Samplers :: proc(data: ^t.VulkanData) ->  {...}
		SetLayouts :: proc(layouts: ..vk.DescriptorSetLayout) -> (layoutsArray: []vk.DescriptorSetLayout) {...}
		ShaderStage :: proc(module: vk.ShaderModule = {}, stage: vk.ShaderStageFlag = {}, pSpecializationInfo: ^vk.SpecializationInfo = nil, pName: string = "main") -> (stageInfo: vk.PipelineShaderStageCreateInfo) {...}
		ShaderStages :: proc(data: ^t.VulkanData = nil, fn: t.GetModuleProc = load.GetModule, shaders: ..t.ShaderReference) -> (stages: []vk.PipelineShaderStageCreateInfo) {...}
		Subpass :: proc(#any_int count: u32, colorAttachments: [^]vk.AttachmentReference = nil, depthAttachment: ^vk.AttachmentReference = nil, resolve: [^]vk.AttachmentReference = nil, point: vk.PipelineBindPoint = .GRAPHICS) -> (subpass: vk.SubpassDescription) {...}
		SubpassDependency :: proc(srcStageMask: vk.PipelineStageFlags = {}, dstStageMask: vk.PipelineStageFlags = {}, srcAccessMask: vk.AccessFlags = {}, dstAccessMask: vk.AccessFlags = {}, dependencyFlags: vk.DependencyFlags = {}, srcSubpass: u32 = vk.SUBPASS_EXTERNAL, dstSubpass: u32 = 0) -> (dependency: vk.SubpassDependency) {...}
		Surface :: proc(data: ^t.VulkanData) ->  {...}
		Swapchain :: proc(data: ^t.VulkanData) ->  {...}
		SwapchainImages :: proc(data: ^t.VulkanData) ->  {...}
		SyncObjects :: proc(data: ^t.VulkanData, render: ^s.RenderData) {...}
		UniformBuffers :: proc(data: ^t.VulkanData) ->  {...}
		VulkanDebugCallback :: proc(messageSeverity: vk.DebugUtilsMessageSeverityFlagsEXT, messageType: vk.DebugUtilsMessageTypeFlagsEXT, pCallbackData: ^vk.DebugUtilsMessengerCallbackDataEXT, pUserData: rawptr) -> b32 {...}

	proc_group
		AddAttribute :: proc{AddAttribute_1, AddAttributes_1, AddAttributes_2, AddAttributes_3}
		AddBinding :: proc{AddBinding_1, AddBindings_1, AddBindings_2, AddBindings_3}
		Buffer :: proc{Buffer_return, Buffer_modify}
		Image :: proc{Image_modify, Image_return}
		ImageView :: proc{ImageView_modify, ImageView_return}
		Label :: proc{Label_single, Label_mutliple_1, Label_mutliple_2, Label_gbuffer}
		LayoutBinding :: proc{LayoutBinding_2, LayoutBinding_1}
		LayoutInfo :: proc{LayoutInfo_2, LayoutInfo_1}

	types
		ChainedAttributes :: #type struct {attribute: vk.VertexInputAttributeDescription, next: ^ChainedAttributes}
		ChainedBindings :: #type struct {binding: vk.VertexInputBindingDescription, next: ^ChainedBindings}
		GraphicsInfoStates :: #type struct {vertex: ^vk.PipelineVertexInputStateCreateInfo, assembly: ^vk.PipelineInputAssemblyStateCreateInfo, viewport: ^vk.PipelineViewportStateCreateInfo, raster: ^vk.PipelineRasterizationStateCreateInfo, multisample: ^vk.PipelineMultisampleStateCreateInfo, depthStencil: ^vk.PipelineDepthStencilStateCreateInfo, colorBlend: ^vk.PipelineColorBlendStateCreateInfo, dynamics: ^vk.PipelineDynamicStateCreateInfo}
			    Graphics Pipeline States
			    @input vertex
			    @input assembly
			    @input viewport
			    @input raster
			    @input multisample
			    @input depthStencil
			    @input colorBlend
			    @input dynamics
			
			    @return self struct(GraphicsInfoStates)

		GraphicsPipelineData :: #type struct {cache: ^vk.PipelineCache, infoCount: u32, info: [^]vk.GraphicsPipelineCreateInfo}
		PipelineVertexData :: #type struct {bindings: [dynamic]vk.VertexInputBindingDescription, attributes: [dynamic]vk.VertexInputAttributeDescription}
			Pipeline Vertex Data



	fullpath:
		/home/zota/projects/multi/vk_dynamic/src/engine/vulkan/create
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
		label.odin
		logical_device.odin
		physical_device_data.odin
		pipelines.odin
		resources.odin
		samplers.odin
		shaders.odin
		surface.odin
		swapchain.odin
		sync_objects.odin
