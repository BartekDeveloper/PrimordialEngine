package main

import "core:fmt"
import "core:mem"

import "src/engine"
import "src/maths"
import obj "src/engine/objects"

main :: proc() {
    
    defer free_all(context.temp_allocator)
    when ODIN_DEBUG {
        trace: mem.Tracking_Allocator
        mem.tracking_allocator_init(&trace, context.allocator);
        context.allocator = mem.tracking_allocator(&trace)

        defer {
            total_not_deallocated := 0
            for k, v in trace.allocation_map {
                total_not_deallocated += v.size
            }

            fmt.eprint("\n\n\n")
            fmt.eprintfln("* -=-=-=-> %v ($%v) Not freed! <-=-=-=- *", len(trace.allocation_map), total_not_deallocated)
            defer fmt.eprintln("* -=-=-=-> -------------- <-=-=-=- *")
            for _, entry in trace.allocation_map {
                fmt.eprintfln("\t $%v  -\n\t\t %s", entry.size, entry.location)
            }
        }
    }

    obj.LoadModels()
    defer obj.CleanUpModels()
    obj.PrintAllModels()

    // engine.Init()
    // defer engine.Destroy()
    
    // engine.Start()
}
