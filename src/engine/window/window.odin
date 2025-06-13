package window

import "core:log"
import "core:c"

import sdl "vendor:sdl3"
import vk  "vendor:vulkan"

WindowData :: #type struct {
    width, height: i32,
    title:         cstring,
    closing:       bool,
    ptr:           ^sdl.Window,
    event:         ^sdl.Event
}
defaultWD: WindowData = {
    width   = 1280,
    height  = 720,
    title   = "Hello World!",
    closing = false,
    ptr     = nil,
}
defaultWindowData: ^WindowData = &defaultWD

Init :: proc(
    data: ^WindowData = defaultWindowData
) {
    windowInitFlags := sdl.InitFlags{
        .VIDEO, .EVENTS
    }

    windowFlags := sdl.WindowFlags{
        .VULKAN,  .ALWAYS_ON_TOP,
        .INPUT_FOCUS, .EXTERNAL
    }

    log.info("\t SDL Initialization")
    if !sdl.Init(windowInitFlags) {
        log.panic("SDL3 Initialization failed!:\n\t %s", sdl.GetError())
    }
    log.info("\t SDL Finished Initialization")     

    log.info("\t SDL Window creation")
    data.ptr = sdl.CreateWindow(data.title, data.width, data.height, windowFlags)
    if data.ptr == nil {
        log.panicf("Failed to create window!:\n\t %s", sdl.GetError())
    }
    log.info("\t SDL Window created")

    log.info("\t Showing created window")
    if !sdl.ShowWindow(data.ptr) {
        log.panicf("Failed to show window!:\n\t %s", sdl.GetError())
    }
    log.info("\t Window showed")

    /*
    r: ^sdl.Renderer = nil
    r = sdl.CreateRenderer(data.ptr, nil)
    if r == nil {
        log.panicf("Failed to create renderer!:\n\t %s", sdl.GetError())
    }

    sdl.Delay(1000)

    if !sdl.SetRenderDrawColor(r, 0, 0, 50, 255) do log.panicf("Failed to set draw color!:\n\t %s", sdl.GetError())
    if !sdl.RenderClear(r)   do log.panicf("Failed to clear!:\n\t %s", sdl.GetError()) 
    if !sdl.RenderPresent(r) do log.panicf("Failed to present!:\n\t %s", sdl.GetError())

    sdl.Delay(10000)
    */

    return
}

Running :: proc(
    data: ^WindowData = defaultWindowData
) -> bool {
   return (data.closing == false)
}

Poll :: proc(
    data: ^WindowData = defaultWindowData
) {
    if !sdl.PollEvent(data.event) == false || data.event == nil {
        return
    }
    
    log.info(data.event)

    if (data.event.type == .QUIT) {
        data.closing = true
    }

    return
}

Clean :: proc(
    data: ^WindowData = defaultWindowData
) {
    sdl.DestroyWindow(data.ptr)
    sdl.Quit()

    return
}

/* HELPER FUNCTIONS */

GetInstanceExtensions :: proc() -> (ext: []cstring) {
    extensionsCount: u32
    extensions     := sdl.Vulkan_GetInstanceExtensions(&extensionsCount)
    
    ext = make([]cstring, extensionsCount)
    for &e, i in ext do e = extensions[i]

    return
}

ProcAddr := sdl.Vulkan_GetVkGetInstanceProcAddr 

VulkanCreateSurface :: proc(instance: ^vk.Instance, surface: ^vk.SurfaceKHR, data: ^WindowData = defaultWindowData) -> () {
    if !sdl.Vulkan_CreateSurface(data.ptr, instance^, nil, surface) {
        panic("SDL3 Failed to create Vulkan Surface")
    }
   
    return
}

GetFrameBufferSize_return :: proc(window: ^sdl.Window = defaultWindowData.ptr) -> (width, height: u32) {
    width_int, height_int: c.int
    sdl.GetWindowSizeInPixels(window, &width_int, &height_int)

    width  = u32(width_int)
    height = u32(height_int)

    return
}

GetFrameBufferSize_modify :: proc(width, height: ^u32, window: ^sdl.Window = defaultWindowData.ptr) {
    width^, height^ = GetFrameBufferSize_return(window)
    return
}

GetFrameBufferSize :: proc{
    GetFrameBufferSize_return,
    GetFrameBufferSize_modify,
}

