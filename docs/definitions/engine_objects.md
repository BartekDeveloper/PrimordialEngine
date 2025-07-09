package objects
	variables
		allLoaded: bool = false
		currentIndex: u32 = 0
		defaultOptions: tf.options = {}
		defaultOptionsPtr := &defaultOptions
		modelExists: map[string]b8 = {}
		modelGroups: map[string]SceneData = {}

	procedures
		AddIndex :: proc() {...}
		CheckAccessor :: proc(name: cstring = "", mapping: ^map[cstring]tf.accessor = nil) -> (oAccessor: ^tf.accessor) {...}
		CleanUp :: proc() ->  {...}
		CleanUpModels :: proc() ->  {...}
		ConvertPrimitive_fromTfToUnified :: proc(from: tf.primitive_type) -> (to: PrimitiveType = nil) {...}
		ConvertPrimitive_fromUnifiedToTf :: proc(from: PrimitiveType) -> (to: tf.primitive_type = nil) {...}
		GetIndex :: proc() -> u32 {...}
		GetModel :: proc(name: string) -> (model: SceneData, ok: bool = true) {...}
		ListModelNames :: proc() -> (oNames: []string) {...}
		LoadModels :: proc(dir: string = "./assets/models") ->  {...}
		Load_fromFile :: proc(file: string = "", options: tf.options = defaultOptions) -> (outSceneData: SceneData = {}, good: bool = true) {...}
		Load_fromMemory :: proc(buffer: []byte = {}, name: string = "unnamed", options: tf.options = defaultOptions) -> (outSceneData: SceneData = {}, good: bool = true) {...}
		MapAccessor :: proc(mapping: ^map[cstring]tf.accessor = nil, attr: ^tf.attribute = nil) ->  {...}
		ModelExists :: proc(name: string) -> bool {...}
		PrintAllModels :: proc() ->  {...}
		ProcessData :: proc(data: ^tf.data, name: string, path: string) -> (sceneData: SceneData) {...}
		ProcessMesh :: proc(mesh: ^tf.mesh) -> (model: Model) {...}
		ProcessModelFile :: proc(f: ^os.File_Info, #any_int index: u32, dir: string) -> (ok: bool = true) {...}
		ProcessPrimitive :: proc(prime: ^tf.primitive) -> (mesh: Mesh) {...}
		ProcessVertex :: proc(vertices: ^[]s.Vertex, acPosition: ^tf.accessor, acNormal: ^tf.accessor, acTangent: ^tf.accessor, acColor: ^tf.accessor, acUv0: ^tf.accessor, acJoint: ^tf.accessor) ->  {...}
		ReadF32 :: proc(accessor: ^tf.accessor, data: ^f32) {...}
		ReadFloat :: proc(accessor: ^tf.accessor, data: [^]f32, #any_int count: u32) {...}
		ReadU32 :: proc(accessor: ^tf.accessor, data: ^u32) {...}
		ReadUint :: proc(accessor: ^tf.accessor, data: [^]u32, #any_int count: u32) {...}
		ReadVec2 :: proc(accessor: ^tf.accessor, data: ^emath.Vec2) {...}
		ReadVec2U :: proc(accessor: ^tf.accessor, data: ^emath.uVec2) {...}
		ReadVec3 :: proc(accessor: ^tf.accessor, data: ^emath.Vec3) {...}
		ReadVec3U :: proc(accessor: ^tf.accessor, data: ^emath.uVec3) {...}
		ReadVec4 :: proc(accessor: ^tf.accessor, data: ^emath.Vec4) {...}
		ReadVec4U :: proc(accessor: ^tf.accessor, data: ^emath.uVec4) {...}
		SetIndex :: proc(index: u32) {...}

	proc_group
		ConvertPrimitive :: proc{ConvertPrimitive_fromTfToUnified, ConvertPrimitive_fromUnifiedToTf}
		Load :: proc{Load_fromFile, Load_fromMemory}
		Read :: proc{ReadVec4, ReadVec3, ReadVec2, ReadF32, ReadVec4U, ReadVec3U, ReadVec2U, ReadU32}

	types
		Mesh :: #type struct {vertices: []s.Vertex, indices: []u32, joints: []joint, verticesCount: u32, indicesCount: u32, type: PrimitiveType}
		Model :: #type struct {name: cstring, meshes: map[string]Mesh}
		Models :: #type map[string]Model
		PrimitiveType :: enum u8 {Invalid, Point, Line, Triangle, TriangleStrip, TriangleFan}
		SceneData :: #type struct {path: string, objects: Models, flags: SceneFlags}
		SceneFlag :: enum u8 {ReLoad, Invalid}
		SceneFlags :: #type bit_set[SceneFlag]
		joint :: #type u8


	fullpath:
		/home/zota/projects/multi/vk_dynamic/src/engine/objects
	files:
		prepare.odin
		read.odin
		types.odin
