import threading/Thread, os/Time, structs/ArrayList

// woo, evil globals. but it's for the purpose of our demonstration so deal with it.
mutex := Mutex new()
value : Int
maxThreads := const 100
iterations := const 5000

// our entry point
main: func {
    
    // test without synchronization first
    value = 0
    unsafeTest()
    printf("unsafe value = %d\n", value)
    
    // and now with synchronization
    value = 0
    safeTest()
    printf("  safe value = %d\n", value)
    
    // destroy our mutex
    mutex destroy()
    
}

unsafeTest: func {
    value = 0
    
    c := func {
        for(i in 0..iterations) {
            incrementUnsafe()
        }
    }
    
    list := ArrayList<Thread> new()
    for(i in 0..maxThreads) {
        list add(Thread new(c). start())
    }
    
    for(t in list) {
        t wait()
    }
}


safeTest: func {
    value = 0
    
    c := func {
        for(i in 0..iterations) {
            incrementSafe()
        }
    }
    
    list := ArrayList<Thread> new()
    for(i in 0..maxThreads) {
        list add(Thread new(c). start())
    }
    
    for(t in list) {
        t wait()
    }
}

incrementUnsafe: func {
    value += 1
}

incrementSafe: func {
    mutex lock()
    value += 1
    mutex unlock()
}

