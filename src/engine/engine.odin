package engine

import "core:log"
import "core:time"
import "base:runtime"
import "core:strings"
import "core:mem"
import "core:fmt"

import "core:io"
import "core:c"

import s "../shared"
import "window"
import "vulkan"

Init :: proc() {
    context.logger = log.create_console_logger(.Debug)
    defer log.destroy_console_logger(context.logger)
    
    log.info("Setting up Render Data");
    renderData.MAX_FRAMES_IN_FLIGHT = 2
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
    log.info("Window is running")
    log.info("Starting timer")    
    
    start := time.now()._nsec
    for window.Running() {
        end := time.now()._nsec
        renderData.deltaTime = end - start
        start = end

        renderData.deltaTime_f32 = f32(renderData.deltaTime) / f32(1_000_000_000.00)
        if renderData.deltaTime_f32 <= 0.0 {
            renderData.deltaTime_f32 = 0.001
        }

        window.Poll()
        vulkan.Render(&renderData)

        // fps := f32(1.0/(renderData.deltaTime_f32))
        // fmt.eprintf("\t  FPS: %.1f \t\t", fps)
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

    log.destroy_console_logger(context.logger)
    return
}

