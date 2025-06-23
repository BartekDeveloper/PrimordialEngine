package engine_math

import "core:c"

foreign import triangle_functions "triangle_functions.o"
foreign triangle_functions {
    @(require_results) Cos         :: proc "c" (x: f32) -> f32 ---
    @(require_results) CosD        :: proc "c" (x: f64) -> f64 ---
    @(require_results) CosI        :: proc "c" (x: i32) -> i32 ---
    @(require_results) CosD_Approx :: proc "c" (x: f64) -> f64 ---
    @(require_results) CosI_Approx :: proc "c" (x: f32) -> i32 ---

    @(require_results) Sin         :: proc "c" (x: f32) -> f32 ---
    @(require_results) SinD        :: proc "c" (x: f64) -> f64 ---
    @(require_results) SinI        :: proc "c" (x: i32) -> i32 ---
    @(require_results) SinD_Approx :: proc "c" (x: f64) -> f64 ---
    @(require_results) SinI_Approx :: proc "c" (x: f32) -> i32 ---

    @(require_results) Tan         :: proc "c" (x: f32) -> f32 ---
    @(require_results) TanD        :: proc "c" (x: f64) -> f64 ---
    @(require_results) TanI        :: proc "c" (x: f32) -> i32 ---
    @(require_results) TanD_Approx :: proc "c" (x: f64) -> f64 ---
    @(require_results) TanI_Approx :: proc "c" (x: f32) -> i32 ---

    PI: f64
}
