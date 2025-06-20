
import CLua

public struct LuaState {
    
    public let state: UnsafeMutablePointer<lua_State>
    
    public init(state: UnsafeMutablePointer<lua_State>) {
        self.state = state
    }

    public static func newLuaState() -> LuaState {
        return LuaState(state: luaL_newstate())
    }

    public func openLibs() {
        luaL_openlibs(state)
    }

    public func newThread() -> LuaState {
        return LuaState(state: lua_newthread(state))
    }
    
    public func loadBufferX(buffer: String, name: String, mode: String = "bt") -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: luaL_loadbufferx(state, buffer, buffer.count, name, mode))
    }

    public func pcall(nargs: Int32, nresults: Int32 = LUA_MULTRET, errfunc: Int32 = 0) -> LuaThreadStatus {
        return pcallk(nargs: nargs, nresults: nresults, errfunc: errfunc, ctx: 0, k: nil)
    }
    
    public func pcallk(nargs: Int32, nresults: Int32 = LUA_MULTRET, errfunc: Int32 = 0, ctx: lua_KContext, k: lua_KFunction?) -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: lua_pcallk(state, nargs, nresults, errfunc, ctx, k))
    }

    public func resume(from: LuaState? = nil, nargs: Int32, nresults: inout Int32) -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: lua_resume(state, from?.state, nargs, &nresults))
    }

    public func isInteger(_ idx: Int32) -> Bool {
        return lua_isinteger(state, idx) == 1
    }

    public func toInteger(_ idx: Int32) -> lua_Integer? {
        var isnum: Int32 = 0
        let res = lua_tointegerx(state, idx, &isnum)
        if isnum == 1 {
            return res
        } else {
            return nil
        }
    }

    public func toBoolean(_ idx: Int32) -> Bool {
        return lua_toboolean(state, idx) == 1
    }

    public func toNumber(_ idx: Int32) -> lua_Number? {
        var isnum: Int32 = 0
        let res = lua_tonumberx(state, idx, &isnum)
        if isnum == 1 {
            return res
        } else {
            return nil
        }
    }
    
    public func toString(_ idx: Int32) -> String? {
        var len: Int = 0
        if let res = lua_tolstring(state, idx, &len) {
            return String(cString: res)
        } else {
            return nil
        }
    }

    public func toLightUserData(_ idx: Int32) -> UnsafeMutableRawPointer? {
        return lua_touserdata(state, idx)
    }

    public func toUserData(_ idx: Int32) -> UnsafeMutableRawPointer? {
        return lua_touserdata(state, idx)
    }

    public func toThread(_ idx: Int32) -> LuaState? {
        return LuaState(state: lua_tothread(state, idx))
    }

    public func type(_ idx: Int32) -> LuaType {
        return LuaType(rawValue: lua_type(state, idx))
    }

    public func pop(_ n: Int32) {
        lua_settop(state, -n - 1)
    }

    public func pushValue(_ idx: Int32) {
        lua_pushvalue(state, idx)
    }

    public func pushNil() {
        lua_pushnil(state)
    }

    public func pushBoolean(_ b: Bool) {
        lua_pushboolean(state, b ? 1 : 0)
    }

    public func pushInteger(_ i: lua_Integer) {
        lua_pushinteger(state, i)
    }

    public func pushNumber(_ n: lua_Number) {
        lua_pushnumber(state, n)
    }

    public func pushString(_ s: String) {
        lua_pushstring(state, s)
    }
    
    public func pushLightUserData(_ p: UnsafeMutableRawPointer) {
        lua_pushlightuserdata(state, p)
    }

    public func pushUserData(_ p: UnsafeMutableRawPointer) {
        lua_pushlightuserdata(state, p)
    }

    public func pushThread() {
        lua_pushthread(state)
    }

    public func ref(t: Int32 = LUA_REGISTRYINDEX) -> Int32 {
        return luaL_ref(state, t)
    }

    public func unref(t: Int32 = LUA_REGISTRYINDEX, ref: Int32) {
        luaL_unref(state, t, ref)
    }

    public func rawGetI(_ idx: Int32, n: lua_Integer) -> LuaType {
        return LuaType(rawValue: lua_rawgeti(state, idx, n))
    }

    public func close() {
        lua_close(state)
    }

    /// Compares two Lua values. Returns true if the value at index index1 satisfies op when compared with the value at index index2, following the semantics of the corresponding Lua operator (that is, it may call metamethods). Otherwise returns false. Also returns false if any of the indices is not valid.
    /// The value of op must be one of the following constants:
    /// LUA_OPEQ: compares for equality (==)
    /// LUA_OPLT: compares for less than (<)
    /// LUA_OPLE: compares for less or equal (<=)
    public func compare(idx1: Int32, idx2: Int32, op: Int32) -> Bool {
        return lua_compare(state, idx1, idx2, op) == 1
    }

    /// Concatenates the n values at the top of the stack, pops them, and leaves the result at the top. If n is 1, the result is the single value on the stack (that is, the function does nothing); if n is 0, the result is the empty string. Concatenation is performed following the usual semantics of Lua (see §3.4.6)
    public func concat(_ n: Int32) {
        lua_concat(state, n)
    }

    /// Copies the element at index fromidx into the valid index toidx, replacing the value at that position. Values at other positions are not affected.
    public func copy(fromidx: Int32, toidx: Int32) {
        lua_copy(state, fromidx, toidx)
    }

    /// Creates a new empty table and pushes it onto the stack. Parameter narr is a hint for how many elements the table will have as a sequence; parameter nrec is a hint for how many other elements the table will have. Lua may use these hints to preallocate memory for the new table. This preallocation is useful for performance when you know in advance how many elements the table will have. Otherwise you can use the function lua_newtable.
    public func newTable(narr: Int32, nrec: Int32) {
        lua_createtable(state, narr, nrec)
    }

    /// Generates a Lua error, using the value at the top of the stack as the error object. This function does a long jump, and therefore never returns (see luaL_error).
    public func error() {
        lua_error(state)
    }

    /// Controls the garbage collector.
    /// This function performs several tasks, according to the value of the parameter what:
    /// LUA_GCSTOP: stops the garbage collector.
    /// LUA_GCRESTART: restarts the garbage collector.
    /// LUA_GCCOLLECT: performs a full garbage-collection cycle.
    /// LUA_GCCOUNT: returns the current amount of memory (in Kbytes) in use by Lua.
    /// LUA_GCCOUNTB: returns the remainder of dividing the current amount of bytes of memory in use by Lua by 1024.
    /// LUA_GCSTEP: performs an incremental step of garbage collection.
    /// LUA_GCSETPAUSE: sets data as the new value for the pause of the collector (see §2.5) and returns the previous value of the pause.
    /// LUA_GCSETSTEPMUL: sets data as the new value for the step multiplier of the collector (see §2.5) and returns the previous value of the step multiplier.
    /// LUA_GCISRUNNING: returns a boolean that tells whether the collector is running (i.e., not stopped).
    public func gc(what: Int32) -> Int32 {
        return lua_gc_non_varadic(state, what)
    }

    public func gc(what: Int32, data: Int32) -> Int32 {
        return lua_gc_non_varadic_with_data(state, what, data)
    }
    
    /// Pushes onto the stack the value t[k], where t is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4).
    /// Returns the type of the pushed value.
    public func getField(_ idx: Int32, key: String) -> LuaType {
        return LuaType(rawValue: lua_getfield(state, idx, key))
    }

    /// Returns a pointer to a raw memory area associated with the given Lua state. The application can use this area for any purpose; Lua does not use it for anything.
    /// Each new thread has this area initialized with a copy of the area of the main thread.
    /// By default, this area has the size of a pointer to void, but you can recompile Lua with a different size for this area. (See LUA_EXTRASPACE in luaconf.h.)
    public func getExtraSpace() -> UnsafeMutableRawPointer {
        return lua_getextraspace_function(state)
    }

    /// Pushes onto the stack the value of the global name.
    /// Returns the type of that value.
    public func getGlobal(_ name: String) -> LuaType {
        return LuaType(rawValue: lua_getglobal(state, name))
    }

    /// Pushes onto the stack the value t[i], where t is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4).
    /// Returns the type of the pushed value.
    public func getI(_ idx: Int32, i: Int64) -> LuaType {
        return LuaType(rawValue: lua_geti(state, idx, i))
    }
    
    /// Returns true when metatable was pushed to stack, and false when no metatable was found (and nothing was pushed to stack)
    public func getMetatable(_ idx: Int32) -> Bool {
        return lua_getmetatable(state, idx) == 1
    }

    /// Pushes onto the stack the value t[k], where t is the value at the given index and k is the value at the top of the stack.
    /// This function pops the key from the stack, pushing the resulting value in its place. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4).
    /// Returns the type of the pushed value.
    public func getTable(_ idx: Int32, key: String) -> LuaType {
        return LuaType(rawValue: lua_gettable(state, idx))
    }

    /// Returns the index of the top element in the stack. Because indices start at 1, this result is equal to the number of elements in the stack; in particular, 0 means an empty stack.
    public func getTop() -> Int32 {
        return lua_gettop(state)
    }

    /// Accepts any index, or 0, and sets the stack top to this index. If the new top is larger than the old one, then the new elements are filled with nil. If index is 0, then all stack elements are removed.
    public func setTop(_ idx: Int32) {
        lua_settop(state, idx)
    }

    /// Pushes onto the stack the Lua value associated with the full userdata at the given index.
    /// Returns the type of the pushed value.
    public func getUserValue(_ idx: Int32 = 1) -> LuaType {
        return LuaType(rawValue: lua_getiuservalue(state , idx, 1))
    }

    /// Moves the top element into the given valid index, shifting up the elements above this index to open space.
    /// This function cannot be called with a pseudo-index, because a pseudo-index is not an actual stack position.
    public func insert(_ idx: Int32) {
        lua_rotate(state, idx, 1)
    }

    /// Returns the length of the value at the given index. It is equivalent to the '#' operator in Lua and may trigger a metamethod for the "length" event.
    /// The result is pushed on the stack.
    public func len(_ idx: Int32) {
        lua_len(state, idx)
    }

    /// Returns the status of the thread.
    /// The status can be LUA_OK for a normal thread, an error code if the thread finished the execution of a resume with an error, or LUA_YIELD if the thread is suspended.
    /// You can only call functions in threads with status LUA_OK. You can resume threads with status LUA_OK (to start a new coroutine) or LUA_YIELD (to resume a coroutine).
    public func status() -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: lua_status(state))
    }
}

