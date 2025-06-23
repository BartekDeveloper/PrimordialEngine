package main

import "core:fmt"
import "core:mem"

import "src/engine"
import "src/maths"

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

            fmt.eprintfln("* -=-=-=-> %v ($%v) Not freed! <-=-=-=- *", len(trace.allocation_map), total_not_deallocated);
            for _, entry in trace.allocation_map {
                fmt.eprintfln("\t $%v  -\n\t\t %s", entry.size, entry.location);
            }
            fmt.eprintln("* -=-=-=-> -------------- <-=-=-=- *");
        }
    }
    
    engine.Init()
    defer engine.Destroy()
    engine.Start()
}

