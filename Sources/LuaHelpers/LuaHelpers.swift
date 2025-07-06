
import CLua
import Lua

extension LuaState {
    
    @inlinable
    @inline(__always)
    public func pushRef(_ ref: Int32) -> LuaType {
        self.rawGetI(LUA_REGISTRYINDEX, n: lua_Integer(ref))
    }
    
    @inlinable
    @inline(__always)
    public func pushTable(_ table: Table) {
        self.createTable(narr: Int32(table.narr), nrec: Int32(table.nrec))
        for (swiftI, value) in table.array.enumerated() {
            let luaI = Int64(swiftI + 1)
            self.pushValue(value)
            self.setI(-2, i: luaI)
        }
        for (swiftKey, value) in table.dictionary {
            switch swiftKey {
            case .string(let string):
                self.pushValue(value)
                self.setField(-2, key: string)
            case .nonIndexNumber(let int):
                self.pushNumber(int)
                self.pushValue(value)
                self.setTable(-3)
            case .bool(let bool):
                self.pushBoolean(bool)
                self.pushValue(value)
                self.setTable(-3)
            }
            
        }
    }
    
    /// Pushes value which isn't associated with a Lua VM to the Lua stack
    @inlinable
    @inline(__always)
    public func pushValue(_ value: Value) {
        switch value {
        case .luaNil:
            self.pushNil()
        case .bool(let bool):
            self.pushBoolean(bool)
        case .number(let num):
            switch num {
            case .int(let int):
                self.pushInteger(int)
            case .double(let double):
                self.pushNumber(double)
            }
        case .string(let str):
            self.pushString(str)
        case .table(let table):
            self.pushTable(table)
        case .lightUserData(let lightUserData):
            self.pushLightUserData(lightUserData)
        }
    }
    
    @inlinable
    @inline(__always)
    public func rawGetIRegistryIndex(ref: lua_Integer) -> LuaType {
        return self.rawGetI(LUA_REGISTRYINDEX, n: ref)
    }

    /// Stops the garbage collector.
    @inlinable
    @inline(__always)
    @discardableResult
    public func gcStop() -> Int32 {
        return gc(what: LUA_GCSTOP)
    }

    /// Restarts the garbage collector.
    @inlinable
    @inline(__always)
    @discardableResult
    public func gcRestart() -> Int32 {
        return gc(what: LUA_GCRESTART)
    }

    /// Performs a full garbage-collection cycle.
    @inlinable
    @inline(__always)
    @discardableResult
    public func gcCollect() -> Int32 {
        return gc(what: LUA_GCCOLLECT)
    }

    /// Returns the current amount of memory (in Kbytes) in use by Lua.
    @inlinable
    @inline(__always)
    public func gcCount() -> Int32 {
        return gc(what: LUA_GCCOUNT)
    }

    /// Returns the remainder of dividing the current amount of bytes of memory in use by Lua by 1024.
    @inlinable
    @inline(__always)
    public func gcCountB() -> Int32 {
        return gc(what: LUA_GCCOUNTB)
    }

    /// Performs an incremental step of garbage collection.
    @inlinable
    @inline(__always)
    @discardableResult
    public func gcStep() -> Int32 {
        return gc(what: LUA_GCSTEP)
    }

    /// Sets data as the new value for the pause of the collector (see §2.5) and returns the previous value of the pause.
    @inlinable
    @inline(__always)
    public func gcSetPause(data: Int32) -> Int32 {
        return gc(what: LUA_GCSETPAUSE, data: data)
    }

    /// Sets data as the new value for the step multiplier of the collector (see §2.5) and returns the previous value of the step multiplier.
    @inlinable
    @inline(__always)
    public func gcSetStepMul(data: Int32) -> Int32 {
        return gc(what: LUA_GCSETSTEPMUL, data: data)
    }

    /// Returns a boolean that tells whether the collector is running (i.e., not stopped).
    @inlinable
    @inline(__always)
    public func gcIsRunning() -> Bool {
        return gc(what: LUA_GCISRUNNING) == 1
    }
    
    /// Pushes a C function onto the stack. This function receives a pointer to a C function and pushes onto the stack a Lua value of type function that, when called, invokes the corresponding C function.
    /// Note: this should be safe, as LuaState has the same memory layout as UnsafeMutablePointer<lua_State>?.
    /// Furthermore, @convention(thin) to @convention(c) should be okay as both LuaState and UnsafeMutablePointer<lua_State>? don't participate in ARC.
    /// Maybe the unsafeBitCast can be avoided in the future with a trampoline or by an improvement
    /// to the Swift compiler.
    @inlinable
    @inline(__always)
    public func pushCFunction(_ f: @convention(thin) (LuaState) -> Int32) {
        self.pushLuaCFunction(unsafeBitCast(f, to: lua_CFunction.self))
    }
    
    @inlinable
    @inline(__always)
    public func setField(_ idx: Int32, key: String, cFunction f: @convention(thin) (LuaState) -> Int32) {
        self.pushCFunction(f)
        self.setField(idx, key: key)
    }
}
