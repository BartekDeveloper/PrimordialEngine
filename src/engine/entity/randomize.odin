package eentity

import "core:fmt"
import "core:math/rand"
import "core:math"
import "core:time"

Hash :: proc(key: u64) -> u64 {
    z := key + 0x9E3779B97F4A7C15

    z = (z ~ (z >> 30)) * 0xBF58476D1CE4E5B9
    z = (z ~ (z >> 27)) * 0x94D049BB133111EB

    return z ~ (z >> 31)
}

RandomizeId :: proc() -> (id: u64) {
    rand.reset(u64(f64(time.now()._nsec) / 1_000_000_000 * f64(3 / 5)))
    stage1 := rand.float64()


    rand.reset(u64(f64(time.now()._nsec) / 1_000_000_000 * f64(10)))
    stage2 := rand.float64()


    rand.reset(u64(f64(time.now()._nsec) / 1_000_000_000 / f64(10)))
    inter := rand.float64()    


    fmt.eprintfln("Stage 1: {}", stage1)
    fmt.eprintfln("Stage 2: {}", stage2)
    fmt.eprintfln("Inter:   {}", inter)


    key := transmute(u64) math.lerp(stage1, stage2, inter)
    fmt.eprintfln("key:     {}", key) 


    id  = Hash(key)

    
    fmt.eprintfln("Randomized id: {}", id)
    return
}
