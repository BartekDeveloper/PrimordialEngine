# `types.odin` (in `maths`)

This file defines various type aliases for common mathematical structures, such as vectors, matrices, and quaternions, using types from the `core:math/linalg` package. It also defines identity constants for these types.

## Vector Type Aliases

This section defines aliases for 2D, 3D, and 4D vectors with different floating-point and integer precisions:

-   **Floating-point vectors:** `Vec2h`, `Vec2`, `Vec2d`, `Vec3h`, `Vec3`, `Vec3d`, `Vec4h`, `Vec4`, `Vec4d`.
-   **Signed integer vectors:** `iVec2h`, `iVec2`, `iVec2d`, `iVec3h`, `iVec3`, `iVec3d`, `iVec4h`, `iVec4`, `iVec4d`.
-   **Unsigned integer vectors:** `uVec2h`, `uVec2`, `uVec2d`, `uVec3h`, `uVec3`, `uVec3d`, `uVec4h`, `uVec4`, `uVec4d`.

## Matrix Type Aliases

This section defines aliases for 1x1, 2x2, 3x3, and 4x4 matrices with different floating-point precisions:

-   `Mat1h`, `Mat1`, `Mat1d`
-   `Mat2h`, `Mat2`, `Mat2d`
-   `Mat3h`, `Mat3`, `Mat3d`
-   `Mat4h`, `Mat4`, `Mat4d`

## Quaternion Type Aliases

This section defines aliases for quaternions with different floating-point precisions:

-   `Quath`, `Quat`, `Quatd`

## Identity Constants

This section defines identity constants for various matrix and quaternion types. These constants represent the identity transformation for their respective types:

-   `Mat1h_iDENTIFY`, `Mat1_IDENTITY`, `Mat1d_iDENTIFY`
-   `Mat2h_iDENTIFY`, `Mat2_IDENTITY`, `Mat2d_iDENTIFY`
-   `Mat3h_iDENTIFY`, `Mat3_IDENTITY`, `Mat3d_iDENTIFY`
-   `Mat4h_iDENTIFY`, `Mat4_IDENTITY`, `Mat4d_iDENTIFY`
-   `Quath_iDENTIFY`, `Quat_IDENTITY`, `Quatd_iDENTIFY`

## Axis Constants

This section defines constants for the X, Y, and Z axes for 2D vectors with different floating-point precisions:

-   `Vec2h_X_AXiS`, `Vec2_X_AXiS`, `Vec2d_X_AXiS`
-   `Vec2h_Y_AXiS`, `Vec2_Y_AXiS`, `Vec2d_Y_AXiS`
-   `Vec2h_Z_AXiS`, `Vec2_Z_AXiS`, `Vec2d_Z_AXiS`
