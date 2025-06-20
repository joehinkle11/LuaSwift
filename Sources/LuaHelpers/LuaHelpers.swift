
import CLua
import Lua

extension LuaState {
    
    public func rawGetIRegistryIndex(ref: lua_Integer) -> LuaType {
        return self.rawGetI(LUA_REGISTRYINDEX, n: ref)
    }

    /// Stops the garbage collector.
    @discardableResult
    public func gcStop() -> Int32 {
        return gc(what: LUA_GCSTOP)
    }

    /// Restarts the garbage collector.
    @discardableResult
    public func gcRestart() -> Int32 {
        return gc(what: LUA_GCRESTART)
    }

    /// Performs a full garbage-collection cycle.
    @discardableResult
    public func gcCollect() -> Int32 {
        return gc(what: LUA_GCCOLLECT)
    }

    /// Returns the current amount of memory (in Kbytes) in use by Lua.
    public func gcCount() -> Int32 {
        return gc(what: LUA_GCCOUNT)
    }

    /// Returns the remainder of dividing the current amount of bytes of memory in use by Lua by 1024.
    public func gcCountB() -> Int32 {
        return gc(what: LUA_GCCOUNTB)
    }

    /// Performs an incremental step of garbage collection.
    @discardableResult
    public func gcStep() -> Int32 {
        return gc(what: LUA_GCSTEP)
    }

    /// Sets data as the new value for the pause of the collector (see §2.5) and returns the previous value of the pause.
    public func gcSetPause(data: Int32) -> Int32 {
        return gc(what: LUA_GCSETPAUSE, data: data)
    }

    /// Sets data as the new value for the step multiplier of the collector (see §2.5) and returns the previous value of the step multiplier.
    public func gcSetStepMul(data: Int32) -> Int32 {
        return gc(what: LUA_GCSETSTEPMUL, data: data)
    }

    /// Returns a boolean that tells whether the collector is running (i.e., not stopped).
    public func gcIsRunning() -> Bool {
        return gc(what: LUA_GCISRUNNING) == 1
    }
}