public let LUA_REGISTRYINDEX: Int32 = -LUAI_MAXSTACK - 1000

public struct LuaType: RawRepresentable, Sendable {
    public let rawValue: Int32
    
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    public static let LUA_TNONE = LuaType(rawValue: CLua.LUA_TNONE)
    public static let LUA_TNIL = LuaType(rawValue: CLua.LUA_TNIL)
    public static let LUA_TBOOLEAN = LuaType(rawValue: CLua.LUA_TBOOLEAN)
    public static let LUA_TLIGHTUSERDATA = LuaType(rawValue: CLua.LUA_TLIGHTUSERDATA)
    public static let LUA_TNUMBER = LuaType(rawValue: CLua.LUA_TNUMBER)
    public static let LUA_TSTRING = LuaType(rawValue: CLua.LUA_TSTRING)
    public static let LUA_TTABLE = LuaType(rawValue: CLua.LUA_TTABLE)
    public static let LUA_TFUNCTION = LuaType(rawValue: CLua.LUA_TFUNCTION)
    public static let LUA_TUSERDATA = LuaType(rawValue: CLua.LUA_TUSERDATA)
    public static let LUA_TTHREAD = LuaType(rawValue: CLua.LUA_TTHREAD)
    public static let LUA_NUMTYPES = LuaType(rawValue: CLua.LUA_NUMTYPES)
}


public struct LuaThreadStatus: RawRepresentable, Sendable {
    public let rawValue: Int32
    
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    public static let LUA_OK = LuaThreadStatus(rawValue: CLua.LUA_OK)
    public static let LUA_YIELD = LuaThreadStatus(rawValue: CLua.LUA_YIELD)
    public static let LUA_ERRRUN = LuaThreadStatus(rawValue: CLua.LUA_ERRRUN)
    public static let LUA_ERRSYNTAX = LuaThreadStatus(rawValue: CLua.LUA_ERRSYNTAX)
    public static let LUA_ERRMEM = LuaThreadStatus(rawValue: CLua.LUA_ERRMEM)
    public static let LUA_ERRERR = LuaThreadStatus(rawValue: CLua.LUA_ERRERR)
}


public let LUA_EXTRASPACE: Int = LUA_EXTRASPACE_SIZE()
