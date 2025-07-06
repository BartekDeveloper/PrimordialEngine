# `objects.odin` (in `vulkan/objects`)

This file manages the creation, storage, and drawing of 3D model data (vertices and indices) in Vulkan buffers.

## Global Variables

-   `data`: A pointer to the `t.VulkanData` struct, providing access to Vulkan-related data.
-   `buffers`: A nested map that stores `VkDataBuffer` structs. The outer map is keyed by model name, and the inner map is keyed by mesh name. This structure allows for efficient lookup of vertex and index buffers for specific meshes within a model.

## `SetDataPointer` procedure

Sets the `data` global variable to the provided `t.VulkanData` pointer.

## `UnSetDataPointer` procedure

Sets the `data` global variable to `nil`.

## `VkDataBuffer` struct

This struct represents the Vulkan buffer data for a single mesh. It contains:

-   `vertex`: A `t.Buffer` struct for the vertex buffer.
-   `index`: A `t.Buffer` struct for the index buffer.
-   `vertexCount`: The number of vertices in the mesh.
-   `indexCount`: The number of indices in the mesh.
-   `hasIndices`: A boolean indicating whether the mesh uses an index buffer.

## `CreateBuffersForModel` procedure

This procedure creates Vulkan vertex and index buffers for a specified 3D model. It retrieves the model's data from the `obj` package (likely `src/engine/objects/`) and then iterates through each mesh within the model. For each mesh, it:

1.  Creates a vertex buffer using `create.Buffer_modify`.
2.  Copies the vertex data to the newly created buffer using `copy.ToBuffer`.
3.  If the mesh has indices, it creates an index buffer and copies the index data to it.

## `CreateBuffersForAllModels` procedure

This procedure iterates through all loaded model names (obtained from `obj.ListModelNames()`) and calls `CreateBuffersForModel` for each one, effectively creating Vulkan buffers for all 3D models in the scene.

## `CleanUpBuffersForModel` procedure

This procedure cleans up the Vulkan buffers associated with a specific model. It retrieves the model's buffers from the `buffers` map and then calls `destroy.Buffer` for both the vertex and index buffers of each mesh. Finally, it deletes the entries for the model from the `buffers` map.

## `CleanUpAllBuffers` procedure

This procedure cleans up all Vulkan buffers created by this module. It iterates through all models and their meshes in the `buffers` map, destroying their vertex and index buffers, and then clears the `buffers` map itself.

## `VkDrawMesh` procedure

This procedure binds the vertex and index buffers for a specified mesh and then issues a draw call. It takes a Vulkan command buffer, the model name, and the mesh name as input. It handles both indexed and non-indexed drawing.
