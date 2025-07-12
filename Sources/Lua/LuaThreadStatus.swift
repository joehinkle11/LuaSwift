import CLua

public struct LuaThreadStatus: RawRepresentable, Sendable, Equatable {
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
