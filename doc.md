# package engine

Core engine components, handling initialization, startup, and shutdown.

## Package Details
**Full Path:** `/home/zota/projects/multi/vk_new/src/engine`
**Files:** `engine.odin`, `types.odin`

## Variables
- `renderData: s.RenderData` - Data structure for storing rendering state and timing information (uses type from `engine_shared`).

## Procedures
- `Destroy :: proc() {...}` - Shuts down and cleans up engine resources.
- `Init :: proc() {...}` - Initializes the engine and its sub-components.
- `Start :: proc() {...}` - Begins the main execution loop or primary operation of the engine.

---

# package engine_math

Mathematical types and functions, primarily based on the `linalg` library, for use within the engine.

## Package Details
**Full Path:** `/home/zota/projects/multi/vk_new/src/maths`
**Files:** `clib.odin`, `cross.odin`, `dot.odin`, `inverse.odin`, `linalg.odin`, `math.odin`, `normalize.odin`, `types.odin`

## Constants
- `Mat1_IDENTITY :: linalg.MATRIX1F32_IDENTITY` - The 1x1 float32 identity matrix.
- `Mat1d_iDENTIFY :: linalg.MATRIX1F64_IDENTITY` - The 1x1 float64 identity matrix.
- `Mat1h_iDENTIFY :: linalg.MATRIX1F16_IDENTITY` - The 1x1 float16 identity matrix.
- `Mat2_IDENTITY :: linalg.MATRIX2F32_IDENTITY` - The 2x2 float32 identity matrix.
- `Mat2d_iDENTIFY :: linalg.MATRIX2F64_IDENTITY` - The 2x2 float64 identity matrix.
- `Mat2h_iDENTIFY :: linalg.MATRIX2F16_IDENTITY` - The 2x2 float16 identity matrix.
- `Mat3_IDENTITY :: linalg.MATRIX3F32_IDENTITY` - The 3x3 float32 identity matrix.
- `Mat3d_iDENTIFY :: linalg.MATRIX3F64_IDENTITY` - The 3x3 float64 identity matrix.
- `Mat3h_iDENTIFY :: linalg.MATRIX3F16_IDENTITY` - The 3x3 float16 identity matrix.
- `Mat4_IDENTITY :: linalg.MATRIX4F32_IDENTITY` - The 4x4 float32 identity matrix.
- `Mat4d_iDENTIFY :: linalg.MATRIX4F64_IDENTITY` - The 4x4 float64 identity matrix.
- `Mat4h_iDENTIFY :: linalg.MATRIX4F16_IDENTITY` - The 4x4 float16 identity matrix.
- `Quat_IDENTITY :: linalg.QUATERNIONF32_IDENTITY` - The float32 identity quaternion.
- `Quatd_iDENTIFY :: linalg.QUATERNIONF64_IDENTITY` - The float64 identity quaternion.
- `Quath_iDENTIFY :: linalg.QUATERNIONF16_IDENTITY` - The float16 identity quaternion.
- `Vec2_X_AXiS :: linalg.VECTOR3F32_X_AXIS` - The X-axis vector for float32 (Note: Still shows `VECTOR3F32` in input).
- `Vec2_Y_AXiS :: linalg.VECTOR3F32_Y_AXIS` - The Y-axis vector for float32 (Note: Still shows `VECTOR3F32` in input).
- `Vec2_Z_AXiS :: linalg.VECTOR3F32_Z_AXIS` - The Z-axis vector for float32 (Note: Still shows `VECTOR3F32` in input).
- `Vec2d_X_AXiS :: linalg.VECTOR3F64_X_AXIS` - The X-axis vector for float64 (Note: Still shows `VECTOR3F64` in input).
- `Vec2d_Y_AXiS :: linalg.VECTOR3F64_Y_AXIS` - The Y-axis vector for float64 (Note: Still shows `VECTOR3F64` in input).
- `Vec2d_Z_AXiS :: linalg.VECTOR3F64_Z_AXIS` - The Z-axis vector for float64 (Note: Still shows `VECTOR3F64` in input).
- `Vec2h_X_AXiS :: linalg.VECTOR3F16_X_AXIS` - The X-axis vector for float16 (Note: Still shows `VECTOR3F16` in input).
- `Vec2h_Y_AXiS :: linalg.VECTOR3F16_Y_AXIS` - The Y-axis vector for float16 (Note: Still shows `VECTOR3F16` in input).
- `Vec2h_Z_AXiS :: linalg.VECTOR3F16_Z_AXIS` - The Z-axis vector for float16 (Note: Still shows `VECTOR3F16` in input).

