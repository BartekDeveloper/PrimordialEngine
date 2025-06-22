package vulkan_renderer

import "core:log"
import "core:c"
import "core:os"
import "core:fmt"
import "core:mem"
import "base:runtime"

import vk "vendor:vulkan"

import "destroy"
import "load"
import t "types"
import "../window"
import s "../../shared"
import emath "../../maths"

vkData: t.VulkanData = {}

Init :: proc(rData: ^s.RenderData) {
    InitFromZero(&vkData, rData)

    lightPass := vkData.passes["light"]
    fmt.eprintfln("Framebuffers count: %d", len(lightPass.frameBuffers))
    assert(len(lightPass.frameBuffers) > 0, "Framebuffers are empty?!")

    return
}

Render :: proc(
    rData: ^s.RenderData = nil
) -> () {
    using vkData;

    currentFrame := rData.currentFrame
    fence        := &syncObjects.fences[currentFrame].this

    vk.WaitForFences(logical.device, 1, fence, true, ~u64(0)-1)

    imageSem     := &syncObjects.semaphores[currentFrame].image
    
    ii: u32 = 0 /* Image Index */
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

    uboBuffer := uniformBuffers["ubo"].this[currentFrame]
    {
        using emath;
        
        ubo: s.UBO = {
            cameraPos = { 0, 0, 0 },
            cameraUp  = { 0, 1, 0 },
            worldUp   = { 0, 1, 0 },
            
            worldTime = 0,
            deltaTime = rData.deltaTime_f32,
            // proj      = Perspective(45.0, 1.0, 0.1, 128.0),
            // iProj     = Inverse(Perspective(88.0, 1.0, 0.1, 100.0)),
            // view      = LookAt({0, 0, 5}, {0, 0, 0}, {0, 1, 0}),
            // iView     = Inverse(LookAt({0, 0, 5}, {0, 0, 0}, {0, 1, 0})),
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

    uboDescriptor := descriptors["ubo"]
    uboCurrentSet := uboDescriptor.sets[currentFrame]
    assert(uboCurrentSet != {}, "UBO set is nil!")

    lightPass := passes["light"]
    lFb       := lightPass.frameBuffers[ii]

    lightPass.clearValues = {
        {
            color = { float32 = { 0.0, 0.0, 0.0, 1.0 }},
        },
        {
            depthStencil = { depth = 0.0, stencil = 0 },
        }
    }

    renderPassBeginInfo: vk.RenderPassBeginInfo = {
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
        vk.CmdSetScissor( gcbc^, 0, 1, &scissors["global"])
        
        vk.CmdBindPipeline(gcbc^, .GRAPHICS, pipelines["light"].pipeline)
        
        vk.CmdBindDescriptorSets(
            gcbc^,
            .GRAPHICS,
            pipelines["light"].layout,
            0, 1,
            &uboCurrentSet,
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

    rData.currentFrame = (rData.currentFrame + 1) % rData.MAX_FRAMES_IN_FLIGHT
    return
}

Wait :: proc() {
    vk.DeviceWaitIdle(vkData.logical.device)
    return
}

Clean :: proc(data: ^s.RenderData) {
    using data;

    load.SetVulkanDataPointer(&vkData)
    defer load.RemoveVulkanDataPointer()

    //? Vulkan Data Cleaning functions
    destroy.AdditionalData(&vkData)
    destroy.SyncObjects(&vkData)
    destroy.Samplers(&vkData)
    destroy.DescriptorPools(&vkData)
    destroy.UniformBuffers(&vkData)
    destroy.CommandPools(&vkData)
    destroy.CommandBuffers(&vkData)
    destroy.FrameBuffers(&vkData)
    destroy.Pipelines(&vkData)
    destroy.DescriptorSetLayouts(&vkData)
    destroy.RenderPasses(&vkData)    
    destroy.Swapchain(&vkData)
    load.CleanUpShaderModules()
    destroy.LogicalDevice(&vkData)
    destroy.PhysicalDeviceData(&vkData)
    destroy.Surface(&vkData)
    destroy.Instance(&vkData)
    destroy.AppInfo(&vkData)

    // Loaded Vulkan Data Cleaning functions

    //* Now LETS SET ALL OF THE DATA(Vulkan Data) free
    //* and then set them to nil pointers
    //? ... End of vulkan deinitialization
    
    //! Engine DeInit in other file!

    return
}


