package eobjects

import "core:strings"

GetSceneData_cstr :: proc(scene_name: cstring) -> (scene_data: SceneData, ok: bool) {
    if data, exists := &sceneDataMap[scene_name]; exists {
        return data^, true
    }
    return {}, false
}

GetSceneData_str :: proc(scene_name: string) -> (scene_data: SceneData, ok: bool) {
    return GetSceneData(strings.clone_to_cstring(scene_name, context.temp_allocator))
}

GetSceneData :: proc{
    GetSceneData_cstr,
    GetSceneData_str,
}