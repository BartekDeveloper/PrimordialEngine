package vulkan_renderer

import "core:math/linalg"
import "core:math"
import "core:log"
import "core:c"

import "core:fmt"
import "core:mem"
import "base:runtime"

import vk "vendor:vulkan"

import "create"
import "destroy"
import "load"
import "utils"
import t "types"
import o "objects"
import "../window"
import "../input"
import obj "../objects"
import s "../../shared"
import emath "../../maths"

vkData: t.VulkanData = {}
colorAttachments: []vk.RenderingAttachmentInfo = make([]vk.RenderingAttachmentInfo, 4)

WORLD_UP  :: emath.Vec3{ 0.0, 0.0, 1.0 } 

worldTime: int = 0 /* World  Time */
ii:        u32 = 0 /* Image Index */

Render :: proc(
    rData: ^s.RenderData = nil
) -> () {
    defer free_all(context.temp_allocator)
    using vkData;

    currentFrame := rData.currentFrame
    fence        := &syncObjects.fences[currentFrame].this
    vk.WaitForFences(logical.device, 1, fence, true, ~u64(0)-1)

    imageSem     := &syncObjects.semaphores[currentFrame].image
    
    result := vk.AcquireNextImageKHR(
        logical.device,
        swapchain.swapchain,
        u64(~u64(0)-1),
        imageSem^,
        {},
        &ii
    ); if result != .SUCCESS && result != .SUBOPTIMAL_KHR {
        log.error("Failed to acquire next image!")
        return
    }

    fmt.eprintf("{}\t", ii)

    uboBuffer := &uniformBuffers["ubo"].this[currentFrame]
    {
        using emath

        CameraPos := input.camera.pos
        CameraUp  := Vec3{ 0.0, 1.0, 0.0 }

        aspect: f32 = (f32(swapchain.extent.width) / f32(swapchain.extent.height))

        proj := Perspective(
            60.0 * math.DEG_PER_RAD,
            aspect,
            0.1,
            2048.0
        )
        invProj := linalg.inverse(proj)
        
        view, invView := SetViewTarget(input.camera.pos, { 0.0, 0.0, 0.0 }, WORLD_UP)

        winWidth  := f32(swapchain.extent.width)
        winHeight := f32(swapchain.extent.height)
        deltaTime := f32(rData.deltaTime_f64)

        ubo := s.UBO{
            proj      = proj,
            iProj     = invProj,
            view      = view,
            iView     = invView,
            deltaTime = deltaTime,

            winWidth  = winWidth,
            winHeight = winHeight,

            cameraPos = CameraPos,
            cameraUp  = CameraUp,
            
            worldUp   = WORLD_UP,
            worldTime = worldTime,

            model     = input.modelMatrix
        }
        worldTime += 1
        if worldTime > int(~u16(0)-1) { 
            worldTime = 0
        }

        uboBuffer.ptr = mem.copy(uboBuffer.ptr, rawptr(&ubo), size_of(s.UBO))
    }

    vk.ResetFences(logical.device, 1, fence)

    gcbc := &commandBuffers["global"].this[currentFrame]
    vk.ResetCommandBuffer(gcbc^, {})

    beginInfo: vk.CommandBufferBeginInfo = {
        sType            = .COMMAND_BUFFER_BEGIN_INFO,
        flags            = {},
        pInheritanceInfo = nil,
        pNext            = nil,
    }
    
    result = vk.BeginCommandBuffer(gcbc^, &beginInfo)
    if result != .SUCCESS {
        log.error("Failed to begin command buffer!")
        panic("Failed to begin command buffer!")
    }

    uboDescriptor      := descriptors["ubo"]
    gBuffersDescriptor := descriptors["gBuffers"]

    uboCurrentSet      := uboDescriptor.sets[ii]
    gBuffersCurrentSet := gBuffersDescriptor.sets[ii]
    assert(uboCurrentSet      != {}, "UBO set is nil!")
    assert(gBuffersCurrentSet != {}, "G-Buffers set is nil!")

    posGBuffer    := &gBuffers["geometry.position"]
    albedoGBuffer := &gBuffers["geometry.albedo"]
    normalGBuffer := &gBuffers["geometry.normal"]
    depthGBuffer  := &gBuffers["light.depth"]

    depthBarrier: vk.ImageMemoryBarrier = {
        sType               = .IMAGE_MEMORY_BARRIER,
        srcAccessMask       = { .DEPTH_STENCIL_ATTACHMENT_WRITE },
        dstAccessMask       = { .MEMORY_READ },
        oldLayout           = .UNDEFINED,
        newLayout           = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
        srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        image               = depthGBuffer.images[ii],
        subresourceRange    = {
            aspectMask     = { .DEPTH, .STENCIL },
            baseMipLevel   = 0,
            levelCount     = 1,
            baseArrayLayer = 0,
            layerCount     = 1,
        },
    }
    vk.CmdPipelineBarrier(
        gcbc^,
        { .EARLY_FRAGMENT_TESTS },                    
        { .FRAGMENT_SHADER },                         
        {},                                        
        0, nil,               
        0, nil,          
        1, &depthBarrier 
    );

    preGeometryPassBarriers: []vk.ImageMemoryBarrier = {
        {
            sType               = .IMAGE_MEMORY_BARRIER,
            srcAccessMask       = { .SHADER_READ }, 
            dstAccessMask       = { .COLOR_ATTACHMENT_WRITE },
            oldLayout           = .GENERAL,
            newLayout           = .COLOR_ATTACHMENT_OPTIMAL,
            srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            image               = posGBuffer.images[ii],
            subresourceRange    = {
                aspectMask     = {. COLOR },
                baseMipLevel   = 0,
                levelCount     = 1,
                baseArrayLayer = 0,
                layerCount     = 1,
            },
        },
        {
            sType               = .IMAGE_MEMORY_BARRIER,
            srcAccessMask       = { .SHADER_READ },
            dstAccessMask       = { .COLOR_ATTACHMENT_WRITE },
            oldLayout           = .GENERAL,
            newLayout           = .COLOR_ATTACHMENT_OPTIMAL,
            srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            image               = albedoGBuffer.images[ii],
            subresourceRange    = {
                aspectMask     = { .COLOR },
                baseMipLevel   = 0,
                levelCount     = 1,
                baseArrayLayer = 0,
                layerCount     = 1,
            },
        },
        {
            sType               = .IMAGE_MEMORY_BARRIER,
            srcAccessMask       = { .SHADER_READ },
            dstAccessMask       = { .COLOR_ATTACHMENT_WRITE },
            oldLayout           = .GENERAL,
            newLayout           = .COLOR_ATTACHMENT_OPTIMAL,
            srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            image               = normalGBuffer.images[ii],
            subresourceRange    = {
                aspectMask     = { .COLOR },
                baseMipLevel   = 0,
                levelCount     = 1,
                baseArrayLayer = 0,
                layerCount     = 1,
            },
        },
    }
    vk.CmdPipelineBarrier(
        gcbc^,
        { .FRAGMENT_SHADER },        
        { .COLOR_ATTACHMENT_OUTPUT }, 
        {},                            
        0, nil,                        
        0, nil,                        
        u32(len(preGeometryPassBarriers)), raw_data(preGeometryPassBarriers), 
    );

    colorAttachments[0] = vk.RenderingAttachmentInfo{
        sType       = .RENDERING_ATTACHMENT_INFO,
        imageView   = posGBuffer.views[ii],
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp      = .CLEAR,
        storeOp     = .STORE,
        clearValue  = { color = { float32 = { 0.0, 0.0, 0.0, 1.0 }}},
    }
    colorAttachments[1] = vk.RenderingAttachmentInfo{
        sType       = .RENDERING_ATTACHMENT_INFO,
        imageView   = albedoGBuffer.views[ii],
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp      = .CLEAR,
        storeOp     = .STORE,
        clearValue  = { color = { float32 = { 0.0, 0.0, 0.0, 1.0 }}},
    }
    colorAttachments[2] = vk.RenderingAttachmentInfo{
        sType       = .RENDERING_ATTACHMENT_INFO,
        imageView   = normalGBuffer.views[ii],
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp      = .CLEAR,
        storeOp     = .STORE,
        clearValue  = { color = { float32 = { 0.0, 0.0, 0.0, 1.0 }}},
    }
    colorAttachments[3] = vk.RenderingAttachmentInfo{
        sType       = .RENDERING_ATTACHMENT_INFO,
        imageView   = swapchain.views[ii],
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp      = .CLEAR,
        storeOp     = .STORE,
        clearValue  = { color = { float32 = { 0.0, 0.0, 0.0, 1.0 }}},
    }

    depthAttachment: vk.RenderingAttachmentInfo = {
        sType       = .RENDERING_ATTACHMENT_INFO,
        imageView   = depthGBuffer.views[ii],
        imageLayout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
        loadOp      = .CLEAR,
        storeOp     = .STORE,
        clearValue  = { depthStencil = { depth = 1.0, stencil = 0 }},
    }

    renderingInfo: vk.RenderingInfo = {
        sType                = .RENDERING_INFO,
        renderArea           = { offset = { 0, 0 }, extent = swapchain.extent },
        layerCount           = 1,
        colorAttachmentCount = u32(len(colorAttachments)),
        pColorAttachments    = raw_data(colorAttachments),
        pDepthAttachment     = &depthAttachment,
        pStencilAttachment   = nil,
    }

    vk.CmdBeginRendering(gcbc^, &renderingInfo)

    vk.CmdSetViewport(gcbc^, 0, 1, &viewports["global"]);
    vk.CmdSetScissor(gcbc^, 0, 1, &scissors["global"]);

    vk.CmdBindPipeline(gcbc^, .GRAPHICS, pipelines["geometry"].pipeline);
    vk.CmdBindDescriptorSets(
        gcbc^,
        .GRAPHICS,
        pipelines["geometry"].layout,
        0,
        1,
        &uboDescriptor.sets[currentFrame],
        0,
        nil,
    );
    o.VkDrawMesh(
        gcbc,
        "Monke.glb",
        ":0",
    )

    vk.CmdEndRendering(gcbc^); 

    
    gBufferImageBarriers: []vk.ImageMemoryBarrier = {
        
        {
            sType               = .IMAGE_MEMORY_BARRIER,
            srcAccessMask       = { .COLOR_ATTACHMENT_WRITE },
            dstAccessMask       = { .SHADER_READ },
            oldLayout           = .COLOR_ATTACHMENT_OPTIMAL,
            newLayout           = .GENERAL,
            srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            image               = posGBuffer.images[ii],
            subresourceRange    = {
                aspectMask     = {. COLOR },
                baseMipLevel   = 0,
                levelCount     = 1,
                baseArrayLayer = 0,
                layerCount     = 1,
            },
        },
        
        {
            sType               = .IMAGE_MEMORY_BARRIER,
            srcAccessMask       = { .COLOR_ATTACHMENT_WRITE },
            dstAccessMask       = { .SHADER_READ },
            oldLayout           = .COLOR_ATTACHMENT_OPTIMAL,
            newLayout           = .GENERAL,
            srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            image               = albedoGBuffer.images[ii],
            subresourceRange    = {
                aspectMask     = { .COLOR },
                baseMipLevel   = 0,
                levelCount     = 1,
                baseArrayLayer = 0,
                layerCount     = 1,
            }
        },
        
        {
            sType               = .IMAGE_MEMORY_BARRIER,
            srcAccessMask       = { .COLOR_ATTACHMENT_WRITE },
            dstAccessMask       = { .SHADER_READ },
            oldLayout           = .COLOR_ATTACHMENT_OPTIMAL,
            newLayout           = .GENERAL,
            srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
            image               = normalGBuffer.images[ii],
            subresourceRange    = {
                aspectMask     = { .COLOR },
                baseMipLevel   = 0,
                levelCount     = 1,
                baseArrayLayer = 0,
                layerCount     = 1,
            }
        },
    }
    vk.CmdPipelineBarrier(
        gcbc^,
        { .COLOR_ATTACHMENT_OUTPUT },
        { .FRAGMENT_SHADER },                                 
        {},                                                     
        0, nil,                                                 
        0, nil,                                                 
        u32(len(gBufferImageBarriers)), raw_data(gBufferImageBarriers), 
    );
    

    preLightDepthBarrier: vk.ImageMemoryBarrier = {
        sType               = .IMAGE_MEMORY_BARRIER,
        srcAccessMask       = {},
        dstAccessMask       = { .DEPTH_STENCIL_ATTACHMENT_WRITE },
        oldLayout           = .UNDEFINED,
        newLayout           = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
        srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        image               = depthGBuffer.images[ii],
        subresourceRange    = {
            aspectMask     = {. DEPTH, .STENCIL },
            baseMipLevel   = 0,
            levelCount     = 1,
            baseArrayLayer = 0,
            layerCount     = 1,
        },
    }
    vk.CmdPipelineBarrier(
        gcbc^,
        { .COLOR_ATTACHMENT_OUTPUT },
        { .EARLY_FRAGMENT_TESTS },
        {},
        0, nil,
        0, nil,
        1, &preLightDepthBarrier,
    )

    
    swapchainPreLightBarrier: vk.ImageMemoryBarrier = {
        sType               = .IMAGE_MEMORY_BARRIER,
        srcAccessMask       = {}, 
        dstAccessMask       = { .COLOR_ATTACHMENT_WRITE },
        oldLayout           = .UNDEFINED,
        newLayout           = .COLOR_ATTACHMENT_OPTIMAL,
        srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        image               = swapchain.images[ii],
        subresourceRange    = {
            aspectMask     = { .COLOR },
            baseMipLevel   = 0,
            levelCount     = 1,
            baseArrayLayer = 0,
            layerCount     = 1,
        },
    }
    vk.CmdPipelineBarrier(
        gcbc^,
        { .TOP_OF_PIPE },
        { .COLOR_ATTACHMENT_OUTPUT },
        {},
        0, nil,
        0, nil,
        1, &swapchainPreLightBarrier,
    )

    
    lightColorAttachment: vk.RenderingAttachmentInfo = {
        sType       = .RENDERING_ATTACHMENT_INFO,
        imageView   = swapchain.views[ii],
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp      = .CLEAR, 
        storeOp     = .STORE,
        clearValue  = { color = { float32 = { 0.0, 0.0, 0.0, 1.0 }}},
    }

    renderingInfoLight: vk.RenderingInfo = {
        sType                = .RENDERING_INFO,
        renderArea           = { offset = { 0, 0 }, extent = swapchain.extent },
        layerCount           = 1,
        colorAttachmentCount = 1,
        pColorAttachments    = &lightColorAttachment,
        pDepthAttachment     = nil, 
        pStencilAttachment   = nil,
    }

    vk.CmdBeginRendering(gcbc^, &renderingInfoLight);

    vk.CmdBindPipeline(gcbc^, .GRAPHICS, pipelines["light"].pipeline);
    forLightDescriptors: []vk.DescriptorSet = { uboDescriptor.sets[currentFrame], gBuffersDescriptor.sets[currentFrame] }
    vk.CmdBindDescriptorSets(
        gcbc^,
        .GRAPHICS,
        pipelines["light"].layout,
        0,
        u32(len(forLightDescriptors)),
        raw_data(forLightDescriptors),
        0,
        nil,
    );
    vk.CmdDraw(gcbc^, 6, 1, 0, 0);

    vk.CmdEndRendering(gcbc^); 

    
    imageMemoryBarrier: vk.ImageMemoryBarrier = {
        sType               = .IMAGE_MEMORY_BARRIER,
        srcAccessMask       = { .COLOR_ATTACHMENT_WRITE },
        dstAccessMask       = { .MEMORY_READ },
        oldLayout           = .COLOR_ATTACHMENT_OPTIMAL,
        newLayout           = .PRESENT_SRC_KHR,
        srcQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        dstQueueFamilyIndex = vk.QUEUE_FAMILY_IGNORED,
        image               = swapchain.images[ii],
        subresourceRange    = {
            aspectMask     = {. COLOR },
            baseMipLevel   = 0,
            levelCount     = 1,
            baseArrayLayer = 0,
            layerCount     = 1,
        },
    }
    vk.CmdPipelineBarrier(
        gcbc^,
        { .COLOR_ATTACHMENT_OUTPUT }, 
        { .BOTTOM_OF_PIPE },          
        {},                           
        0, nil,                       
        0, nil,                       
        1, &imageMemoryBarrier,       
    );

    result = vk.EndCommandBuffer(gcbc^)
    if result != .SUCCESS {
        log.error("Failed to end command buffer!")
        panic("Failed to end command buffer!")
    }
    
    {
        renderSem := &syncObjects.semaphores[ii].render

        waitSemaphores:   []vk.Semaphore = { imageSem^ }
        waitStages:       []vk.PipelineStageFlags = {{ .COLOR_ATTACHMENT_OUTPUT }}
        signalSemaphores: []vk.Semaphore = { renderSem^ }

        submitInfo: vk.SubmitInfo = {
            sType                = .SUBMIT_INFO,
            
            waitSemaphoreCount   = u32(len(waitSemaphores)),
            pWaitSemaphores      = raw_data(waitSemaphores),

            pWaitDstStageMask    = raw_data(waitStages),

            commandBufferCount   = 1,
            pCommandBuffers      = gcbc,

            signalSemaphoreCount = u32(len(signalSemaphores)),
            pSignalSemaphores    = raw_data(signalSemaphores),
        }
        result = vk.QueueSubmit(
            physical.queues.graphics,
            1,
            &submitInfo,
            fence^
        ) 
        if result != .SUCCESS {
            panic("Failed to submit command buffer!")
        }

        swapchains: []vk.SwapchainKHR = { swapchain.swapchain }
        presentInfo: vk.PresentInfoKHR = {
            sType              = .PRESENT_INFO_KHR,

            waitSemaphoreCount = u32(len(signalSemaphores)),
            pWaitSemaphores    = raw_data(signalSemaphores),
            
            swapchainCount     = u32(len(swapchains)),
            pSwapchains        = raw_data(swapchains),

            pImageIndices      = &ii,
        }
        result = vk.QueuePresentKHR(
            physical.queues.present,
            &presentInfo
        )
        if result != .SUCCESS && result != .SUBOPTIMAL_KHR {
            log.error(result)
            log.error("Failed to present swapchain image! %s", result)
            panic("Failed to present swapchain image!")
        }
    }

    rData.currentFrame += 1
    rData.currentFrame %= rData.MAX_FRAMES_IN_FLIGHT

    return
}

Wait :: proc() {
    vk.DeviceWaitIdle(vkData.logical.device)
    return
}



