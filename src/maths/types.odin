package engine_math

import "core:math"
import "core:math/big"
import "core:math/bits"
import "core:math/cmplx"
import "core:math/ease"
import "core:math/fixed"
import "core:math/linalg"
import "core:math/linalg/glsl"
import "core:math/linalg/hlsl"
import "core:math/noise"
import "core:math/rand"

Vec2h :: linalg.Vector2f16
Vec2  :: linalg.Vector2f32
Vec2d :: linalg.Vector2f64

Vec3h :: linalg.Vector3f16
Vec3  :: linalg.Vector3f32
Vec3d :: linalg.Vector3f64

Vec4h :: linalg.Vector4f16
Vec4  :: linalg.Vector4f32
Vec4d :: linalg.Vector4f64

iVec2h :: [2]i16
iVec2  :: [2]i32
iVec2d :: [2]i64

iVec3h :: [3]i16
iVec3  :: [3]i32
iVec3d :: [3]i64

iVec4h :: [4]i16
iVec4  :: [4]i32
iVec4d :: [4]i64

uVec2h :: [2]u16
uVec2  :: [2]u32
uVec2d :: [2]u64

uVec3h :: [3]u16
uVec3  :: [3]u32
uVec3d :: [3]u64

uVec4h :: [4]u16
uVec4  :: [4]u32
uVec4d :: [4]u64

Mat1h :: linalg.Matrix1f16
Mat1  :: linalg.Matrix1f32
Mat1d :: linalg.Matrix1f32

Mat2h :: linalg.Matrix2f16
Mat2  :: linalg.Matrix2f32
Mat2d :: linalg.Matrix2f64

Mat3h :: linalg.Matrix3f16
Mat3  :: linalg.Matrix3f32
Mat3d :: linalg.Matrix3f64

Mat4h :: linalg.Matrix4f16
Mat4  :: linalg.Matrix4f32
Mat4d :: linalg.Matrix4f64

Quath :: linalg.Quaternionf16
Quat  :: linalg.Quaternionf32
Quatd :: linalg.Quaternionf64

Mat1h_iDENTiFY :: linalg.MATRIX1F16_IDENTITY
Mat1_IDENTITY  :: linalg.MATRIX1F32_IDENTITY
Mat1d_iDENTiFY :: linalg.MATRIX1F64_IDENTITY

Mat2h_iDENTiFY :: linalg.MATRIX2F16_IDENTITY
Mat2_IDENTITY  :: linalg.MATRIX2F32_IDENTITY
Mat2d_iDENTiFY :: linalg.MATRIX2F64_IDENTITY

Mat3h_iDENTiFY :: linalg.MATRIX3F16_IDENTITY
Mat3_IDENTITY  :: linalg.MATRIX3F32_IDENTITY
Mat3d_iDENTiFY :: linalg.MATRIX3F64_IDENTITY

Mat4h_iDENTiFY :: linalg.MATRIX4F16_IDENTITY
Mat4_IDENTITY  :: linalg.MATRIX4F32_IDENTITY
Mat4d_iDENTiFY :: linalg.MATRIX4F64_IDENTITY

Quath_iDENTiFY :: linalg.QUATERNIONF16_IDENTITY
Quat_IDENTITY  :: linalg.QUATERNIONF32_IDENTITY
Quatd_iDENTiFY :: linalg.QUATERNIONF64_IDENTITY

Vec2h_X_AXiS :: linalg.VECTOR3F16_X_AXIS
Vec2_X_AXiS  :: linalg.VECTOR3F32_X_AXIS
Vec2d_X_AXiS :: linalg.VECTOR3F64_X_AXIS

Vec2h_Y_AXiS :: linalg.VECTOR3F16_Y_AXIS
Vec2_Y_AXiS  :: linalg.VECTOR3F32_Y_AXIS
Vec2d_Y_AXiS :: linalg.VECTOR3F64_Y_AXIS

Vec2h_Z_AXiS :: linalg.VECTOR3F16_Z_AXIS
Vec2_Z_AXiS  :: linalg.VECTOR3F32_Z_AXIS    
Vec2d_Z_AXiS :: linalg.VECTOR3F64_Z_AXIS

