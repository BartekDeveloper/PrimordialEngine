package engine_math
import "core:os"
import "core:c"

foreign import triangle_functions "triangle_functions.o"
foreign triangle_functions {
    Cos         :: proc "c" (x: f32) -> f32 ---
    CosD        :: proc "c" (x: f64) -> f64 ---
    CosI        :: proc "c" (x: i32) -> i32 ---
    CosD_Approx :: proc "c" (x: f64) -> f64 ---
    CosI_Approx :: proc "c" (x: f32) -> i32 ---

    Sin         :: proc "c" (x: f32) -> f32 ---
    SinD        :: proc "c" (x: f64) -> f64 ---
    SinI        :: proc "c" (x: i32) -> i32 ---
    SinD_Approx :: proc "c" (x: f64) -> f64 ---
    SinI_Approx :: proc "c" (x: f32) -> i32 ---

    Tan         :: proc "c" (x: f32) -> f32 ---
    TanD        :: proc "c" (x: f64) -> f64 ---
    TanI        :: proc "c" (x: f32) -> i32 ---
    TanD_Approx :: proc "c" (x: f64) -> f64 ---
    TanI_Approx :: proc "c" (x: f32) -> i32 ---

    PI: f64
}
