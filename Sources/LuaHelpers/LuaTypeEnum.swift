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

extension LuaType {
    public var stringName: String {
        switch self {
        case .LUA_TNONE: return "None"
        case .LUA_TNIL: return "Nil"
        case .LUA_TBOOLEAN: return "Boolean"
        case .LUA_TLIGHTUSERDATA: return "Light Userdata"
        case .LUA_TNUMBER: return "Number"
        case .LUA_TSTRING: return "String"
        case .LUA_TTABLE: return "Table"
        case .LUA_TFUNCTION: return "Function"
        case .LUA_TUSERDATA: return "Userdata"
        case .LUA_TTHREAD: return "Thread"
        case .LUA_NUMTYPES: return "Number Types"
        default: return "Unknown"
        }
    }
}

extension LuaTypeEnum {
    public var stringName: String {
        switch self {
        case .NONE: return "None"
        case .NIL: return "Nil" 
        case .BOOLEAN: return "Boolean"
        case .LIGHTUSERDATA: return "Light Userdata"
        case .NUMBER: return "Number"
        case .STRING: return "String"
        case .TABLE: return "Table"
        case .FUNCTION: return "Function"
        case .USERDATA: return "Userdata"
        case .THREAD: return "Thread"
        }
    }
}
