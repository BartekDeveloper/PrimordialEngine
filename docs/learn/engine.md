# `engine.odin`

This file contains the core logic of the rendering engine.

## `Init` procedure

Initializes the engine. This includes:

-   Setting up a console logger.
-   Initializing the `renderData` struct, which holds rendering-related data.
-   Creating the application window.
-   Initializing the Vulkan renderer.

## `Start` procedure

Starts the engine's main loop. This loop continues as long as the window is open and performs the following actions on each iteration:

-   Calculates the delta time (the time elapsed since the last frame).
-   Polls for user input and window events.
-   Calls the Vulkan renderer's `Render` procedure to draw the scene.

After the loop finishes (i.e., the window is closed), it waits for the Vulkan renderer to finish its work.

## `Destroy` procedure

Cleans up all engine resources, including:

-   The Vulkan renderer.
-   The application window.
-   The console logger.
