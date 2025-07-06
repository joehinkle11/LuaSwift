import Lua

public enum LuaTypeEnum: Int32, CaseIterable {
    case NONE = -1
    case NIL = 0
    case BOOLEAN = 1
    case LIGHTUSERDATA = 2
    case NUMBER = 3
    case STRING = 4
    case TABLE = 5
    case FUNCTION = 6
    case USERDATA = 7
    case THREAD = 8
}


extension LuaState {
    @inlinable
    public func typeEnum(_ idx: Int32 = -1) -> LuaTypeEnum {
        switch self.type(idx) {
        case .LUA_TNIL: return .NIL
        case .LUA_TBOOLEAN: return .BOOLEAN
        case .LUA_TLIGHTUSERDATA: return .LIGHTUSERDATA
        case .LUA_TNUMBER: return .NUMBER
        case .LUA_TSTRING: return .STRING
        case .LUA_TTABLE: return .TABLE
        case .LUA_TFUNCTION: return .FUNCTION
        case .LUA_TUSERDATA: return .USERDATA
        case .LUA_TTHREAD: return .THREAD
        case .LUA_TNONE: fallthrough
        default: return .NONE
        }
    }
}
