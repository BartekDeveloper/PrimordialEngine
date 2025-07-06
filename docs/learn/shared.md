# `shared.odin`

This file defines data structures that are shared across different parts of the engine, particularly between the core engine logic and the rendering backend.

## `RenderData` struct

This struct holds data related to the rendering process that needs to be accessible globally. Key fields include:

-   `deltaTime`: The time elapsed since the last frame, in nanoseconds (i64).
-   `deltaTime_f64`: The time elapsed since the last frame, in seconds (f64).
-   `currentFrame`: The index of the current frame being rendered.
-   `MAX_FRAMES_IN_FLIGHT`: The maximum number of frames that can be in flight simultaneously (i.e., being processed by the GPU).

## `UniformBufferObject` struct (aliased as `UBO`)

This struct defines the layout of the Uniform Buffer Object (UBO), which is a block of data passed to shaders. It contains various parameters that influence rendering, such as:

-   **Important:**
    -   `proj`: Projection matrix.
    -   `iProj`: Inverse projection matrix.
    -   `view`: View matrix.
    -   `iView`: Inverse view matrix.
    -   `deltaTime`: Time elapsed since the last frame (f32).
-   **Window:**
    -   `winWidth`: Window width.
    -   `winHeight`: Window height.
-   **Camera:**
    -   `cameraPos`: Camera position.
    -   `cameraUp`: Camera up vector.
-   **World:**
    -   `worldUp`: World up vector.
    -   `worldTime`: Current world time.
-   **Temporary:**
    -   `model`: Model matrix (likely for a single object, or a placeholder).

## `VertexData` struct (aliased as `Vertex`)

This struct defines the layout of vertex data, which describes the properties of each vertex in a 3D model. Key fields include:

-   `pos`: Position of the vertex (3D vector).
-   `norm`: Normal vector of the vertex (3D vector).
-   `tan`: Tangent vector of the vertex (3D vector).
-   `color`: Color of the vertex (3D vector).
-   `uv0`: Texture coordinates of the vertex (2D vector).
