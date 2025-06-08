package vk_types

import vk "vendor:vulkan"
import s "../../../shared"

VulkanData :: #type struct {
    res: vk.Result,

    // Application
    appInfo: vk.ApplicationInfo,
   
    // Instance
    instance: #type struct {
        extensions: [dynamic]cstring,
        layers:     [dynamic]cstring,
         
        createInfo:    vk.InstanceCreateInfo,        
        messengerInfo: vk.DebugUtilsMessengerCreateInfoEXT,

        instance:  vk.Instance,
        messenger: vk.DebugUtilsMessengerEXT,
    },

    // Surface
    surface: vk.SurfaceKHR,
    
    // Physical Device
    physical: #type struct{
        index:    int,
        type:     cstring,
      
        features:         vk.PhysicalDeviceFeatures,  
        properties:       vk.PhysicalDeviceProperties,
        capabilities:     vk.SurfaceCapabilitiesKHR,
        memoryProperties: vk.PhysicalDeviceMemoryProperties,

        formats: []vk.SurfaceFormatKHR,
        modes:   []vk.PresentModeKHR, 

        queues: #type struct{
            idx: #type struct{
                graphics: u32,
                present:  u32,
                compute:  u32,
                transfer: u32
            },
            
            graphics: vk.Queue,
            present:  vk.Queue,
            compute:  vk.Queue,
            transfer: vk.Queue
        }, 

        device: vk.PhysicalDevice
    },
    
    // Logical Device
    logical: #type struct {
        queueCreateInfos: []vk.DeviceQueueCreateInfo,    
        deviceExtensions: []cstring,
        requestedFeatures: vk.PhysicalDeviceFeatures,
        
        createInfo: vk.DeviceCreateInfo,
        device: vk.Device,
    },

    // Swapchain
    swapchain: #type struct{
        formats: #type struct{
            surface: vk.SurfaceKHR,
            color:   vk.Format,
            depth:   vk.Format,
        },
        presentMode: vk.PresentModeKHR,
        extent: vk.Extent2D,
        imageCount: u32,    

        createInfo: vk.SwapchainCreateInfoKHR,        
        swapchain: vk.SwapchainKHR,
        
        images: [dynamic]vk.Image,
        views:  [dynamic]vk.ImageView,
    },

    // Image Samplers
    samplers:  map[string]vk.Sampler,
    
    // Render Passes
    passes:    map[string]RenderPass,
    
    // Pipelines
    pipelines: map[string]Pipeline,

    // Descriptors
    descritporPoolCreateInfo: vk.DescriptorPoolCreateInfo,
    descriptorPool: vk.DescriptorPool,
    
    // Commands
    commandPools: map[string]struct{
        createInfo: vk.CommandPoolCreateInfo,
        this:       vk.CommandPool,
    },

    commandBuffers: map[string][]vk.CommandBuffer,
    
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
    
    createInfo: vk.PipelineCreateInfoKHR,
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
    mem:  vk.DeviceMemory,
}

vkad :: #type vk.AttachmentDescription
vkar :: #type vk.AttachmentReference
vibd :: #type vk.VertexInputBindingDescription
viad :: #type vk.VertexInputAttributeDescription

