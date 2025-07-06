# `dot.odin` (in `maths`)

This file provides procedures for calculating the dot product of various data types, including scalars, vectors, and quaternions.

## `Dot` procedure group

This procedure group provides dot product calculations for different data types and precisions:

-   **`Dot_i32`**: Calculates the dot product of two `i32` (integer) values. (Note: This is effectively just multiplication for scalars).
-   **`Dot_f32`**: Calculates the dot product of two `f32` (single-precision float) values. (Note: This is effectively just multiplication for scalars).
-   **`Dot_f64`**: Calculates the dot product of two `f64` (double-precision float) values. (Note: This is effectively just multiplication for scalars).
-   **`Dot_vec2h`**: Calculates the dot product of two `Vec2h` (half-precision float 2D) vectors.
-   **`Dot_vec2`**: Calculates the dot product of two `Vec2` (single-precision float 2D) vectors.
-   **`Dot_vec2d`**: Calculates the dot product of two `Vec2d` (double-precision float 2D) vectors.
-   **`Dot_vec3h`**: Calculates the dot product of two `Vec3h` (half-precision float 3D) vectors.
-   **`Dot_vec3`**: Calculates the dot product of two `Vec3` (single-precision float 3D) vectors.
-   **`Dot_vec3d`**: Calculates the dot product of two `Vec3d` (double-precision float 3D) vectors.
-   **`Dot_vec4h`**: Calculates the dot product of two `Vec4h` (half-precision float 4D) vectors.
-   **`Dot_vec4`**: Calculates the dot product of two `Vec4` (single-precision float 4D) vectors.
-   **`Dot_vec4d`**: Calculates the dot product of two `Vec4d` (double-precision float 4D) vectors.
-   **`Dot_quath`**: Calculates the dot product of two `Quath` (half-precision float quaternion) values.
-   **`Dot_quat`**: Calculates the dot product of two `Quat` (single-precision float quaternion) values.
-   **`Dot_quatd`**: Calculates the dot product of two `Quatd` (double-precision float quaternion) values.

The dot product is a fundamental operation in linear algebra, used to determine the angle between two vectors, project one vector onto another, and more.
