import Lua

/// A value held inside a Lua VM. Call `.copyToSwift()` to decouple from the Lua VM.
public enum LuaValue: ~Copyable, @unchecked Sendable {
    case luaNil
    case bool(Bool)
    case number(LuaNumber)
    case string(String)
    case table(LuaTable)
    case lightUserData(UnsafeMutableRawPointer)
    
    @inlinable
    public var isNil: Bool {
        switch self {
        case .luaNil:
            return true
        default:
            return false
        }
    }
    
    @inlinable
    public var asBool: Bool? {
        switch self {
        case .bool(let bool):
            return bool
        default:
            return nil
        }
    }
    
    @inlinable
    public var asNumber: LuaNumber? {
        switch self {
        case .number(let number):
            return number
        default:
            return nil
        }
    }
    
    @inlinable
    public var asString: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    @inlinable
    public func asLightUserData<T>(type: T.Type = T.self) -> UnsafeMutablePointer<T>? {
        switch self {
        case .lightUserData(let lightUserData):
            return lightUserData.assumingMemoryBound(to: T.self)
        default:
            return nil
        }
    }

    @inlinable
    public consuming func asTable() -> LuaTable? {
        switch consume self {
        case .table(let table):
            return table
        default:
            return nil
        }
    }
    
    @inlinable
    @inline(__always)
    public func copyToSwift() -> Value {
        switch self {
        case .table(let table):
            return .table(table.copyToSwift())
        case .lightUserData(let lightUserData):
            return .lightUserData(lightUserData)
        case .bool(let bool):
            return .bool(bool)
        case .number(let number):
            return .number(number)
        case .string(let string):
            return .string(string)
        case .luaNil:
            return .luaNil
        }
    }
}

public enum LuaNumber: Equatable, Sendable {
    case int(Int64)
    case double(Double)
    
    @inlinable
    @inline(__always)
    var int: Int? {
        if let int64 {
            return Int(exactly: int64)!
        }
        return nil
    }
    
    @inlinable
    @inline(__always)
    var int64: Int64? {
        switch self {
        case .int(let int):
            return int
        case .double:
            return nil
        }
    }
    
    @inlinable
    @inline(__always)
    var double: Double {
        switch self {
        case .int(let int):
            return Double(int)
        case .double(let double):
            return double
        }
    }
}

/// A table held inside a Lua VM. Call `.copyToSwift()` to decouple from the Lua VM.
public struct LuaTable: ~Copyable {
    
    @inline(__always)
    public let luaState: LuaState
    @inline(__always)
    public let ref: Int32
    
    @inlinable
    @inline(__always)
    public init(luaState: LuaState, idx: Int32 = -1) {
        self.luaState = luaState
        luaState.pushValue(copiedFromIdx: idx)
        self.ref = luaState.ref()
    }
    
    /// Iterate over the table.
    ///
    /// - Parameter block: A block that will be called with each key–value pair in the table. Return true to continue iterating, false to stop.
    @inlinable
    @inline(__always)
    public func forEach(block: (borrowing Next) -> Bool) {
        let type = luaState.pushRef(ref)
        if type != .LUA_TTABLE {
            assertionFailure()
            luaState.pop()
            return
        }
        luaState.pushNil()
        while (luaState.next(-2)) {
            let key = luaState.toLuaValue(-2) ?? .luaNil
            let value = luaState.toLuaValue(-1) ?? .luaNil
            let shouldContinue = block(Next(key: key, value: value))
            if shouldContinue {
                luaState.pop()
            } else {
                luaState.pop(2)
                break
            }
        }
    }
    
    public struct Next: ~Copyable {
        @inline(__always)
        public let key: LuaValue
        @inline(__always)
        public let value: LuaValue
        
        @inlinable
        @inline(__always)
        public init(key: consuming LuaValue, value: consuming LuaValue) {
            self.key = key
            self.value = value
        }
    }
    
    @inlinable
    @inline(__always)
    public func copyToSwift() -> Table {
        return Table(luaTable: self)
    }
    
    deinit {
        luaState.unref(ref: ref)
    }
}

extension LuaState {
    @inlinable
    public func toLuaValue(_ idx: Int32 = -1) -> LuaValue? {
        switch self.typeEnum(idx) {
        case .NONE:
            return nil
        case .NIL:
            return .luaNil
        case .BOOLEAN:
            return .bool(toBoolean(idx))
        case .LIGHTUSERDATA:
            if let lightUserData = toLightUserData(idx) {
                return .lightUserData(lightUserData)
            }
            return nil
        case .NUMBER:
            if let int = self.toInteger(idx) {
                return .number(.int(int))
            } else if let double = self.toNumber(idx) {
                return .number(.double(double))
            } else {
                return .number(.int(0))
            }
        case .STRING:
            if let string = self.toString(idx) {
                return .string(string)
            }
            return .string("")
        case .TABLE:
            return .table(LuaTable(luaState: self, idx: idx))
        case .FUNCTION:
            return nil
        case .USERDATA:
            return nil
        case .THREAD:
            return nil
        }
    }
}
