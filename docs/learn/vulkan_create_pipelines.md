# `pipelines.odin` (in `vulkan/create`)

This file is responsible for creating and configuring the Vulkan graphics pipelines used in the renderer. It defines the various states of the graphics pipeline and orchestrates their creation.

## `Pipelines` procedure

This is the main procedure that creates all the graphics pipelines for the application. It sets up global viewports and scissors, and then proceeds to create the geometry and lighting pipelines.

### Geometry Pipeline Creation

This section configures and creates the geometry pass pipeline. It involves:

-   **Shaders:** Specifies the vertex and fragment shaders (`geometry.vert.spv`, `geometry.frag.spv`).
-   **Descriptor Set Layouts:** Binds the UBO descriptor set layout.
-   **Vertex Input:** Defines the vertex binding and attribute descriptions for the `s.Vertex` struct (position, normal, UV).
-   **Pipeline States:** Configures various pipeline states:
    -   `DefaultVertexInput`: How vertex data is interpreted.
    -   `DefaultInputAssembly`: How vertices are assembled into primitives (triangle list).
    -   `DefaultViewportState`: Defines the viewport and scissor rectangles.
    -   `DefaultRasterization`: Controls rasterization settings (e.g., polygon mode, cull mode, depth bias).
    -   `DefaultMultisample`: Configures multisampling.
    -   `DefaultDepthStencil`: Sets up depth and stencil testing.
    -   `DefaultColorBlending`: Defines color blending for the output attachments.
    -   `DefaultDynamicStates`: Specifies dynamic states (viewport and scissor).
-   **Pipeline Layout:** Creates the pipeline layout, which defines the descriptor set layouts and push constants used by the pipeline.
-   **Pipeline Cache:** Creates a pipeline cache for optimizing pipeline creation.
-   **Graphics Pipeline:** Creates the final graphics pipeline using `vk.CreateGraphicsPipelines`.

### Light Pipeline Creation

This section configures and creates the lighting pass pipeline. It follows a similar process to the geometry pipeline, but with specific configurations for the lighting pass:

-   **Shaders:** Specifies the vertex and fragment shaders (`light.vert.spv`, `light.frag.spv`).
-   **Descriptor Set Layouts:** Binds both the UBO and G-Buffer descriptor set layouts.
-   **Pipeline States:** Configures pipeline states, typically with simpler settings as it operates on a full-screen quad.
-   **Pipeline Layout:** Creates the pipeline layout for the lighting pass.
-   **Pipeline Cache:** Creates a pipeline cache for the lighting pass.
-   **Graphics Pipeline:** Creates the final lighting graphics pipeline.

## Helper Procedures

This file contains numerous helper procedures for configuring individual Vulkan pipeline states:

-   **`DefaultVertexInput`**: Creates a `vk.PipelineVertexInputStateCreateInfo` struct, defining how vertex data is consumed by the pipeline.
-   **`DefaultInputAssembly`**: Creates a `vk.PipelineInputAssemblyStateCreateInfo` struct, defining how vertices are assembled into primitives.
-   **`DefaultViewportState`**: Creates a `vk.PipelineViewportStateCreateInfo` struct, defining the viewports and scissor rectangles.
-   **`DefaultRasterization`**: Creates a `vk.PipelineRasterizationStateCreateInfo` struct, defining rasterization parameters.
-   **`DefaultMultisample`**: Creates a `vk.PipelineMultisampleStateCreateInfo` struct, defining multisampling parameters.
-   **`DefaultDepthStencil`**: Creates a `vk.PipelineDepthStencilStateCreateInfo` struct, defining depth and stencil testing parameters.
-   **`DefaultBlendAttachment`**: Creates a `vk.PipelineColorBlendAttachmentState` struct, defining color blending for a single attachment.
-   **`DefaultFillColorBlendAttachments`**: Creates a slice of `vk.PipelineColorBlendAttachmentState` structs, typically used to initialize multiple color attachments with default blending.
-   **`DefaultColorBlending`**: Creates a `vk.PipelineColorBlendStateCreateInfo` struct, defining overall color blending parameters.
-   **`DefaultCreateDynamicStates`**: Creates a `vk.PipelineDynamicStateCreateInfo` struct, specifying which pipeline states can be changed dynamically without recreating the pipeline.
-   **`DefaultDynamicStates`**: A specialized version of `DefaultCreateDynamicStates` that sets up viewport and scissor as dynamic states.
-   **`DefaultPipelineLayoutCreateInfo`**: Creates a `vk.PipelineLayoutCreateInfo` struct, defining the layout of descriptor sets and push constants.
-   **`DefaultPipelineCacheInfo`**: Creates a `vk.PipelineCacheCreateInfo` struct, used for creating pipeline caches.
-   **`DefaultPipelineEmptyCacheCreateInfo`**: A specialized version of `DefaultPipelineCacheInfo` for creating an empty pipeline cache.
-   **`CleanPipelineVertexData`**: Cleans up memory allocated for `PipelineVertexData`.
-   **`AddBinding` (procedure group)**: Provides multiple ways to add vertex binding descriptions to `PipelineVertexData`.
-   **`AddAttribute` (procedure group)**: Provides multiple ways to add vertex attribute descriptions to `PipelineVertexData`.
-   **`SetLayouts`**: A helper to create a slice of `vk.DescriptorSetLayout` from variadic arguments.
-   **`PipelineLayout`**: Creates a `vk.PipelineLayout` object.
-   **`PipelineCache`**: Creates a `vk.PipelineCache` object.
-   **`GraphicsPipeline`**: Creates a `vk.Pipeline` object for graphics pipelines.

## Custom Types

-   **`PipelineVertexData`**: A struct to hold dynamic arrays of vertex binding and attribute descriptions.
-   **`ChainedBindings`**: A linked list structure for vertex binding descriptions.
-   **`ChainedAttributes`**: A linked list structure for vertex attribute descriptions.
-   **`GraphicsInfoStates`**: A struct that holds pointers to various `vk.Pipeline*StateCreateInfo` structs, used for organizing pipeline state creation.
-   **`GraphicsPipelineData`**: A struct used to pass pipeline creation information to the `GraphicsPipeline` procedure.
