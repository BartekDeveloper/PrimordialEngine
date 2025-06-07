package main

import "core:fmt"
import "core:mem"

import "src/engine"

main :: proc() {
    
    when ODIN_DEBUG {
        trace: mem.Tracking_Allocator
        mem.tracking_allocator_init(&trace, context.allocator);
        context.allocator = mem.tracking_allocator(&trace)

        defer {
            fmt.eprintfln("* -=-=-=-> $%v Not freed! <-=-=-=- *", len(trace.allocation_map));
            for _, entry in trace.allocation_map {
                fmt.eprintfln("\t $%v  -\n\t\t %s", entry.size, entry.location);
            }
            fmt.eprintln("* -=-=-=-> -------------- <-=-=-=- *");
        }
    }

    engine.Init()
    engine.Start()
    defer engine.Destroy()
}
  
