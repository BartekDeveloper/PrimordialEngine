# `inverse.odin` (in `maths`)

This file provides procedures for calculating the inverse of matrices and quaternions.

## `Inverse` procedure group

This procedure group provides inverse calculations for different matrix and quaternion types:

### Matrix Inverses

-   **`Inverse_mat2h`**: Calculates the inverse of a `Mat2h` (half-precision float 2x2) matrix.
-   **`Inverse_mat2`**: Calculates the inverse of a `Mat2` (single-precision float 2x2) matrix.
-   **`Inverse_mat2d`**: Calculates the inverse of a `Mat2d` (double-precision float 2x2) matrix.
-   **`Inverse_mat3h`**: Calculates the inverse of a `Mat3h` (half-precision float 3x3) matrix.
-   **`Inverse_mat3`**: Calculates the inverse of a `Mat3` (single-precision float 3x3) matrix.
-   **`Inverse_mat3d`**: Calculates the inverse of a `Mat3d` (double-precision float 3x3) matrix.
-   **`Inverse_mat4h`**: Calculates the inverse of a `Mat4h` (half-precision float 4x4) matrix.
-   **`Inverse_mat4`**: Calculates the inverse of a `Mat4` (single-precision float 4x4) matrix.
-   **`Inverse_mat4d`**: Calculates the inverse of a `Mat4d` (double-precision float 4x4) matrix.

### Quaternion Inverses

-   **`Inverse_quath`**: Calculates the inverse of a `Quath` (half-precision float) quaternion.
-   **`Inverse_quat`**: Calculates the inverse of a `Quat` (single-precision float) quaternion.
-   **`Inverse_quatd`**: Calculates the inverse of a `Quatd` (double-precision float) quaternion.

**Note:** The provided quaternion inverse implementations (`1.0 / q`) are incorrect for general quaternions. The inverse of a quaternion `q` is typically `conjugate(q) / norm(q)^2`. For unit quaternions, the inverse is simply the conjugate.
