
import CLua

public struct LuaState {
    
    @inline(__always)
    public let state: UnsafeMutablePointer<lua_State>?
    
    @inlinable
    @inline(__always)
    public init(state: UnsafeMutablePointer<lua_State>?) {
        self.state = state
    }
    
    @inlinable
    @inline(__always)
    public static func newLuaState() -> LuaState {
        return LuaState(state: luaL_newstate())
    }
    
    @inlinable
    @inline(__always)
    public func openLibs() {
        luaL_openlibs(state)
    }
    
    @inlinable
    @inline(__always)
    public func newThread() -> LuaState {
        return LuaState(state: lua_newthread(state))
    }
    
    @inlinable
    @inline(__always)
    public func loadBufferX(buffer: String, name: String, mode: String = "bt") -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: luaL_loadbufferx(state, buffer, buffer.count, name, mode))
    }
    
    @inlinable
    @inline(__always)
    public func pcall(nargs: Int32, nresults: Int32 = LUA_MULTRET, errfunc: Int32 = 0) -> LuaThreadStatus {
        return pcallk(nargs: nargs, nresults: nresults, errfunc: errfunc, ctx: 0, k: nil)
    }
    
    @inlinable
    @inline(__always)
    public func pcallk(nargs: Int32, nresults: Int32 = LUA_MULTRET, errfunc: Int32 = 0, ctx: lua_KContext, k: lua_KFunction?) -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: lua_pcallk(state, nargs, nresults, errfunc, ctx, k))
    }
    
    @inlinable
    @inline(__always)
    public func resume(from: LuaState? = nil, nargs: Int32, nresults: inout Int32) -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: lua_resume(state, from?.state, nargs, &nresults))
    }
    
    @inlinable
    @inline(__always)
    public func isInteger(_ idx: Int32 = -1) -> Bool {
        return lua_isinteger(state, idx) == 1
    }
    
    @inlinable
    @inline(__always)
    public func toInteger(_ idx: Int32 = -1) -> lua_Integer? {
        var isnum: Int32 = 0
        let res = lua_tointegerx(state, idx, &isnum)
        if isnum == 1 {
            return res
        } else {
            return nil
        }
    }
    
    @inlinable
    @inline(__always)
    public func toBoolean(_ idx: Int32 = -1) -> Bool {
        return lua_toboolean(state, idx) == 1
    }
    
    @inlinable
    @inline(__always)
    public func toNumber(_ idx: Int32 = -1) -> lua_Number? {
        var isnum: Int32 = 0
        let res = lua_tonumberx(state, idx, &isnum)
        if isnum == 1 {
            return res
        } else {
            return nil
        }
    }
    
    @inlinable
    @inline(__always)
    public func toString(_ idx: Int32 = -1) -> String? {
        var len: Int = 0
        if let res = lua_tolstring(state, idx, &len) {
            return String(cString: res)
        } else {
            return nil
        }
    }
    
    @inlinable
    @inline(__always)
    public func toLightUserData(_ idx: Int32 = -1) -> UnsafeMutableRawPointer? {
        return lua_touserdata(state, idx)
    }
    
    @inlinable
    @inline(__always)
    public func toUserData(_ idx: Int32 = -1) -> UnsafeMutableRawPointer? {
        return lua_touserdata(state, idx)
    }
    
    @inlinable
    @inline(__always)
    public func toThread(_ idx: Int32 = -1) -> LuaState? {
        return LuaState(state: lua_tothread(state, idx))
    }
    
    @inlinable
    @inline(__always)
    public func type(_ idx: Int32 = -1) -> LuaType {
        return LuaType(rawValue: lua_type(state, idx))
    }
    
    @inlinable
    @inline(__always)
    public func pop(_ n: Int32 = 1) {
        lua_settop(state, -n - 1)
    }
    
    /// Pushes a copy of the element at the given index onto the stack.
    @inlinable
    @inline(__always)
    public func pushValue(copiedFromIdx idx: Int32) {
        lua_pushvalue(state, idx)
    }
    
    @inlinable
    @inline(__always)
    public func pushNil() {
        lua_pushnil(state)
    }
    
    @inlinable
    @inline(__always)
    public func pushBoolean(_ b: Bool) {
        lua_pushboolean(state, b ? 1 : 0)
    }
    
    @inlinable
    @inline(__always)
    public func pushInteger(_ i: lua_Integer) {
        lua_pushinteger(state, i)
    }
    
    @inlinable
    @inline(__always)
    public func pushNumber(_ n: lua_Number) {
        lua_pushnumber(state, n)
    }
    
    @inlinable
    @inline(__always)
    public func pushString(_ s: String) {
        lua_pushstring(state, s)
    }
    
    @inlinable
    @inline(__always)
    public func pushLightUserData(_ p: UnsafeMutableRawPointer) {
        lua_pushlightuserdata(state, p)
    }
    
    /**
     * Allocates a new block of memory with the given size that can be used to store arbitrary C data.
     * - Parameter size: The size in bytes of the memory block to allocate
     * - Returns: A raw pointer to the allocated memory block
     */
    @inlinable
    @inline(__always)
    public func newUserData(size: Int) -> UnsafeMutableRawPointer {
        return self.newUserDataUV(size: size, nuValue: 1)
    }
    /**
     * Allocates a new block of memory with the given size and number of associated Lua values that can be used to store arbitrary C data.
     * - Parameter size: The size in bytes of the memory block to allocate
     * - Parameter nuValue: The number of associated Lua values (must be between 1 and 255)
     * - Returns: A raw pointer to the allocated memory block
     */
    @inlinable
    @inline(__always)
    public func newUserDataUV(size: Int, nuValue: Int32) -> UnsafeMutableRawPointer {
        return lua_newuserdatauv(state, size, nuValue)
    }
    
    @inlinable
    @inline(__always)
    public func pushThread() {
        lua_pushthread(state)
    }
    
    /// Creates and returns a reference, in the table at index t, for the object on the top of the stack (and pops the object).
    /// A reference is a unique integer key. As long as you do not manually add integer keys into the table t, luaL_ref ensures the uniqueness of the key it returns. You can retrieve an object referred by the reference r by calling lua_rawgeti(L, t, r). The function luaL_unref frees a reference.
    /// If the object on the top of the stack is nil, luaL_ref returns the constant LUA_REFNIL. The constant LUA_NOREF is guaranteed to be different from any reference returned by luaL_ref.
    @inlinable
    @inline(__always)
    public func ref(t: Int32 = LUA_REGISTRYINDEX) -> Int32 {
        return luaL_ref(state, t)
    }
    
    /// Releases the reference ref from the table at index t (see luaL_ref). The entry is removed from the table, so that the referred object can be collected. The reference ref is also freed to be used again.
    /// If ref is LUA_NOREF or LUA_REFNIL, luaL_unref does nothing.
    @inlinable
    @inline(__always)
    public func unref(t: Int32 = LUA_REGISTRYINDEX, ref: Int32) {
        luaL_unref(state, t, ref)
    }
    
    @inlinable
    @inline(__always)
    public func rawGetI(_ idx: Int32, n: lua_Integer) -> LuaType {
        return LuaType(rawValue: lua_rawgeti(state, idx, n))
    }
    
    @inlinable
    @inline(__always)
    public func close() {
        lua_close(state)
    }

    /// Compares two Lua values. Returns true if the value at index index1 satisfies op when compared with the value at index index2, following the semantics of the corresponding Lua operator (that is, it may call metamethods). Otherwise returns false. Also returns false if any of the indices is not valid.
    /// The value of op must be one of the following constants:
    /// LUA_OPEQ: compares for equality (==)
    /// LUA_OPLT: compares for less than (<)
    /// LUA_OPLE: compares for less or equal (<=)
    @inlinable
    @inline(__always)
    public func compare(idx1: Int32, idx2: Int32, op: Int32) -> Bool {
        return lua_compare(state, idx1, idx2, op) == 1
    }

    /// Concatenates the n values at the top of the stack, pops them, and leaves the result at the top. If n is 1, the result is the single value on the stack (that is, the function does nothing); if n is 0, the result is the empty string. Concatenation is performed following the usual semantics of Lua (see §3.4.6)
    @inlinable
    @inline(__always)
    public func concat(_ n: Int32) {
        lua_concat(state, n)
    }

    /// Copies the element at index fromidx into the valid index toidx, replacing the value at that position. Values at other positions are not affected.
    @inlinable
    @inline(__always)
    public func copy(fromidx: Int32, toidx: Int32) {
        lua_copy(state, fromidx, toidx)
    }

    /// Creates a new empty table and pushes it onto the stack. Parameter narr is a hint for how many elements the table will have as a sequence; parameter nrec is a hint for how many other elements the table will have. Lua may use these hints to preallocate memory for the new table. This preallocation is useful for performance when you know in advance how many elements the table will have. Otherwise you can use the function lua_newtable.
    @inlinable
    @inline(__always)
    public func createTable(narr: Int32, nrec: Int32) {
        lua_createtable(state, narr, nrec)
    }
    
    @inlinable
    @inline(__always)
    public func newTable() {
        lua_createtable(state, 0, 0)
    }

    /// Generates a Lua error, using the value at the top of the stack as the error object. This function does a long jump, and therefore never returns (see luaL_error).
    @inlinable
    @inline(__always)
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
    @inlinable
    @inline(__always)
    public func gc(what: Int32) -> Int32 {
        return lua_gc_non_varadic(state, what)
    }
    
    @inlinable
    @inline(__always)
    public func gc(what: Int32, data: Int32) -> Int32 {
        return lua_gc_non_varadic_with_data(state, what, data)
    }
    
    /// Pushes onto the stack the value t[k], where t is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4).
    /// Returns the type of the pushed value.
    @inlinable
    @inline(__always)
    public func getField(_ idx: Int32, key: String) -> LuaType {
        return LuaType(rawValue: lua_getfield(state, idx, key))
    }

    /// Returns a pointer to a raw memory area associated with the given Lua state. The application can use this area for any purpose; Lua does not use it for anything.
    /// Each new thread has this area initialized with a copy of the area of the main thread.
    /// By default, this area has the size of a pointer to void, but you can recompile Lua with a different size for this area. (See LUA_EXTRASPACE in luaconf.h.)
    @inlinable
    @inline(__always)
    public func getExtraSpace() -> UnsafeMutableRawPointer {
        return lua_getextraspace_function(state)
    }

    /// Pushes onto the stack the value of the global name.
    /// Returns the type of that value.
    @inlinable
    @inline(__always)
    public func getGlobal(_ name: String) -> LuaType {
        return LuaType(rawValue: lua_getglobal(state, name))
    }

    /// Pushes onto the stack the value t[i], where t is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4).
    /// Returns the type of the pushed value.
    @inlinable
    @inline(__always)
    public func getI(_ idx: Int32, i: Int64) -> LuaType {
        return LuaType(rawValue: lua_geti(state, idx, i))
    }
    
    /// Returns true when metatable was pushed to stack, and false when no metatable was found (and nothing was pushed to stack)
    @inlinable
    @inline(__always)
    public func getMetatable(_ idx: Int32 = -1) -> Bool {
        return lua_getmetatable(state, idx) == 1
    }
    
    /// Pops a table or nil from the stack and sets that value as the new metatable for the value at the given index. (nil means no metatable.)
    /// (For historical reasons, this function returns an bool, which now is always `true`.)
    @inlinable
    @inline(__always)
    @discardableResult
    public func setMetatable(_ idx: Int32) -> Bool {
        return lua_setmetatable(state, idx) == 1
    }
    
    
    /// Pushes onto the stack the metatable associated with the name tname in the registry (see luaL_newmetatable), or nil if there is no metatable associated with that name. Returns the type of the pushed value.
    @inlinable
    @inline(__always)
    @discardableResult
    public func getMetatable(typeName: String) -> LuaType {
        return getField(LUA_REGISTRYINDEX, key: typeName)
    }
    
    /// If the registry already has the key `tname`, returns `false`. Otherwise, creates a new table to be used as a metatable for userdata, adds to this new table the pair `__name = tname`, adds to the registry the pair `[tname] = new table`, and returns `true`.
    /// In both cases, the function pushes onto the stack the final value associated with `tname` in the registry.
    @inlinable
    @inline(__always)
    public func newMetatable(typeName: String) -> Bool {
        return luaL_newmetatable(state, typeName) == 1
    }

    /// Pushes onto the stack the value t[k], where t is the value at the given index and k is the value at the top of the stack.
    /// This function pops the key from the stack, pushing the resulting value in its place. As in Lua, this function may trigger a metamethod for the "index" event (see §2.4).
    /// Returns the type of the pushed value.
    @inlinable
    @inline(__always)
    public func getTable(_ idx: Int32, key: String) -> LuaType {
        return LuaType(rawValue: lua_gettable(state, idx))
    }

    /// Returns the index of the top element in the stack. Because indices start at 1, this result is equal to the number of elements in the stack; in particular, 0 means an empty stack.
    @inlinable
    @inline(__always)
    public func getTop() -> Int32 {
        return lua_gettop(state)
    }

    /// Accepts any index, or 0, and sets the stack top to this index. If the new top is larger than the old one, then the new elements are filled with nil. If index is 0, then all stack elements are removed.
    @inlinable
    @inline(__always)
    public func setTop(_ idx: Int32) {
        lua_settop(state, idx)
    }

    /// Pushes onto the stack the Lua value associated with the full userdata at the given index.
    /// Returns the type of the pushed value.
    @inlinable
    @inline(__always)
    public func getUserValue(_ idx: Int32 = -1) -> LuaType {
        return LuaType(rawValue: lua_getiuservalue(state , idx, 1))
    }

    /// Moves the top element into the given valid index, shifting up the elements above this index to open space.
    /// This function cannot be called with a pseudo-index, because a pseudo-index is not an actual stack position.
    @inlinable
    @inline(__always)
    public func insert(_ idx: Int32) {
        lua_rotate(state, idx, 1)
    }

    /// Returns the length of the value at the given index. It is equivalent to the '#' operator in Lua and may trigger a metamethod for the "length" event.
    /// The result is pushed on the stack.
    @inlinable
    @inline(__always)
    public func len(_ idx: Int32 = -1) {
        lua_len(state, idx)
    }

    /// Returns the status of the thread.
    /// The status can be LUA_OK for a normal thread, an error code if the thread finished the execution of a resume with an error, or LUA_YIELD if the thread is suspended.
    /// You can only call functions in threads with status LUA_OK. You can resume threads with status LUA_OK (to start a new coroutine) or LUA_YIELD (to resume a coroutine).
    @inlinable
    @inline(__always)
    public func status() -> LuaThreadStatus {
        return LuaThreadStatus(rawValue: lua_status(state))
    }

    /// Pops a key from the stack, and pushes a key–value pair from the table at the given index (the "next" pair after the given key). If there are no more elements in the table, then lua_next returns false (and pushes nothing).
    /// A typical traversal looks like this:

    ///     /* table is in the stack at index 't' */
    ///     lua_pushnil(L);  /* first key */
    ///     while (lua_next(L, t) != 0) {
    ///     /* uses 'key' (at index -2) and 'value' (at index -1) */
    ///     printf("%s - %s\n",
    ///             lua_typename(L, lua_type(L, -2)),
    ///             lua_typename(L, lua_type(L, -1)));
    ///     /* removes 'value'; keeps 'key' for next iteration */
    ///     lua_pop(L, 1);
    ///     }
    /// While traversing a table, do not call lua_tolstring directly on a key, unless you know that the key is actually a string. Recall that lua_tolstring may change the value at the given index; this confuses the next call to lua_next.
    @inlinable
    @inline(__always)
    public func next(_ idx: Int32) -> Bool {
        return lua_next(state, idx) != 0
    }

    /// Does the equivalent to t[k] = v, where t is the value at the given index and v is the value on the top of the stack.
    /// This function pops the value from the stack. As in Lua, this function may trigger a metamethod for the "newindex" event (see §2.4).
    @inlinable
    @inline(__always)
    public func setField(_ idx: Int32, key: String) {
        lua_setfield(state, idx, key)
    }

    /// Does the equivalent to t[n] = v, where t is the value at the given index and v is the value on the top of the stack.
    /// This function pops the value from the stack. As in Lua, this function may trigger a metamethod for the "newindex" event (see §2.4).
    @inlinable
    @inline(__always)
    public func setI(_ idx: Int32, i: Int64) {
        lua_seti(state, idx, i)
    }

    /// Does the equivalent to t[k] = v, where t is the value at the given index, v is the value on the top of the stack, and k is the value just below the top.
    /// This function pops both the key and the value from the stack. As in Lua, this function may trigger a metamethod for the "newindex" event (see §2.4).
    @inlinable
    @inline(__always)
    public func setTable(_ idx: Int32) {
        lua_settable(state, idx)
    }

    /// Pushes a C function onto the stack. This function receives a pointer to a C function and pushes onto the stack a Lua value of type function that, when called, invokes the corresponding C function.
    @inlinable
    @inline(__always)
    public func pushLuaCFunction(_ f: lua_CFunction ) {
        lua_pushcclosure(state, f, 0)
    }

    /// Pops a value from the stack and sets it as the new value of global name.
    @inlinable
    @inline(__always)
    public func setGlobal(_ name: String) {
        lua_setglobal(state, name)
    }

    /// Checks whether the function argument arg is a string and returns this string.
    /// This function uses lua_tolstring to get its result, so all conversions and caveats of that function apply here.
    @inlinable
    @inline(__always)
    public func checkString(_ arg: Int32) -> String {
        return checkLString(arg, l: nil)
    }

    /// Checks whether the function argument arg is a string and returns this string; if l is not NULL fills *l with the string's length.
    /// This function uses lua_tolstring to get its result, so all conversions and caveats of that function apply here.
    @inlinable
    @inline(__always)
    public func checkLString(_ arg: Int32, l: UnsafeMutablePointer<size_t>?) -> String {
        return String(cString: luaL_checklstring(state, arg, l))
    }
}

