# `pipelines.odin` (in `vulkan/destroy`)

This file provides procedures for destroying Vulkan pipelines, pipeline layouts, and pipeline caches.

## `Pipelines` procedure

This procedure iterates through all pipelines stored in `data.pipelines`. For each pipeline, it calls the `Pipeline` procedure to destroy the pipeline and its associated cache, and then calls `PipelineLayout` to destroy the pipeline's layout. Finally, it deletes the `pipelines` map itself, along with the global viewports and scissors maps.

## `PipelineLayout` procedure

This procedure destroys a single Vulkan pipeline layout. It checks if the `pipelineLayout` handle is valid before destroying it using `vk.DestroyPipelineLayout`.

## `Pipeline` procedure

This procedure destroys a single Vulkan pipeline and its associated pipeline cache. It checks if the `pipeline` and `cache` handles are valid before destroying them using `vk.DestroyPipeline` and `vk.DestroyPipelineCache`. It also clears the `createInfo` field of the `t.Pipeline` struct and frees memory allocated for pipeline stages and states.
