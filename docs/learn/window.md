# `window.odin`

This file handles the creation and management of the application window using the SDL3 library.

## `WindowData` struct

This struct holds all the data related to the window, such as its dimensions, title, and a pointer to the underlying `sdl.Window` object.

## `Init` procedure

Initializes SDL3 and creates the application window.

## `Running` procedure

Returns `true` if the window is still open, and `false` otherwise.

## `Poll` procedure

Polls for window events, such as the user clicking the close button. If a close event is detected, it sets the `closing` flag in the `WindowData` struct to `true`.

## `Clean` procedure

Destroys the window and quits SDL3.

## Helper Functions

-   `GetInstanceExtensions`: Returns the Vulkan instance extensions required by SDL3.
-   `GetFrameBufferSize`: Returns the width and height of the window's framebuffer in pixels.
