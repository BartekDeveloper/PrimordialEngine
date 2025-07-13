package engine

import "core:log"
import "core:time"
import "base:runtime"
import "core:strings"
import "core:mem"
import "core:fmt"

import "core:io"
import "core:c"

import "window"
import "vulkan"
import e "entity"
import s "../shared"

Init :: proc() {
    context.logger = log.create_console_logger(.Debug)
    defer log.destroy_console_logger(context.logger)
    
    renderData = {}
    renderData.MAX_FRAMES_IN_FLIGHT = 3

    log.info("Setting up Render Data");
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
    log.info("Window is running\n\nStarting Timer")
    
    renderData.currentFrame = 0
    assert(renderData.MAX_FRAMES_IN_FLIGHT > 0)
    assert(renderData.MAX_FRAMES_IN_FLIGHT == 3, "MAX_FRAMES_IN_FLIGHT is not 3!")

    start := time.now()._nsec
    for window.Running() {
        end := time.now()._nsec
        renderData.deltaTime = end - start
        start = end

        renderData.deltaTime_f64 = f64(f64(renderData.deltaTime) / f64(1_000_000_000.00))
        if renderData.deltaTime_f64 <= 0.0 {
            renderData.deltaTime_f64 = 0.1
        }

        window.Poll()
        vulkan.Render(&renderData)

        time.sleep(time.Duration(1_000_000_00)) 

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

