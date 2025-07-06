# `normalize.odin` (in `maths`)

This file provides procedures for normalizing various data types, including scalars, vectors, and quaternions.

## `Length` alias

An alias to `linalg.length`, which is used to calculate the magnitude (length) of vectors and quaternions.

## `Normalize` procedure group

This procedure group provides normalization calculations for different data types and precisions:

### Scalar Normalization

-   **`Normalize_i32`**: Normalizes an `i32` value. (Returns 1).
-   **`Normalize_f32`**: Normalizes an `f32` value. (Returns 1.0).
-   **`Normalize_f64`**: Normalizes an `f64` value. (Returns 1.0).

### Vector Normalization

-   **`Normalize_vec2h`**: Normalizes a `Vec2h` (half-precision float 2D) vector.
-   **`Normalize_vec2`**: Normalizes a `Vec2` (single-precision float 2D) vector.
-   **`Normalize_vec2d`**: Normalizes a `Vec2d` (double-precision float 2D) vector.
-   **`Normalize_vec3h`**: Normalizes a `Vec3h` (half-precision float 3D) vector.
-   **`Normalize_vec3`**: Normalizes a `Vec3` (single-precision float 3D) vector.
-   **`Normalize_vec3d`**: Normalizes a `Vec3d` (double-precision float 3D) vector.
-   **`Normalize_vec4h`**: Normalizes a `Vec4h` (half-precision float 4D) vector.
-   **`Normalize_vec4`**: Normalizes a `Vec4` (single-precision float 4D) vector.
-   **`Normalize_vec4d`**: Normalizes a `Vec4d` (double-precision float 4D) vector.

### Quaternion Normalization

-   **`Normalize_quath`**: Normalizes a `Quath` (half-precision float) quaternion.
-   **`Normalize_quat`**: Normalizes a `Quat` (single-precision float) quaternion.
-   **`Normalize_quatd`**: Normalizes a `Quatd` (double-precision float) quaternion.

Normalization scales a vector or quaternion to have a magnitude of 1, preserving its direction. This is a common operation in graphics and physics for various calculations.
