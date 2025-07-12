import CLua

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
