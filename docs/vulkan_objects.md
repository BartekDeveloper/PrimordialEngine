package vk_object
	variables
		buffers: map[string]map[string]VkDataBuffer = {}
		data: ^t.VulkanData = nil

	procedures
		CleanUpAllBuffers :: proc() ->  {...}
		CleanUpBuffersForModel :: proc(name: string) {...}
		CreateBuffersForAllModels :: proc() ->  {...}
		CreateBuffersForModel :: proc(name: string = "") {...}
		SetDataPointer :: proc(pData: ^t.VulkanData) {...}
		UnSetDataPointer :: proc() {...}
		VkDrawMesh :: proc(cmd: ^vk.CommandBuffer = nil, name: string = "", meshName: string = "") ->  {...}

	types
		VkDataBuffer :: struct {vertex: t.Buffer, index: t.Buffer, vertexCount: u32, indexCount: u32, hasIndices: bool}


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan/objects
	files:
		objects.odin
