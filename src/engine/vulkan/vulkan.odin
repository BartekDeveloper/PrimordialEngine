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

WORLD_UP  :: emath.Vec3{ 0.0, 0.0, 1.0 } 

worldTime: int = 0 /* World  Time */
ii:        u32 = 0 /* Image Index */

scene:  obj.SceneData = {}
object: obj.Model     = {}
mesh:   obj.Mesh      = {}
firstVertex: s.Vertex = {}

LoadTestData :: proc() -> () {
    ok: bool = true

    scene, ok   = obj.GetModel("Cube")
    object      = scene.objects["mesh_Cube_#0"]
    mesh        = object.meshes["Cube.001_0"]
    firstVertex = mesh.vertices[0]

    return
}

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

        CameraPos := input.camera.pos
        CameraUp  := Vec3{ 0.0, 1.0, 0.0 }

        aspect: f32 = (f32(swapchain.extent.width) / f32(swapchain.extent.height))

        proj := linalg.matrix4_perspective_f32(
            60.0 * (math.PI / 180.0),
            aspect,
            0.1,
            2048.0
        )
        view := linalg.matrix4_look_at_f32(
            { 0, 0, 0 },
            CameraPos,
            CameraUp
        ) 

        invProj := linalg.inverse(proj)
        invView := linalg.inverse(view)
        
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

        /*
        mat4 modelView = ubo.view * ubo.model;
        mat4 worldView = ubo.proj * modelView;
        vec4 position  = worldView * vec4(inPos, 1.0);
        */

        position: Vec4 = {}
        position.x = firstVertex.pos.x
        position.y = firstVertex.pos.y
        position.z = firstVertex.pos.z
        position.z = 1.0

        // fmt.eprintfln("{}", position)

        // fmt.eprintfln("{}", 
        //     ubo.proj * ubo.view * ubo.model * position
        // )

        uboBuffer.ptr = mem.copy(uboBuffer.ptr, rawptr(&ubo), size_of(s.UBO))
    }

    vk.ResetFences(logical.device, 1, fence)

    gcbc := &commandBuffers["global"].this[currentFrame]
    vk.ResetCommandBuffer(gcbc^, {})

    beginInfo: vk.CommandBufferBeginInfo = {
        sType = .COMMAND_BUFFER_BEGIN_INFO,
        flags = {},
        pInheritanceInfo = nil,
        pNext = nil,
    }
    
    result = vk.BeginCommandBuffer(gcbc^, &beginInfo)
    if result != .SUCCESS {
        log.error("Failed to begin command buffer!")
        panic("Failed to begin command buffer!")
    }

    uboDescriptor      := descriptors["ubo"]
    gBuffersDescriptor := descriptors["gBuffers"]

    uboCurrentSet      := uboDescriptor.sets[currentFrame]
    gBuffersCurrentSet := gBuffersDescriptor.sets[currentFrame]
    assert(uboCurrentSet      != {}, "UBO set is nil!")
    assert(gBuffersCurrentSet != {}, "G-Buffers set is nil!")

    combinedPass := &passes["combined"]
    fb           := &combinedPass.frameBuffers[ii]

    posGBuffer    := &gBuffers["geometry.position"]
    albedoGBuffer := &gBuffers["geometry.albedo"]
    normalGBuffer := &gBuffers["geometry.normal"]

    combinedPass.clearValues = {
        { color        = { float32 = { 0.0, 0.0, 0.0, 1.0 }}}, // Position
        { color        = { float32 = { 0.0, 0.0, 0.0, 1.0 }}}, // Albedo
        { color        = { float32 = { 0.0, 0.0, 0.0, 1.0 }}}, // Normal
        { color        = { float32 = { 0.0, 0.0, 0.0, 1.0 }}}, // Swapchain
        { depthStencil = { depth   = 0.0,     stencil = 0  }}, // Depth
    }
    renderPassBeginInfo: vk.RenderPassBeginInfo = {
        sType           = .RENDER_PASS_BEGIN_INFO,
        renderPass      = combinedPass.renderPass,
        framebuffer     = fb^,
        renderArea      = {{0, 0}, swapchain.extent},
        clearValueCount = u32(len(combinedPass.clearValues)),
        pClearValues    = raw_data(combinedPass.clearValues),
    };

    vk.CmdBeginRenderPass(
        gcbc^,
        &renderPassBeginInfo,
        .INLINE
    );
    {
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
            "Cube",
            "Cube.001_0",
        )

        vk.CmdNextSubpass(gcbc^, .INLINE);

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

    }
    vk.CmdEndRenderPass(gcbc^);

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



