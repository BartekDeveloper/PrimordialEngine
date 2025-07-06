# `main.odin`

This file is the main entry point for the application.

## `main` procedure

The `main` procedure is the first code to be executed. It performs the following actions:

1.  **Initializes a memory tracker (in debug mode):** When the application is compiled with the `ODIN_DEBUG` flag, it sets up a memory tracking allocator to detect memory leaks. It prints a summary of any unfreed memory upon exit.
2.  **Loads 3D models:** It calls `obj.LoadModels()` to load all 3D models from the `assets/models` directory.
3.  **Initializes the engine:** It calls `engine.Init()` to initialize the rendering engine.
4.  **Starts the engine's main loop:** It calls `engine.Start()` to begin the main application loop, which handles rendering and user input.
5.  **Cleans up resources:** It uses `defer` statements to ensure that `obj.CleanUpModels()` and `engine.Destroy()` are called before the application exits, freeing up all allocated resources.
