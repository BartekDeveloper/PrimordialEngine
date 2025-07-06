package vk_types
	types
		Buffer :: #type struct {this: vk.Buffer, mem: vk.DeviceMemory, ptr: rawptr, offset: vk.DeviceSize}
		Buffers :: #type struct {createInfo: vk.BufferCreateInfo, this: []Buffer}
		ColorPass :: #type struct {attachments: []vk.AttachmentDescription, references: []vk.AttachmentReference, resolves: []vk.AttachmentReference}
		CommandBuffer :: #type struct {createInfo: vk.CommandBufferAllocateInfo, this: []vk.CommandBuffer}
		CommandPool :: #type struct {createInfo: vk.CommandPoolCreateInfo, this: vk.CommandPool}
		DepthPass :: #type struct {attachment: vk.AttachmentDescription, reference: vk.AttachmentReference, resolve: vk.AttachmentReference}
		Descriptor :: #type struct {poolName: string, setLayout: vk.DescriptorSetLayout, bindings: []vk.DescriptorSetLayoutBinding, layoutInfo: vk.DescriptorSetLayoutCreateInfo, setsLayouts: []vk.DescriptorSetLayout, sets: []vk.DescriptorSet, writes: []vk.WriteDescriptorSet}
		DescriptorPool :: #type struct {createInfo: vk.DescriptorPoolCreateInfo, pools: []vk.DescriptorPoolSize, poolCount: u32, this: vk.DescriptorPool}
		FenceObject :: #type struct {this: vk.Fence, createInfo: vk.FenceCreateInfo}
		GBuffer :: #type struct {images: []vk.Image, views: []vk.ImageView, mems: []vk.DeviceMemory, format: vk.Format}
		GetModuleProc :: #type proc(pName: string) -> (module: vk.ShaderModule)
		Instance :: #type struct {extensions: [dynamic]cstring, layers: [dynamic]cstring, createInfo: vk.InstanceCreateInfo, messengerInfo: vk.DebugUtilsMessengerCreateInfoEXT, instance: vk.Instance, messenger: vk.DebugUtilsMessengerEXT}
		Logical :: #type struct {queueCreateInfos: []vk.DeviceQueueCreateInfo, extensions: []cstring, requestedFeatures: vk.PhysicalDeviceFeatures, createInfo: vk.DeviceCreateInfo, device: vk.Device}
		PhysicalDeviceData :: #type struct {index: int, type: string, features: vk.PhysicalDeviceFeatures, properties: vk.PhysicalDeviceProperties, capabilities: vk.SurfaceCapabilitiesKHR, memoryProperties: vk.PhysicalDeviceMemoryProperties, formats: []vk.SurfaceFormatKHR, modes: []vk.PresentModeKHR, device: vk.PhysicalDevice, queues: Queues, uniqueQueueFamilies: []u32}
		Pipeline :: #type struct {shaders: []ShaderReference, stages: []vk.PipelineShaderStageCreateInfo, setLayouts: []vk.DescriptorSetLayout, states: []any, layout: vk.PipelineLayout, cache: vk.PipelineCache, createInfo: PipelinesCreateInfos, pipeline: vk.Pipeline}
		PipelinesCreateInfos :: #type union #no_nil {vk.GraphicsPipelineCreateInfo, vk.ComputePipelineCreateInfo, vk.PipelineCreateInfoKHR, vk.RayTracingPipelineCreateInfoKHR, vk.RayTracingPipelineCreateInfoNV, vk.ExecutionGraphPipelineCreateInfoAMDX, vk.SubpassShadingPipelineCreateInfoHUAWEI, vk.GraphicsPipelineLibraryCreateInfoEXT, vk.RayTracingPipelineInterfaceCreateInfoKHR, vk.GraphicsPipelineShaderGroupsCreateInfoNV}
		QueueIndices :: #type struct {graphics: u32, present: u32, compute: u32, transfer: u32}
		Queues :: #type struct {idx: QueueIndices, graphics: vk.Queue, present: vk.Queue, compute: vk.Queue, transfer: vk.Queue}
		RenderPass :: #type struct {color: ColorPass, depth: DepthPass, subpasses: []vk.SubpassDescription, dependencies: []vk.SubpassDependency, attachments: []vk.AttachmentDescription, createInfo: vk.RenderPassCreateInfo, renderPass: vk.RenderPass, clearValues: []vk.ClearValue, frameBuffers: []vk.Framebuffer}
		SemaphoreObject :: #type struct {this: vk.Semaphore, createInfo: vk.SemaphoreCreateInfo}
		SemaphoresObjects :: #type struct {createInfo: vk.SemaphoreCreateInfo, image: vk.Semaphore, render: vk.Semaphore}
		ShaderLang :: enum u8 {GLSL, SPIRV}
		ShaderReference :: #type struct {name: string, stage: vk.ShaderStageFlag}
		Swapchain :: #type struct {formats: SwapchainFormats, presentMode: vk.PresentModeKHR, extent: vk.Extent2D, imageCount: u32, createInfo: vk.SwapchainCreateInfoKHR, swapchain: vk.SwapchainKHR, images: [dynamic]vk.Image, views: [dynamic]vk.ImageView}
		SwapchainFormats :: #type struct {surface: vk.SurfaceFormatKHR, color: vk.Format, depth: vk.Format}
		SyncObjects :: #type struct {semaphores: []SemaphoresObjects, fences: []FenceObject}
		VulkanData :: #type struct {renderData: s.RenderData, appInfo: vk.ApplicationInfo, instance: Instance, surface: vk.SurfaceKHR, physical: PhysicalDeviceData, logical: Logical, swapchain: Swapchain, samplers: map[string]vk.Sampler, passes: map[string]RenderPass, descriptorPools: map[string]DescriptorPool, descriptors: map[string]Descriptor, pipelines: map[string]Pipeline, gBuffers: map[string]GBuffer, commandPools: map[string]CommandPool, commandBuffers: map[string]CommandBuffer, viewports: map[string]vk.Viewport, scissors: map[string]vk.Rect2D, syncObjects: SyncObjects, uniformBuffers: map[string]Buffers, frameResized: bool, allocations: ^vk.AllocationCallbacks}
		viad :: #type vk.VertexInputAttributeDescription
		vibd :: #type vk.VertexInputBindingDescription
		vkad :: #type vk.AttachmentDescription
		vkar :: #type vk.AttachmentReference


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan/types
	files:
		types.odin