## Variables
- `PI: f64` - The mathematical constant Pi (double precision).

## Procedures
- `Cos :: proc(x: f32) -> f32 ---` - Computes the cosine of a float32 value.
- `CosD :: proc(x: f64) -> f64 ---` - Computes the cosine of a float64 value.
- `CosD_Approx :: proc(x: f64) -> f64 ---` - Computes an approximate cosine of a float64 value.
- `CosI :: proc(x: i32) -> i32 ---` - Computes the cosine of an integer value (likely returning an integer approximation or scaled value).
- `CosI_Approx :: proc(x: f32) -> i32 ---` - Computes an approximate cosine of a float32 value, returning an integer.
- `Cross_vec3 :: proc(a, b: Vec3) -> (o: Vec3) {...}` - Computes the cross product of two float32 3D vectors.
- `Cross_vec3d :: proc(a, b: Vec3d) -> (o: Vec3d) {...}` - Computes the cross product of two float64 3D vectors.
- `Cross_vec3h :: proc(a, b: Vec3h) -> (o: Vec3h) {...}` - Computes the cross product of two float16 3D vectors.
- `Dot_f32 :: proc(a, b: f32) -> (o: f32) {...}` - Computes the dot product of two float32 scalar values (simple multiplication).
- `Dot_f64 :: proc(a, b: f64) -> (o: f64) {...}` - Computes the dot product of two float64 scalar values (simple multiplication).
- `Dot_i32 :: proc(a, b: i32) -> (o: i32) {...}` - Computes the dot product of two integer scalar values (simple multiplication).
- `Dot_quat :: proc(a, b: Quat) -> (o: f32) {...}` - Computes the dot product of two float32 quaternions.
- `Dot_quatd :: proc(a, b: Quatd) -> (o: f64) {...}` - Computes the dot product of two float64 quaternions.
- `Dot_quath :: proc(a, b: Quath) -> (o: f16) {...}` - Computes the dot product of two float16 quaternions.
- `Dot_vec2 :: proc(a, b: Vec2) -> (o: f32) {...}` - Computes the dot product of two float32 2D vectors.
- `Dot_vec2d :: proc(a, b: Vec2d) -> (o: f64) {...}` - Computes the dot product of two float64 2D vectors.
- `Dot_vec2h :: proc(a, b: Vec2h) -> (o: f16) {...}` - Computes the dot product of two float16 2D vectors.
- `Dot_vec3 :: proc(a, b: Vec3) -> (o: f32) {...}` - Computes the dot product of two float32 3D vectors.
- `Dot_vec3d :: proc(a, b: Vec3d) -> (o: f64) {...}` - Computes the dot product of two float64 3D vectors.
- `Dot_vec3h :: proc(a, b: Vec3h) -> (o: f16) {...}` - Computes the dot product of two float16 3D vectors.
- `Dot_vec4 :: proc(a, b: Vec4) -> (o: f32) {...}` - Computes the dot product of two float32 4D vectors.
- `Dot_vec4d :: proc(a, b: Vec4d) -> (o: f64) {...}` - Computes the dot product of two float64 4D vectors.
- `Dot_vec4h :: proc(a, b: Vec4h) -> (o: f16) {...}` - Computes the dot product of two float16 4D vectors.
- `Inverse_mat2 :: proc(m: Mat2) -> (o: Mat2) {...}` - Computes the inverse of a float32 2x2 matrix.
- `Inverse_mat2d :: proc(m: Mat2d) -> (o: Mat2d) {...}` - Computes the inverse of a float64 2x2 matrix.
- `Inverse_mat2h :: proc(m: Mat2h) -> (o: Mat2h) {...}` - Computes the inverse of a float16 2x2 matrix.
- `Inverse_mat3 :: proc(m: Mat3) -> (o: Mat3) {...}` - Computes the inverse of a float32 3x3 matrix.
- `Inverse_mat3d :: proc(m: Mat3d) -> (o: Mat3d) {...}` - Computes the inverse of a float64 3x3 matrix.
- `Inverse_mat3h :: proc(m: Mat3h) -> (o: Mat3h) {...}` - Computes the inverse of a float16 3x3 matrix.
- `Inverse_mat4 :: proc(m: Mat4) -> (o: Mat4) {...}` - Computes the inverse of a float32 4x4 matrix.
- `Inverse_mat4d :: proc(m: Mat4d) -> (o: Mat4d) {...}` - Computes the inverse of a float64 4x4 matrix.
- `Inverse_mat4h :: proc(m: Mat4h) -> (o: Mat4h) {...}` - Computes the inverse of a float16 4x4 matrix.
- `Inverse_quat :: proc(q: Quat) -> (o: Quat) {...}` - Computes the inverse of a float32 quaternion.
- `Inverse_quatd :: proc(q: Quatd) -> (o: Quatd) {...}` - Computes the inverse of a float64 quaternion.
- `Inverse_quath :: proc(q: Quath) -> (o: Quath) {...}` - Computes the inverse of a float16 quaternion.
- `LookAt :: proc(eye: Vec3, center: Vec3, up: Vec3) -> (o: Mat4 = {}) {...}` - Creates a float32 view matrix looking from `eye` towards `center` with `up` as the up direction.
- `Normalize_f32 :: proc(i: f32) -> (o: f32) {...}` - Normalizes a float32 value (division by itself if non-zero).
- `Normalize_f64 :: proc(i: f64) -> (o: f64) {...}` - Normalizes a float64 value.
- `Normalize_i32 :: proc(i: i32) -> (o: i32) {...}` - Normalizes an i32 value (likely sets it to 1 if non-zero, 0 if zero).
- `Normalize_quat :: proc(i: Quat) -> (o: Quat) {...}` - Normalizes a float32 quaternion.
- `Normalize_quatd :: proc(i: Quatd) -> (o: Quatd) {...}` - Normalizes a float64 quaternion.
- `Normalize_quath :: proc(i: Quath) -> (o: Quath) {...}` - Normalizes a float16 quaternion.
- `Normalize_vec2 :: proc(i: Vec2) -> (o: Vec2) {...}` - Normalizes a float32 2D vector to unit length.
- `Normalize_vec2d :: proc(i: Vec2d) -> (o: Vec2d) {...}` - Normalizes a float64 2D vector to unit length.
- `Normalize_vec2h :: proc(i: Vec2h) -> (o: Vec2h) {...}` - Normalizes a float16 2D vector to unit length.
- `Normalize_vec3 :: proc(i: Vec3) -> (o: Vec3) {...}` - Normalizes a float32 3D vector to unit length.
- `Normalize_vec3d :: proc(i: Vec3d) -> (o: Vec3d) {...}` - Normalizes a float64 3D vector to unit length.
- `Normalize_vec3h :: proc(i: Vec3h) -> (o: Vec3h) {...}` - Normalizes a float16 3D vector to unit length.
- `Normalize_vec4 :: proc(i: Vec4) -> (o: Vec4) {...}` - Normalizes a float32 4D vector to unit length.
- `Normalize_vec4d :: proc(i: Vec4d) -> (o: Vec4d) {...}` - Normalizes a float64 4D vector to unit length.
- `Normalize_vec4h :: proc(i: Vec4h) -> (o: Vec4h) {...}` - Normalizes a float16 4D vector to unit length.
- `Orthographic :: proc(top: f32, right: f32, bottom: f32, left: f32, near: f32, far: f32) -> (o: Mat4 = {}) {...}` - Creates a float32 orthographic projection matrix.
- `Perspective :: proc(fovy: f32, aspect: f32, near: f32, far: f32) -> (o: Mat4 = {}) {...}` - Creates a float32 perspective projection matrix.
- `Perspective_InfDistance :: proc(fovy: f32, aspect: f32, near: f32) -> (o: Mat4 = {}) {...}` - Creates a float32 perspective projection matrix optimized for infinite far distance.
- `Sin :: proc(x: f32) -> f32 ---` - Computes the sine of a float32 value.
- `SinD :: proc(x: f64) -> f64 ---` - Computes the sine of a float64 value.
- `SinD_Approx :: proc(x: f64) -> f64 ---` - Computes an approximate sine of a float64 value.
- `SinI :: proc(x: i32) -> i32 ---` - Computes the sine of an integer value (likely returning an integer approximation or scaled value).
- `SinI_Approx :: proc(x: f32) -> i32 ---` - Computes an approximate sine of a float32 value, returning an integer.
- `Tan :: proc(x: f32) -> f32 ---` - Computes the tangent of a float32 value.
- `TanD :: proc(x: f64) -> f64 ---` - Computes the tangent of a float64 value.
- `TanD_Approx :: proc(x: f64) -> f64 ---` - Computes an approximate tangent of a float64 value.
- `TanI :: proc(x: f32) -> i32 ---` - Computes the tangent of a float32 value, returning an integer.
- `TanI_Approx :: proc(x: f32) -> i32 ---` - Computes an approximate tangent of a float32 value, returning an integer.

