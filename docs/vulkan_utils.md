package vk_util
	procedures
		Transition :: proc(data: ^t.VulkanData = nil, cmd: vk.CommandBuffer = nil, image: vk.Image = 0, srcStage: vk.PipelineStageFlag = .COLOR_ATTACHMENT_OUTPUT, dstStage: vk.PipelineStageFlag = .FRAGMENT_SHADER, srcAccessMask: vk.AccessFlags = {.COLOR_ATTACHMENT_WRITE}, dstAccessMask: vk.AccessFlags = {.SHADER_READ}, srcLayout: vk.ImageLayout = .COLOR_ATTACHMENT_OPTIMAL, dstLayout: vk.ImageLayout = .SHADER_READ_ONLY_OPTIMAL, srcQueueFamilyIndex: u32 = 0, dstQueueFamilyIndex: u32 = 0, aspectMask: vk.ImageAspectFlags = {.COLOR}, baseMipLevel: u32 = 0, levelCount: u32 = 1, baseArrayLayer: u32 = 0, layerCount: u32 = 1) ->  {...}


	fullpath:
		/home/zota/projects/multi/vk_new/src/engine/vulkan/utils
	files:
		transition.odin
