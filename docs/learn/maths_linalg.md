# `linalg.odin` (in `maths`)

This file provides common linear algebra operations, specifically for creating projection and view matrices.

## `Perspective` procedure

This procedure creates a perspective projection matrix. It takes the field of view in the Y direction (`fovy`), the aspect ratio (`aspect`), and the near and far clipping planes (`near`, `far`) as input. It uses the `Tan` function (presumably from `clib.odin`) to calculate the tangent of half the field of view.

## `Perspective_InfDistance` procedure

This procedure creates a perspective projection matrix with an infinite far clipping plane. It takes the field of view in the Y direction (`fovy`), the aspect ratio (`aspect`), and the near clipping plane (`near`) as input. This is useful for scenarios where objects can be infinitely far away.

## `Orthographic` procedure

This procedure creates an orthographic projection matrix. It takes the bounds of the viewing volume (top, right, bottom, left, near, far) as input. Orthographic projection is typically used for 2D rendering or for specific 3D views where perspective distortion is not desired.

## `LookAt` procedure

This procedure creates a view matrix, which transforms world-space coordinates into camera-space coordinates. It takes the camera's position (`eye`), the point the camera is looking at (`center`), and the camera's up direction (`up`) as input. It calculates the forward, right, and up vectors of the camera's local coordinate system and constructs the view matrix from them.