## Procedure Groups
- `Cross :: proc{Cross_vec3h, Cross_vec3, Cross_vec3d}` - Overloaded procedure group for cross product operations.
- `Dot :: proc{Dot_i32, Dot_f32, Dot_f64, Dot_vec2h, Dot_vec2, Dot_vec2d, Dot_vec3h, Dot_vec3, Dot_vec3d, Dot_vec4h, Dot_vec4, Dot_vec4d, Dot_quath, Dot_quat, Dot_quatd}` - Overloaded procedure group for dot product operations across various scalar and vector/quaternion types.
- `Inverse :: proc{Inverse_mat2h, Inverse_mat2, Inverse_mat2d, Inverse_mat3h, Inverse_mat3, Inverse_mat3d, Inverse_mat4h, Inverse_mat4, Inverse_mat4d, Inverse_quath, Inverse_quat, Inverse_quatd}` - Overloaded procedure group for matrix and quaternion inversion.
- `Length :: linalg.length` - Alias or wrapper for the linalg package's length function.
- `Normalize :: proc{Normalize_i32, Normalize_f32, Normalize_f64, Normalize_vec2h, Normalize_vec2, Normalize_vec2d, Normalize_vec3h, Normalize_vec3, Normalize_vec3d, Normalize_vec4h, Normalize_vec4, Normalize_vec4d, Normalize_quath, Normalize_quat, Normalize_quatd}` - Overloaded procedure group for normalizing various types (scalars, vectors, quaternions).

