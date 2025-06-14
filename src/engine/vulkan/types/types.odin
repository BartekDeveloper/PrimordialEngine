package vk_types

import vk "vendor:vulkan"
import s "../../../shared"

VulkanData :: #type struct {
    res: vk.Result,

    // Application
    appInfo: vk.ApplicationInfo,
   
    // Instance
    instance: #type struct {
        extensions:    [dynamic]cstring,
        layers:        [dynamic]cstring,
         
        createInfo:    vk.InstanceCreateInfo,        
        messengerInfo: vk.DebugUtilsMessengerCreateInfoEXT,

        instance:      vk.Instance,
        messenger:     vk.DebugUtilsMessengerEXT,
    },

    // Surface
    surface: vk.SurfaceKHR,
    
    // Physical Device
    physical: PhysicalDeviceData,
    
    // Logical Device
    logical: #type struct {
        queueCreateInfos:  []vk.DeviceQueueCreateInfo,    
        extensions:        []cstring,
        requestedFeatures: vk.PhysicalDeviceFeatures,
         
        createInfo:        vk.DeviceCreateInfo,
        device:            vk.Device,
    },

    // Swapchain
    swapchain: #type struct{
        formats: #type struct{
            surface: vk.SurfaceFormatKHR,
            color:   vk.Format,
            depth:   vk.Format,
        },

        presentMode: vk.PresentModeKHR,
        extent:      vk.Extent2D,
        imageCount:  u32,    

        createInfo:  vk.SwapchainCreateInfoKHR,        
        swapchain:   vk.SwapchainKHR,
        
        images:      [dynamic]vk.Image,
        views:       [dynamic]vk.ImageView,
    },

    // Image Samplers
    samplers:  map[string]vk.Sampler,
    
    // Render Passes
    passes:    map[string]RenderPass,
    
    // Pipelines
    pipelines: map[string]Pipeline,

    // Descriptors
    descriptorPools: map[string]DescriptorPool,
    descriptors:     map[string]Descriptor,
 
    // Commands
    commandPools: map[string]struct{
        createInfo: vk.CommandPoolCreateInfo,
        this:       vk.CommandPool,
    },
    commandBuffers: map[string][]vk.CommandBuffer,
    
    // View
    viewports: map[string]vk.Viewport,
    scissors:  map[string]vk.Rect2D,

    // Sync Objects
    syncObjects: #type struct{
        semaphores: []struct{
            createInfo: vk.SemaphoreCreateInfo,
            image:      vk.Semaphore,
            render:     vk.Semaphore,
        },
        semaphoreCreateInfo: vk.SemaphoreCreateInfo,
    
        fences: []struct{
            createInfo: vk.FenceCreateInfo,
            this:       vk.Fence
        }, 
    },

    // Buffers
    uniformBuffers: []Buffer,
}

DescriptorPool :: #type struct{
    createInfo: vk.DescriptorPoolCreateInfo,
    pool:       vk.DescriptorPool,
}

Descriptor :: #type struct{
    setLayout: vk.DescriptorSetLayout,
    poolName:  string,
    sets:      []vk.DescriptorSet,
}

RenderPass :: #type struct{
    color: #type struct{
        attachments: []vk.AttachmentDescription,
        references:  []vk.AttachmentReference,
        resolves:    []vk.AttachmentReference,
    },

    depth: #type struct{
        attachment: vk.AttachmentDescription,
        reference:  vk.AttachmentReference,
        resolve:    vk.AttachmentReference,
    },

    subpasses:    []vk.SubpassDescription,
    dependencies: []vk.SubpassDependency,
    
    createInfo: vk.RenderPassCreateInfo,
    renderPass: vk.RenderPass,
    
    frameBuffers: []vk.Framebuffer,
}

PipelinesCreateInfos :: #type union #no_nil{
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

Pipeline :: #type struct{
    shaders: []any,
    stages:  []vk.PipelineShaderStageCreateInfo,
    
    setLayouts: []vk.DescriptorSetLayout,
    
    states: []any,
    layout: vk.PipelineLayout,
    cache:  vk.PipelineCache,
    
    createInfo: PipelinesCreateInfos,
    pipeline: vk.Pipeline,
}

Buffer :: #type struct{
    this: vk.Buffer,
    mem:  vk.DeviceMemory,
    ptr:  rawptr
}

GBuffer :: #type struct{
    img:  vk.Image,
    view: vk.ImageView,
    mem:  vk.DeviceMemory
}

vkad :: #type vk.AttachmentDescription
vkar :: #type vk.AttachmentReference
vibd :: #type vk.VertexInputBindingDescription
viad :: #type vk.VertexInputAttributeDescription

PhysicalDeviceData :: #type struct{
    index:            int,
    type:             string,
  
    features:         vk.PhysicalDeviceFeatures,  
    properties:       vk.PhysicalDeviceProperties,
    capabilities:     vk.SurfaceCapabilitiesKHR,
    memoryProperties: vk.PhysicalDeviceMemoryProperties,

    formats:          []vk.SurfaceFormatKHR,
    modes:            []vk.PresentModeKHR, 

    device:           vk.PhysicalDevice,
    queues:           Queues,

    uniqueQueueFamilies: []u32
}

Queues :: #type struct{
    idx:      QueueIndices,    
    graphics: vk.Queue,
    present:  vk.Queue,
    compute:  vk.Queue,
    transfer: vk.Queue
}

QueueIndices :: #type struct{
    graphics: u32,
    present:  u32,
    compute:  u32,
    transfer: u32
}

