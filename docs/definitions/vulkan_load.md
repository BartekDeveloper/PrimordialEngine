package vk_load
	variables
		allExits: bool = false
		data: ^t.VulkanData = nil
		exists: map[string]b8 = {}
		shaderModules: map[string]vk.ShaderModule = {}

	procedures
		CleanUpShaderModules :: proc() ->  {...}
		CreateShaderModule :: proc(name: string, dir: string) -> (module: vk.ShaderModule, good: bool = true) {...}
		GetModule :: proc(pName: string) -> (module: vk.ShaderModule) {...}
		ProcessShaderFile :: proc(f: ^os.File_Info, #any_int index: u32, dir: string) -> (ok: bool = true) {...}
		SetVulkanDataPointer :: proc(pData: ^t.VulkanData) {...}
		Shaders :: proc(dir: string = "./assets/shaders") ->  {...}
		UnSetVulkanDataPointer :: proc() {...}


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan/load
	files:
		shaders.odin
