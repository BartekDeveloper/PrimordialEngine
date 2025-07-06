# `types.odin` (in `engine/objects`)

This file defines the data structures and utility procedures used for representing and converting 3D model data within the engine.

## Type Aliases

-   `joint`: Alias for `u8`, likely representing a joint index in skeletal animation.

## `PrimitiveType` enum

An enumeration defining the different types of geometric primitives that can be rendered:

-   `Invalid`
-   `Point`
-   `Line`
-   `Triangle`
-   `TriangleStrip`
-   `TriangleFan`

## `Mesh` struct

Represents a single mesh within a 3D model. It contains:

-   `vertices`: A slice of `s.Vertex` (from `shared.odin`) representing the vertex data.
-   `indices`: A slice of `u32` representing the index data (for indexed drawing).
-   `joints`: A slice of `joint` (u8), likely for skeletal animation data.
-   `verticesCount`: The number of vertices in the mesh.
-   `indicesCount`: The number of indices in the mesh.
-   `type`: The `PrimitiveType` of the mesh.

## `SceneFlag` enum

An enumeration defining flags for a scene:

-   `ReLoad`
-   `Invalid`

## `SceneFlags` bit set

A bit set based on `SceneFlag`, allowing multiple flags to be set for a scene.

## `Model` struct

Represents a model within a scene. It contains:

-   `name`: The name of the model (cstring).
-   `meshes`: A map of `Mesh` structs, keyed by mesh name.

## `Models` type alias

An alias for `map[string]Model`, representing a collection of models.

## `SceneData` struct

Represents a complete 3D scene. It contains:

-   `path`: The path from which the scene data was loaded.
-   `objects`: A `Models` map containing all the models in the scene.
-   `flags`: `SceneFlags` for the scene.

## Global Variables

-   `modelGroups`: A map of `SceneData` structs, keyed by model group name.
-   `modelExists`: A map of booleans, indicating if a model exists, keyed by model name.
-   `allLoaded`: A boolean indicating if all models have been loaded.

## `ConvertPrimitive` procedure group

This procedure group provides functions for converting between `cgltf.primitive_type` (from the `cgltf` vendor library) and the engine's internal `PrimitiveType` enum:

-   **`ConvertPrimitive_fromTfToUnified`**: Converts from `cgltf.primitive_type` to `PrimitiveType`.
-   **`ConvertPrimitive_fromUnifiedToTf`**: Converts from `PrimitiveType` to `cgltf.primitive_type`.