@inline(__always)
public let LUA_REGISTRYINDEX: Int32 = -LUAI_MAXSTACK - 1000

public struct LuaType: RawRepresentable, Sendable, Equatable {
    
    @inline(__always)
    public let rawValue: Int32
    
    @inlinable
    @inline(__always)
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    @inline(__always) public static let LUA_TNONE = LuaType(rawValue: CLua.LUA_TNONE)
    @inline(__always) public static let LUA_TNIL = LuaType(rawValue: CLua.LUA_TNIL)
    @inline(__always) public static let LUA_TBOOLEAN = LuaType(rawValue: CLua.LUA_TBOOLEAN)
    @inline(__always) public static let LUA_TLIGHTUSERDATA = LuaType(rawValue: CLua.LUA_TLIGHTUSERDATA)
    @inline(__always) public static let LUA_TNUMBER = LuaType(rawValue: CLua.LUA_TNUMBER)
    @inline(__always) public static let LUA_TSTRING = LuaType(rawValue: CLua.LUA_TSTRING)
    @inline(__always) public static let LUA_TTABLE = LuaType(rawValue: CLua.LUA_TTABLE)
    @inline(__always) public static let LUA_TFUNCTION = LuaType(rawValue: CLua.LUA_TFUNCTION)
    @inline(__always) public static let LUA_TUSERDATA = LuaType(rawValue: CLua.LUA_TUSERDATA)
    @inline(__always) public static let LUA_TTHREAD = LuaType(rawValue: CLua.LUA_TTHREAD)
    @inline(__always) public static let LUA_NUMTYPES = LuaType(rawValue: CLua.LUA_NUMTYPES)
}


public struct LuaThreadStatus: RawRepresentable, Sendable {
    @inline(__always)
    public let rawValue: Int32
    
    @inlinable
    @inline(__always)
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    @inline(__always) public static let LUA_OK = LuaThreadStatus(rawValue: CLua.LUA_OK)
    @inline(__always) public static let LUA_YIELD = LuaThreadStatus(rawValue: CLua.LUA_YIELD)
    @inline(__always) public static let LUA_ERRRUN = LuaThreadStatus(rawValue: CLua.LUA_ERRRUN)
    @inline(__always) public static let LUA_ERRSYNTAX = LuaThreadStatus(rawValue: CLua.LUA_ERRSYNTAX)
    @inline(__always) public static let LUA_ERRMEM = LuaThreadStatus(rawValue: CLua.LUA_ERRMEM)
    @inline(__always) public static let LUA_ERRERR = LuaThreadStatus(rawValue: CLua.LUA_ERRERR)
}


@inline(__always)
public let LUA_EXTRASPACE: Int = LUA_EXTRASPACE_SIZE()
