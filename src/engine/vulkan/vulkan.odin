package vulkan_renderer

import "core:math/linalg"
import "core:math"
import "core:log"
import "core:c"

import "core:fmt"
import "core:mem"
import "base:runtime"

import vk "vendor:vulkan"

import "destroy"
import "load"
import "utils"
import t "types"
import o "objects"
import "../window"
import obj "../objects"
import s "../../shared"
import emath "../../maths"

vkData: t.VulkanData = {}

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
    )
    if result != .SUCCESS && result != .SUBOPTIMAL_KHR {
        log.error("Failed to acquire next image!")
        return
    }

    uboBuffer := &uniformBuffers["ubo"].this[currentFrame]
    {
        using emath
        
        /*
            ! UniformBufferObject :: #type struct {
                ? Important
                * proj:      emath.Mat4,
                * iProj:     emath.Mat4,
                * view:      emath.Mat4,
                * iView:     emath.Mat4,
                * deltaTime: f32,

                ? Window
                * winWidth:  f32,
                * winHeight: f32,

                ? Camera
                * cameraPos: emath.Vec3,
                * cameraUp:  emath.Vec3,
                
                ? World
                * worldUp:   emath.Vec3,
                * worldTime: int,
            }
        */

        // proj := Perspective(45.0, 1.0, 0.1, 128.0)
        // view := LookAt({0, 0, 5}, {0, 0, 0}, {0, 1, 0})
        
        CameraPos := Vec3{ 0, 0, 0 }
        CameraUp  := Vec3{ 0, 1, 0 }

        aspect: f32 = (f32(swapchain.extent.width) / f32(swapchain.extent.height))

        proj := linalg.matrix4_infinite_perspective_f32(
            60.0 * (math.PI / 180.0),
            aspect,
            5
        )
        view := linalg.matrix4_look_at_f32(
            { 0, 0, 5 },
            CameraPos,
            CameraUp
        ) 

        // invProj := Inverse(proj)
        // invView := Inverse(view)

        invProj := linalg.inverse(proj)
        invView := linalg.inverse(view)

        WORLD_UP :: emath.Vec3{ 0, 1, 0 }
        
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

            model = {
                0.5, 0.0, 0.0, 0.0,
                0.0, 0.5, 0.0, 0.0,
                0.0, 0.0, 0.5, 0.0,
                0.0, 0.0, 0.0, 1.0,
            }
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
        sType = .COMMAND_BUFFER_BEGIN_INFO,
        flags = { .SIMULTANEOUS_USE },
        pInheritanceInfo = nil,
        pNext = nil,
    }
    
    result = vk.BeginCommandBuffer(gcbc^, &beginInfo)
    if result != .SUCCESS {
        log.error("Failed to begin command buffer!")
        panic("Failed to begin command buffer!")
    }

    positionGBuffer    := &gBuffers["geometry.position"]
    albedoGBuffer      := &gBuffers["geometry.albedo"]
    normalGBuffer      := &gBuffers["geometry.normal"]

    uboDescriptor      := descriptors["ubo"]
    gBuffersDescriptor := descriptors["gBuffers"]

    uboCurrentSet      := uboDescriptor.sets[currentFrame]
    gBuffersCurrentSet := gBuffersDescriptor.sets[currentFrame]
    assert(uboCurrentSet      != {}, "UBO set is nil!")
    assert(gBuffersCurrentSet != {}, "G-Buffers set is nil!")

    lightPass := passes["light"]
    geometryPass   := passes["geometry"]

    lFb       := lightPass.frameBuffers[ii]
    gFb       := geometryPass.frameBuffers[ii] 

    geometryPass.clearValues = {
        {
            color = { float32 = { 0.0, 0.0, 0.0, 1.0 }},
        },
        {
            color = { float32 = { 0.0, 0.0, 0.0, 1.0 }},
        },
        {
            color = { float32 = { 0.0, 0.0, 0.0, 1.0 }},
        },
        {
            depthStencil = { depth = 0.0, stencil = 0 },
        }
    }
    renderPassBeginInfo: vk.RenderPassBeginInfo = {
        sType                   = .RENDER_PASS_BEGIN_INFO,
        renderPass              = geometryPass.renderPass,
        framebuffer             = gFb,
        renderArea = {
            offset = {0, 0},
            extent = swapchain.extent,
        },
        clearValueCount = u32(len(geometryPass.clearValues)),
        pClearValues    = raw_data(geometryPass.clearValues),
    }
    vk.CmdBeginRenderPass(
        gcbc^,
        &renderPassBeginInfo,
        .INLINE
    )
    {
        vk.CmdSetViewport(gcbc^, 0, 1, &viewports["global"])
        vk.CmdSetScissor(gcbc^, 0, 1, &scissors["global"])
        
        vk.CmdBindPipeline(gcbc^, .GRAPHICS, pipelines["geometry"].pipeline)
        
        vk.CmdBindDescriptorSets(
            gcbc^,
            .GRAPHICS,
            pipelines["geometry"].layout,
            0, 1,
            &uboCurrentSet,
            0, nil
        )
        // o.DisplayAllModelBuffers()
        o.VkDrawMesh(gcbc, "Monke", "Cube_0")
    }
    vk.CmdEndRenderPass(gcbc^)

    lightPass.clearValues = {
        {
            color = { float32 = { 0.0, 0.0, 0.0, 1.0 }},
        },
        {
            depthStencil = { depth = 0.0, stencil = 0 },
        }
    }
    renderPassBeginInfo = vk.RenderPassBeginInfo{
        sType                   = .RENDER_PASS_BEGIN_INFO,
        renderPass              = lightPass.renderPass,
        framebuffer             = lFb,
        renderArea = {
            offset = {0, 0},
            extent = swapchain.extent,
        },
        clearValueCount = u32(len(lightPass.clearValues)),
        pClearValues    = raw_data(lightPass.clearValues),
    }
    vk.CmdBeginRenderPass(
        gcbc^,
        &renderPassBeginInfo,
        .INLINE
    )
    {
        vk.CmdSetViewport(gcbc^, 0, 1, &viewports["global"])
        vk.CmdSetScissor(gcbc^, 0, 1, &scissors["global"])
        
        vk.CmdBindPipeline(gcbc^, .GRAPHICS, pipelines["light"].pipeline)
        
        lightDescriptors: []vk.DescriptorSet = { uboCurrentSet, gBuffersCurrentSet }
        vk.CmdBindDescriptorSets(
            gcbc^,
            .GRAPHICS,
            pipelines["light"].layout,
            0, u32(len(lightDescriptors)),
            raw_data(lightDescriptors),
            0, nil
        )

        vk.CmdDraw(gcbc^, 6, 1, 0, 0)
    }
    vk.CmdEndRenderPass(gcbc^)

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
    // if rData.currentFrame > 1 do panic("Frame!")

    return
}

Wait :: proc() {
    vk.DeviceWaitIdle(vkData.logical.device)
    return
}



