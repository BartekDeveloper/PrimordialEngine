# `clib.odin` (in `maths`)

This file defines foreign function interfaces (FFI) to a C library named `triangle_functions.o`, which provides various trigonometric functions.

## Foreign Imports

This file imports the `triangle_functions.o` library, exposing the following C functions as Odin procedures:

### Cosine Functions

-   `Cos`: Calculates the cosine of a `f32` value.
-   `CosD`: Calculates the cosine of a `f64` value.
-   `CosI`: Calculates the cosine of an `i32` value.
-   `CosD_Approx`: Calculates an approximate cosine of a `f64` value.
-   `CosI_Approx`: Calculates an approximate cosine of a `f32` value, returning an `i32`.

### Sine Functions

-   `Sin`: Calculates the sine of a `f32` value.
-   `SinD`: Calculates the sine of a `f64` value.
-   `SinI`: Calculates the sine of an `i32` value.
-   `SinD_Approx`: Calculates an approximate sine of a `f64` value.
-   `SinI_Approx`: Calculates an approximate sine of a `f32` value, returning an `i32`.

### Tangent Functions

-   `Tan`: Calculates the tangent of a `f32` value.
-   `TanD`: Calculates the tangent of a `f64` value.
-   `TanI`: Calculates the tangent of a `f32` value, returning an `i32`.
-   `TanD_Approx`: Calculates an approximate tangent of a `f64` value.
-   `TanI_Approx`: Calculates an approximate tangent of a `f32` value, returning an `i32`.

## Global Variable

-   `PI`: A `f64` constant representing the mathematical constant Pi, imported from the C library.
