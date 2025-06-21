package vk_types

import s "../../../shared"
import vk "vendor:vulkan"

VulkanData :: #type struct {
	renderData:      s.RenderData,

	// Application
	appInfo:         vk.ApplicationInfo,

	// Instance
	instance:        Instance,

	// Surface
	surface:         vk.SurfaceKHR,

	// Physical Device
	physical:        PhysicalDeviceData,

	// Logical Device
	logical:         Logical,

	// Swapchain
	swapchain:       Swapchain,

	// Image Samplers
	samplers:        map[string]vk.Sampler,

	// Render Passes
	passes:          map[string]RenderPass,

	// Descriptors
	descriptorPools: map[string]DescriptorPool,
	descriptors:     map[string]Descriptor,

	// Pipelines
	pipelines:       map[string]Pipeline,

	// Resources
	gBuffers:        map[string]GBuffer,

	// Commands
	commandPools:    map[string]CommandPool,
	commandBuffers:  map[string]CommandBuffer,

	// View
	viewports:       map[string]vk.Viewport,
	scissors:        map[string]vk.Rect2D,

	// Sync Objects
	syncObjects:     SyncObjects,

	// Buffers
	uniformBuffers:  map[string]Buffers,

	// Utils
	frameResized:    bool,

	// Memory Utils
	allocations:     ^vk.AllocationCallbacks,
}

Instance :: #type struct {
	extensions:    [dynamic]cstring,
	layers:        [dynamic]cstring,
	createInfo:    vk.InstanceCreateInfo,
	messengerInfo: vk.DebugUtilsMessengerCreateInfoEXT,
	instance:      vk.Instance,
	messenger:     vk.DebugUtilsMessengerEXT,
}

Logical :: #type struct {
	queueCreateInfos:  []vk.DeviceQueueCreateInfo,
	extensions:        []cstring,
	requestedFeatures: vk.PhysicalDeviceFeatures,
	createInfo:        vk.DeviceCreateInfo,
	device:            vk.Device,
}

SwapchainFormats :: #type struct {
	surface: vk.SurfaceFormatKHR,
	color:   vk.Format,
	depth:   vk.Format,
}

Swapchain :: #type struct {
	formats:     SwapchainFormats,
	presentMode: vk.PresentModeKHR,
	extent:      vk.Extent2D,
	imageCount:  u32,
	createInfo:  vk.SwapchainCreateInfoKHR,
	swapchain:   vk.SwapchainKHR,
	images:      [dynamic]vk.Image,
	views:       [dynamic]vk.ImageView,
}

DescriptorPool :: #type struct {
	createInfo: vk.DescriptorPoolCreateInfo,
	pools:      []vk.DescriptorPoolSize,
	poolCount:  u32,
	this:       vk.DescriptorPool,
}

Descriptor :: #type struct {
	setLayout:   vk.DescriptorSetLayout,
	poolName:    string,
	setsLayouts: []vk.DescriptorSetLayout,
	sets:        []vk.DescriptorSet,
}

ColorPass :: #type struct {
	attachments: []vk.AttachmentDescription,
	references:  []vk.AttachmentReference,
	resolves:    []vk.AttachmentReference,
}

DepthPass :: #type struct {
	attachment: vk.AttachmentDescription,
	reference:  vk.AttachmentReference,
	resolve:    vk.AttachmentReference,
}

RenderPass :: #type struct {
	color:        ColorPass,
	depth:        DepthPass,
	subpasses:    []vk.SubpassDescription,
	dependencies: []vk.SubpassDependency,
	createInfo:   vk.RenderPassCreateInfo,
	renderPass:   vk.RenderPass,
	clearValues:  []vk.ClearValue,
	frameBuffers: []vk.Framebuffer,
}

PipelinesCreateInfos :: #type union #no_nil {
	vk.GraphicsPipelineCreateInfo,
	vk.ComputePipelineCreateInfo,
	vk.PipelineCreateInfoKHR,
	vk.RayTracingPipelineCreateInfoKHR,
	vk.RayTracingPipelineCreateInfoNV,
	vk.ExecutionGraphPipelineCreateInfoAMDX,
	vk.SubpassShadingPipelineCreateInfoHUAWEI,
	vk.GraphicsPipelineLibraryCreateInfoEXT,
	vk.RayTracingPipelineInterfaceCreateInfoKHR,
	vk.GraphicsPipelineShaderGroupsCreateInfoNV,
}

ShaderReference :: #type struct {
	name:  string,
	stage: vk.ShaderStageFlag,
}

SemaphoreObject :: #type struct {
	this:       vk.Semaphore,
	createInfo: vk.SemaphoreCreateInfo,
}

SemaphoresObjects :: #type struct {
	createInfo: vk.SemaphoreCreateInfo,
	image:      vk.Semaphore,
	render:     vk.Semaphore,
}

FenceObject :: #type struct {
	this:       vk.Fence,
	createInfo: vk.FenceCreateInfo,
}

SyncObjects :: #type struct {
	semaphores: []SemaphoresObjects,
	fences:     []FenceObject,
}

CommandPool :: #type struct {
	createInfo: vk.CommandPoolCreateInfo,
	this:       vk.CommandPool,
}

CommandBuffer :: #type struct {
	createInfo: vk.CommandBufferAllocateInfo,
	this:       []vk.CommandBuffer,
}

Pipeline :: #type struct {
	shaders:    []ShaderReference,
	stages:     []vk.PipelineShaderStageCreateInfo,
	setLayouts: []vk.DescriptorSetLayout,
	states:     []any,
	layout:     vk.PipelineLayout,
	cache:      vk.PipelineCache,
	createInfo: PipelinesCreateInfos,
	pipeline:   vk.Pipeline,
}

Buffer :: #type struct {
	this: vk.Buffer,
	mem:  vk.DeviceMemory,
	ptr:  rawptr,
}

Buffers :: #type struct {
	createInfo: vk.BufferCreateInfo,
	this:       []Buffer,
}

GBuffer :: #type struct {
	images: []vk.Image,
	views:  []vk.ImageView,
	mems:   []vk.DeviceMemory,
    format: vk.Format,
}

vkad :: #type vk.AttachmentDescription
vkar :: #type vk.AttachmentReference
vibd :: #type vk.VertexInputBindingDescription
viad :: #type vk.VertexInputAttributeDescription

PhysicalDeviceData :: #type struct {
	index:               int,
	type:                string,
	features:            vk.PhysicalDeviceFeatures,
	properties:          vk.PhysicalDeviceProperties,
	capabilities:        vk.SurfaceCapabilitiesKHR,
	memoryProperties:    vk.PhysicalDeviceMemoryProperties,
	formats:             []vk.SurfaceFormatKHR,
	modes:               []vk.PresentModeKHR,
	device:              vk.PhysicalDevice,
	queues:              Queues,
	uniqueQueueFamilies: []u32,
}

Queues :: #type struct {
	idx:      QueueIndices,
	graphics: vk.Queue,
	present:  vk.Queue,
	compute:  vk.Queue,
	transfer: vk.Queue,
}

QueueIndices :: #type struct {
	graphics: u32,
	present:  u32,
	compute:  u32,
	transfer: u32,
}

GetModuleProc :: #type proc(pName: string) -> (module: vk.ShaderModule)

ShaderLang :: enum u8 {
	GLSL,
	SPIRV,
}
