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

Mat1h_IDENTIFY :: linalg.MATRIX1F16_IDENTITY
Mat1_IDENTITY  :: linalg.MATRIX1F32_IDENTITY
Mat1d_IDENTIFY :: linalg.MATRIX1F64_IDENTITY

Mat2h_IDENTIFY :: linalg.MATRIX2F16_IDENTITY
Mat2_IDENTITY  :: linalg.MATRIX2F32_IDENTITY
Mat2d_IDENTIFY :: linalg.MATRIX2F64_IDENTITY

Mat3h_IDENTIFY :: linalg.MATRIX3F16_IDENTITY
Mat3_IDENTITY  :: linalg.MATRIX3F32_IDENTITY
Mat3d_IDENTIFY :: linalg.MATRIX3F64_IDENTITY

Mat4h_IDENTIFY :: linalg.MATRIX4F16_IDENTITY
Mat4_IDENTITY  :: linalg.MATRIX4F32_IDENTITY
Mat4d_IDENTIFY :: linalg.MATRIX4F64_IDENTITY

Quath_IDENTIFY :: linalg.QUATERNIONF16_IDENTITY
Quat_IDENTITY  :: linalg.QUATERNIONF32_IDENTITY
Quatd_IDENTIFY :: linalg.QUATERNIONF64_IDENTITY

Vec2h_X_AXIS :: linalg.VECTOR3F16_X_AXIS
Vec2_X_AXIS  :: linalg.VECTOR3F32_X_AXIS
Vec2d_X_AXIS :: linalg.VECTOR3F64_X_AXIS

Vec2h_Y_AXIS :: linalg.VECTOR3F16_Y_AXIS
Vec2_Y_AXIS  :: linalg.VECTOR3F32_Y_AXIS
Vec2d_Y_AXIS :: linalg.VECTOR3F64_Y_AXIS

Vec2h_Z_AXIS :: linalg.VECTOR3F16_Z_AXIS
Vec2_Z_AXIS  :: linalg.VECTOR3F32_Z_AXIS    
Vec2d_Z_AXIS :: linalg.VECTOR3F64_Z_AXIS