## Types
- `Mat1 :: linalg.Matrix1f32` - Alias for a 1x1 float32 matrix.
- `Mat1d :: linalg.Matrix1f32` - Alias for a 1x1 float64 matrix. (Note: Still shows `linalg.Matrix1f32` in input, likely intended as `linalg.Matrix1f64`)
- `Mat1h :: linalg.Matrix1f16` - Alias for a 1x1 float16 matrix.
- `Mat2 :: linalg.Matrix2f32` - Alias for a 2x2 float32 matrix.
- `Mat2d :: linalg.Matrix2f64` - Alias for a 2x2 float64 matrix.
- `Mat2h :: linalg.Matrix2f16` - Alias for a 2x2 float16 matrix.
- `Mat3 :: linalg.Matrix3f32` - Alias for a 3x3 float32 matrix.
- `Mat3d :: linalg.Matrix3f64` - Alias for a 3x3 float64 matrix.
- `Mat3h :: linalg.Matrix3f16` - Alias for a 3x3 float16 matrix.
- `Mat4 :: linalg.Matrix4f32` - Alias for a 4x4 float32 matrix.
- `Mat4d :: linalg.Matrix4f64` - Alias for a 4x4 float64 matrix.
- `Mat4h :: linalg.Matrix4f16` - Alias for a 4x4 float16 matrix.
- `Quat :: linalg.Quaternionf32` - Alias for a float32 quaternion.
- `Quatd :: linalg.Quaternionf64` - Alias for a float64 quaternion.
- `Quath :: linalg.Quaternionf16` - Alias for a float16 quaternion.
- `Vec2 :: linalg.Vector2f32` - Alias for a float32 2D vector.
- `Vec2d :: linalg.Vector2f64` - Alias for a float64 2D vector.
- `Vec2h :: linalg.Vector2f16` - Alias for a float16 2D vector.
- `Vec3 :: linalg.Vector3f32` - Alias for a float32 3D vector.
- `Vec3d :: linalg.Vector3f64` - Alias for a float64 3D vector.
- `Vec3h :: linalg.Vector3f16` - Alias for a float16 3D vector.
- `Vec4 :: linalg.Vector4f32` - Alias for a float32 4D vector.
- `Vec4d :: linalg.Vector4f64` - Alias for a float64 4D vector.
- `Vec4h :: linalg.Vector4f16` - Alias for a float16 4D vector.
- `iVec2 :: [2]i32` - A 2-element array of 32-bit integers (integer 2D vector).
- `iVec2d :: [2]i64` - A 2-element array of 64-bit integers (integer 2D vector).
- `iVec2h :: [2]i16` - A 2-element array of 16-bit integers (integer 2D vector).
- `iVec3 :: [3]i32` - A 3-element array of 32-bit integers (integer 3D vector).
- `iVec3d :: [3]i64` - A 3-element array of 64-bit integers (integer 3D vector).
- `iVec3h :: [3]i16` - A 3-element array of 16-bit integers (integer 3D vector).
- `iVec4 :: [4]i32` - A 4-element array of 32-bit integers (integer 4D vector).
- `iVec4d :: [4]i64` - A 4-element array of 64-bit integers (integer 4D vector).
- `iVec4h :: [4]i16` - A 4-element array of 16-bit integers (integer 4D vector).
- `uVec2 :: [2]u32` - A 2-element array of 32-bit unsigned integers (unsigned integer 2D vector).
- `uVec2d :: [2]u64` - A 2-element array of 64-bit unsigned integers (unsigned integer 2D vector).
- `uVec2h :: [2]u16` - A 2-element array of 16-bit unsigned integers (unsigned integer 2D vector).
- `uVec3 :: [3]u32` - A 3-element array of 32-bit unsigned integers (unsigned integer 3D vector).
- `uVec3d :: [3]u64` - A 3-element array of 64-bit unsigned integers (unsigned integer 3D vector).
- `uVec3h :: [3]u16` - A 3-element array of 16-bit unsigned integers (unsigned integer 3D vector).
- `uVec4 :: [4]u32` - A 4-element array of 32-bit unsigned integers (unsigned integer 4D vector).
- `uVec4d :: [4]u64` - A 4-element array of 64-bit unsigned integers (unsigned integer 4D vector).
- `uVec4h :: [4]u16` - A 4-element array of 16-bit unsigned integers (unsigned integer 4D vector).

