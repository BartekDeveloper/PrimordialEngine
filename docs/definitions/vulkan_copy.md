package vk_copy
	procedures
		ToBuffer_unified :: proc(data: ^t.VulkanData, buffer: ^t.Buffer, srcData: rawptr, size: vk.DeviceSize) ->  {...}
		ToBuffer_vulkan :: proc(data: ^t.VulkanData, buffer: vk.Buffer, memory: vk.DeviceMemory, srcData: rawptr, size: vk.DeviceSize) ->  {...}

	proc_group
		ToBuffer :: proc{ToBuffer_vulkan, ToBuffer_unified}


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan/copy
	files:
		buffers.odin
