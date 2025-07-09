package window
	variables
		ProcAddr := sdl.Vulkan_GetVkGetInstanceProcAddr
		defaultWD: WindowData = {width = 1280, height = 720, title = "Hello World!", closing = false, ptr = nil}
		defaultWindowData: ^WindowData = &defaultWD

	procedures
		Clean :: proc(data: ^WindowData = defaultWindowData) {...}
		GetFrameBufferSize_modify :: proc(width, height: ^u32, window: ^sdl.Window = defaultWindowData.ptr) {...}
		GetFrameBufferSize_return :: proc(window: ^sdl.Window = defaultWindowData.ptr) -> (width, height: u32) {...}
		GetInstanceExtensions :: proc() -> (ext: []cstring) {...}
		Init :: proc(data: ^WindowData = defaultWindowData) {...}
		Poll :: proc(data: ^WindowData = defaultWindowData) -> (result: string = "", good: bool = true) {...}
		Running :: proc(data: ^WindowData = defaultWindowData) -> bool {...}
		VulkanCreateSurface :: proc(instance: ^vk.Instance, surface: ^vk.SurfaceKHR, data: ^WindowData = defaultWindowData, allocations: ^vk.AllocationCallbacks = nil) ->  {...}

	proc_group
		GetFrameBufferSize :: proc{GetFrameBufferSize_return, GetFrameBufferSize_modify}

	types
		WindowData :: #type struct {width, height: i32, title: cstring, closing: bool, ptr: ^sdl.Window, event: sdl.Event}


	fullpath:
		/home/zota/projects/multi/vk_dynamic/src/engine/window
	files:
		vulkan.odin
		window.odin
