package engine_shared
	types
		RenderData :: #type struct {deltaTime: i64, deltaTime_f64: f64, currentFrame: int, MAX_FRAMES_IN_FLIGHT: int}
		UBO :: #type UniformBufferObject
		UniformBufferObject :: #type struct {proj: emath.Mat4, iProj: emath.Mat4, view: emath.Mat4, iView: emath.Mat4, deltaTime: f32, winWidth: f32, winHeight: f32, cameraPos: emath.Vec3, cameraUp: emath.Vec3, worldUp: emath.Vec3, worldTime: int, model: emath.Mat4}
		Vertex :: #type VertexData
		VertexData :: #type struct {pos: emath.Vec3, norm: emath.Vec3, tan: emath.Vec3, color: emath.Vec3, uv0: emath.Vec2}


	fullpath:
		/home/zota/projects/multi/vk_new/src/shared
	files:
		shared.odin
