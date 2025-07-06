# `read.odin` (in `engine/objects`)

This file is responsible for parsing and processing 3D model data from various file formats, primarily glTF (GL Transmission Format), using the `vendor:cgltf` library.

## Global Variables

-   `defaultOptions`: Default options for the `cgltf` library.
-   `currentIndex`: A `u32` used as an index during vertex processing.

## `Load` procedure group

This procedure group provides two ways to load 3D model data:

-   **`Load_fromFile`**: Loads model data from a specified file path. It uses `cgltf.parse_file` and `cgltf.load_buffers` to read and parse the glTF file. It then calls `ProcessData` to convert the parsed data into the engine's internal `SceneData` format.
-   **`Load_fromMemory`**: Loads model data from a byte buffer in memory. Similar to `Load_fromFile`, it uses `cgltf.parse` and `cgltf.load_buffers` to process the data and then calls `ProcessData`.

## `ProcessData` procedure

This procedure takes the raw parsed `cgltf.data` and converts it into the engine's `SceneData` structure. It iterates through the meshes in the `cgltf.data` and calls `ProcessMesh` for each one.

## `ProcessMesh` procedure

This procedure processes a single `cgltf.mesh` and converts it into the engine's `Model` structure. It iterates through the primitives within the mesh and calls `ProcessPrimitive` for each.

## `ProcessPrimitive` procedure

This procedure processes a single `cgltf.primitive` and converts it into the engine's `Mesh` structure. It extracts vertex attributes (position, UVs, normals, tangents, colors, joints) and populates the `vertices` array. It also determines the primitive type (e.g., triangles, lines).

## `ProcessVertex` procedure

This procedure reads the vertex attributes for a single vertex from the `cgltf.accessor` objects and populates an `s.Vertex` struct. It uses helper functions like `ReadVec3`, `ReadVec2` to read data from the accessors.

## Index Management Procedures

-   **`SetIndex`**: Sets the `currentIndex`.
-   **`GetIndex`**: Returns the `currentIndex`.
-   **`AddIndex`**: Increments the `currentIndex`.

## `Read` procedure group

This procedure group provides various functions for reading data from `cgltf.accessor` objects:

-   **`ReadFloat`**: Reads floating-point data.
-   **`ReadUint`**: Reads unsigned integer data.
-   **`ReadVec4`, `ReadVec3`, `ReadVec2`, `ReadF32`**: Read vector and scalar floating-point data.
-   **`ReadVec4U`, `ReadVec3U`, `ReadVec2U`, `ReadU32`**: Read vector and scalar unsigned integer data.

## `MapAccessor` procedure

Maps a `cgltf.attribute` to its corresponding `cgltf.accessor` in a provided map.

## `CheckAccessor` procedure

Checks if an accessor with a given name exists in the provided map and returns a pointer to it.

## `CleanUp` procedure

Cleans up the memory allocated for the loaded model data. It iterates through all `SceneData`, `Model`, and `Mesh` objects and frees their associated vertex and index data.
