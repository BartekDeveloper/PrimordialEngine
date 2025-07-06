# `prepare.odin` (in `engine/objects`)

This file handles the loading, management, and basic querying of 3D models within the engine.

## Global Variables

-   `modelGroups`: A map that stores `SceneData` structs, keyed by the model name. This holds the parsed data for each loaded 3D model.
-   `modelExists`: A map that tracks whether a model has been loaded, keyed by its name.
-   `allLoaded`: A boolean flag indicating whether all models have been loaded.

## `GetModel` procedure

Retrieves the `SceneData` for a given model name. Returns the `SceneData` and a boolean indicating if the model was found.

## `ModelExists` procedure

Checks if a model with the given name has been loaded. Returns `true` if it exists, `false` otherwise.

## `LoadModels` procedure

This is the main procedure for loading 3D models. It opens the specified directory (defaults to `./assets/models`), reads all files within it, and calls `ProcessModelFile` for each file. It only processes files with `.gltf` or `.glb` extensions.

## `ProcessModelFile` procedure

This procedure processes a single model file. It checks the file extension, loads the model data using `Load_fromFile` (presumably from `read.odin`), and stores the parsed `SceneData` in the `modelGroups` map. It also updates the `modelExists` map.

## `PrintAllModels` procedure

Prints a detailed summary of all loaded models, including their scene name, object count, mesh count, and vertex/index counts for each mesh.

## `ListModelNames` procedure

Returns a slice of strings containing the names of all currently loaded models.

## `CleanUpModels` procedure

Cleans up all loaded model data. It calls `CleanUp` (presumably from `read.odin`) and then clears the `modelExists` map and sets `allLoaded` to `false`.
