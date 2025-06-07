package engine

import "core:log"
import "core:time"
import "base:runtime"

import s "../shared"

import "window"
import "vulkan"

ctx: runtime.Context

Init :: proc() {
    ctx = context
    ctx.logger = log.create_console_logger(.Debug)
    context = ctx

    log.info("Setting up Render Data");
    renderData.MAX_FRAMES_IN_FLIGHT = 3
    log.infof("\tMAX FRAMES IN FLIGHT: %d", renderData.MAX_FRAMES_IN_FLIGHT)

    log.info("Loading models...")
    // WARN: TO BE IMPLEMENTED

    log.info("Creating window...")
    window.Init()

    log.info("Initializing vulkan...")
    vulkan.Init(&renderData)

    log.info("Engine Fully Initialized!")
    return
}

Start :: proc() {
    context = ctx

    log.info("Starting timer")

    start := time.now()._nsec
    end   := time.now()._nsec

    log.info("Window is running")
    for window.Running() {
        // log.debug("\tAdvancing frame")
        end   = time.now()._nsec

        renderData.deltaTime = end - start

        window.Poll()
        vulkan.Render(&renderData)

        renderData.currentFrame += 1
        renderData.currentFrame %= renderData.MAX_FRAMES_IN_FLIGHT
    }
    log.info("Window closed");
    
    log.info("Waiting for vulkan to finish")
    vulkan.Wait()
    return
}

Destroy :: proc() {
    log.info("Destroying vulkan")
    vulkan.Clean(&renderData)

    log.info("Destroying window")
    window.Clean()
    return
}

