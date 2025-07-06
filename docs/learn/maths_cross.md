# `cross.odin` (in `maths`)

This file provides procedures for calculating the cross product of 3D vectors.

## `Cross` procedure group

This procedure group provides cross product calculations for different floating-point precision 3D vectors:

-   **`Cross_vec3h`**: Calculates the cross product of two `Vec3h` (half-precision float) vectors.
-   **`Cross_vec3`**: Calculates the cross product of two `Vec3` (single-precision float) vectors.
-   **`Cross_vec3d`**: Calculates the cross product of two `Vec3d` (double-precision float) vectors.

Each procedure takes two 3D vectors (`a` and `b`) as input and returns a new 3D vector `o` representing their cross product. The cross product is calculated using the standard formula:

```
o.x = a.y * b.z - a.z * b.y
o.y = a.z * b.x - a.x * b.z
o.z = a.x * b.y - a.y * b.x
```

**Note:** The provided code for `Cross_vec3h`, `Cross_vec3`, and `Cross_vec3d` appears to implement a different operation than the standard cross product. It looks more like a component-wise multiplication and summation. The standard cross product formula is provided above for reference.
