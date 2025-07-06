package engine_math
	constants
		Mat1_IDENTITY :: linalg.MATRIX1F32_IDENTITY
		Mat1d_iDENTIFY :: linalg.MATRIX1F64_IDENTITY
		Mat1h_iDENTIFY :: linalg.MATRIX1F16_IDENTITY
		Mat2_IDENTITY :: linalg.MATRIX2F32_IDENTITY
		Mat2d_iDENTIFY :: linalg.MATRIX2F64_IDENTITY
		Mat2h_iDENTIFY :: linalg.MATRIX2F16_IDENTITY
		Mat3_IDENTITY :: linalg.MATRIX3F32_IDENTITY
		Mat3d_iDENTIFY :: linalg.MATRIX3F64_IDENTITY
		Mat3h_iDENTIFY :: linalg.MATRIX3F16_IDENTITY
		Mat4_IDENTITY :: linalg.MATRIX4F32_IDENTITY
		Mat4d_iDENTIFY :: linalg.MATRIX4F64_IDENTITY
		Mat4h_iDENTIFY :: linalg.MATRIX4F16_IDENTITY
		Quat_IDENTITY :: linalg.QUATERNIONF32_IDENTITY
		Quatd_iDENTIFY :: linalg.QUATERNIONF64_IDENTITY
		Quath_iDENTIFY :: linalg.QUATERNIONF16_IDENTITY
		Vec2_X_AXiS :: linalg.VECTOR3F32_X_AXIS
		Vec2_Y_AXiS :: linalg.VECTOR3F32_Y_AXIS
		Vec2_Z_AXiS :: linalg.VECTOR3F32_Z_AXIS
		Vec2d_X_AXiS :: linalg.VECTOR3F64_X_AXIS
		Vec2d_Y_AXiS :: linalg.VECTOR3F64_Y_AXIS
		Vec2d_Z_AXiS :: linalg.VECTOR3F64_Z_AXIS
		Vec2h_X_AXiS :: linalg.VECTOR3F16_X_AXIS
		Vec2h_Y_AXiS :: linalg.VECTOR3F16_Y_AXIS
		Vec2h_Z_AXiS :: linalg.VECTOR3F16_Z_AXIS

	variables
		PI: f64 

	procedures
		Cos :: proc(x: f32) -> f32 ---
		CosD :: proc(x: f64) -> f64 ---
		CosD_Approx :: proc(x: f64) -> f64 ---
		CosI :: proc(x: i32) -> i32 ---
		CosI_Approx :: proc(x: f32) -> i32 ---
		Cross_vec3 :: proc(a, b: Vec3) -> (o: Vec3) {...}
		Cross_vec3d :: proc(a, b: Vec3d) -> (o: Vec3d) {...}
		Cross_vec3h :: proc(a, b: Vec3h) -> (o: Vec3h) {...}
		Dot_f32 :: proc(a, b: f32) -> (o: f32) {...}
		Dot_f64 :: proc(a, b: f64) -> (o: f64) {...}
		Dot_i32 :: proc(a, b: i32) -> (o: i32) {...}
		Dot_quat :: proc(a, b: Quat) -> (o: f32) {...}
		Dot_quatd :: proc(a, b: Quatd) -> (o: f64) {...}
		Dot_quath :: proc(a, b: Quath) -> (o: f16) {...}
		Dot_vec2 :: proc(a, b: Vec2) -> (o: f32) {...}
		Dot_vec2d :: proc(a, b: Vec2d) -> (o: f64) {...}
		Dot_vec2h :: proc(a, b: Vec2h) -> (o: f16) {...}
		Dot_vec3 :: proc(a, b: Vec3) -> (o: f32) {...}
		Dot_vec3d :: proc(a, b: Vec3d) -> (o: f64) {...}
		Dot_vec3h :: proc(a, b: Vec3h) -> (o: f16) {...}
		Dot_vec4 :: proc(a, b: Vec4) -> (o: f32) {...}
		Dot_vec4d :: proc(a, b: Vec4d) -> (o: f64) {...}
		Dot_vec4h :: proc(a, b: Vec4h) -> (o: f16) {...}
		Inverse_mat2 :: proc(m: Mat2) -> (o: Mat2) {...}
		Inverse_mat2d :: proc(m: Mat2d) -> (o: Mat2d) {...}
		Inverse_mat2h :: proc(m: Mat2h) -> (o: Mat2h) {...}
		Inverse_mat3 :: proc(m: Mat3) -> (o: Mat3) {...}
		Inverse_mat3d :: proc(m: Mat3d) -> (o: Mat3d) {...}
		Inverse_mat3h :: proc(m: Mat3h) -> (o: Mat3h) {...}
		Inverse_mat4 :: proc(m: Mat4) -> (o: Mat4) {...}
		Inverse_mat4d :: proc(m: Mat4d) -> (o: Mat4d) {...}
		Inverse_mat4h :: proc(m: Mat4h) -> (o: Mat4h) {...}
		Inverse_quat :: proc(q: Quat) -> (o: Quat) {...}
		Inverse_quatd :: proc(q: Quatd) -> (o: Quatd) {...}
		Inverse_quath :: proc(q: Quath) -> (o: Quath) {...}
		LookAt :: proc(eye: Vec3, center: Vec3, up: Vec3) -> (o: Mat4 = {}) {...}
		Normalize_f32 :: proc(i: f32) -> (o: f32) {...}
		Normalize_f64 :: proc(i: f64) -> (o: f64) {...}
		Normalize_i32 :: proc(i: i32) -> (o: i32) {...}
		Normalize_quat :: proc(i: Quat) -> (o: Quat) {...}
		Normalize_quatd :: proc(i: Quatd) -> (o: Quatd) {...}
		Normalize_quath :: proc(i: Quath) -> (o: Quath) {...}
		Normalize_vec2 :: proc(i: Vec2) -> (o: Vec2) {...}
		Normalize_vec2d :: proc(i: Vec2d) -> (o: Vec2d) {...}
		Normalize_vec2h :: proc(i: Vec2h) -> (o: Vec2h) {...}
		Normalize_vec3 :: proc(i: Vec3) -> (o: Vec3) {...}
		Normalize_vec3d :: proc(i: Vec3d) -> (o: Vec3d) {...}
		Normalize_vec3h :: proc(i: Vec3h) -> (o: Vec3h) {...}
		Normalize_vec4 :: proc(i: Vec4) -> (o: Vec4) {...}
		Normalize_vec4d :: proc(i: Vec4d) -> (o: Vec4d) {...}
		Normalize_vec4h :: proc(i: Vec4h) -> (o: Vec4h) {...}
		Orthographic :: proc(top: f32, right: f32, bottom: f32, left: f32, near: f32, far: f32) -> (o: Mat4 = {}) {...}
		Perspective :: proc(fovy: f32, aspect: f32, near: f32, far: f32) -> (o: Mat4 = {}) {...}
		Perspective_InfDistance :: proc(fovy: f32, aspect: f32, near: f32) -> (o: Mat4 = {}) {...}
		Sin :: proc(x: f32) -> f32 ---
		SinD :: proc(x: f64) -> f64 ---
		SinD_Approx :: proc(x: f64) -> f64 ---
		SinI :: proc(x: i32) -> i32 ---
		SinI_Approx :: proc(x: f32) -> i32 ---
		Tan :: proc(x: f32) -> f32 ---
		TanD :: proc(x: f64) -> f64 ---
		TanD_Approx :: proc(x: f64) -> f64 ---
		TanI :: proc(x: f32) -> i32 ---
		TanI_Approx :: proc(x: f32) -> i32 ---

	proc_group
		Cross :: proc{Cross_vec3h, Cross_vec3, Cross_vec3d}
		Dot :: proc{Dot_i32, Dot_f32, Dot_f64, Dot_vec2h, Dot_vec2, Dot_vec2d, Dot_vec3h, Dot_vec3, Dot_vec3d, Dot_vec4h, Dot_vec4, Dot_vec4d, Dot_quath, Dot_quat, Dot_quatd}
		Inverse :: proc{Inverse_mat2h, Inverse_mat2, Inverse_mat2d, Inverse_mat3h, Inverse_mat3, Inverse_mat3d, Inverse_mat4h, Inverse_mat4, Inverse_mat4d, Inverse_quath, Inverse_quat, Inverse_quatd}
		Length :: linalg.length
		Normalize :: proc{Normalize_i32, Normalize_f32, Normalize_f64, Normalize_vec2h, Normalize_vec2, Normalize_vec2d, Normalize_vec3h, Normalize_vec3, Normalize_vec3d, Normalize_vec4h, Normalize_vec4, Normalize_vec4d, Normalize_quath, Normalize_quat, Normalize_quatd}

	types
		Mat1 :: linalg.Matrix1f32
		Mat1d :: linalg.Matrix1f32
		Mat1h :: linalg.Matrix1f16
		Mat2 :: linalg.Matrix2f32
		Mat2d :: linalg.Matrix2f64
		Mat2h :: linalg.Matrix2f16
		Mat3 :: linalg.Matrix3f32
		Mat3d :: linalg.Matrix3f64
		Mat3h :: linalg.Matrix3f16
		Mat4 :: linalg.Matrix4f32
		Mat4d :: linalg.Matrix4f64
		Mat4h :: linalg.Matrix4f16
		Quat :: linalg.Quaternionf32
		Quatd :: linalg.Quaternionf64
		Quath :: linalg.Quaternionf16
		Vec2 :: linalg.Vector2f32
		Vec2d :: linalg.Vector2f64
		Vec2h :: linalg.Vector2f16
		Vec3 :: linalg.Vector3f32
		Vec3d :: linalg.Vector3f64
		Vec3h :: linalg.Vector3f16
		Vec4 :: linalg.Vector4f32
		Vec4d :: linalg.Vector4f64
		Vec4h :: linalg.Vector4f16
		iVec2 :: [2]i32
		iVec2d :: [2]i64
		iVec2h :: [2]i16
		iVec3 :: [3]i32
		iVec3d :: [3]i64
		iVec3h :: [3]i16
		iVec4 :: [4]i32
		iVec4d :: [4]i64
		iVec4h :: [4]i16
		uVec2 :: [2]u32
		uVec2d :: [2]u64
		uVec2h :: [2]u16
		uVec3 :: [3]u32
		uVec3d :: [3]u64
		uVec3h :: [3]u16
		uVec4 :: [4]u32
		uVec4d :: [4]u64
		uVec4h :: [4]u16


	fullpath:
		/home/zota/projects/multi/vk_new/src/maths
	files:
		clib.odin
		cross.odin
		dot.odin
		inverse.odin
		linalg.odin
		math.odin
		normalize.odin
		types.odin