---

# package engine_shared

Common data structures and types used across different engine modules, particularly for rendering and global state.

## Package Details

**Full Path:** `/home/zota/projects/multi/vk_new/src/shared`
**Files:** `shared.odin`

## Types
- `RenderData :: #type struct {deltaTime: i64, deltaTime_f64: f64, currentFrame: int, MAX_FRAMES_IN_FLIGHT: int}` - Data structure holding timing and frame information for rendering.
- `UBO :: #type UniformBufferObject` - Alias for the `UniformBufferObject` type, typically used for data passed to shaders.
- `UniformBufferObject :: #type struct {proj: emath.Mat4, iProj: emath.Mat4, view: emath.Mat4, iView: emath.Mat4, deltaTime: f32, winWidth: f32, winHeight: f32, cameraPos: emath.Vec3, cameraUp: emath.Vec3, worldUp: emath.Vec3, worldTime: int}` - Data structure defining the contents of a uniform buffer, including matrices, time, resolution, and camera info.
- `Vertex :: #type VertexData` - Alias for the `VertexData` type, representing a single vertex in a mesh.
- `VertexData :: #type struct {pos: emath.Vec3, norm: emath.Vec3, tan: emath.Vec3, color: emath.Vec3, uv0: emath.Vec2}` - Data structure defining the attributes of a vertex (position, normal, tangent, color, texture coordinates).

---

# package main

The entry point of the application.

## Package Details
**Full Path:** `/home/zota/projects/multi/vk_new`
**Files:** `main.odin`

## Procedures
- `main :: proc() {...}` - The primary function where the program execution begins.

---