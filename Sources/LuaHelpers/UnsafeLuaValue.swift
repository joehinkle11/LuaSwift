
import Lua

/// A value held inside a Lua VM. You must call `deinit` or a memory leak will occur.
public enum UnsafeLuaValue: @unchecked Sendable {
    case luaNone
    case luaNil
    case bool(Bool)
    case number(LuaNumber)
    case string(UnsafeLuaRef)
    case table(UnsafeLuaRef)
    case function(UnsafeLuaRef)
    case userData(UnsafeLuaRef)
    case thread(UnsafeLuaRef)
    case lightUserData(UnsafeMutableRawPointer)
    
    
    @inlinable
    @inline(__always)
    public func safeValue() -> LuaValue {
        return LuaValue(unsafeLuaValue: self)
    }
    
    @inlinable
    @inline(__always)
    public func copy() -> UnsafeLuaValue {
        switch self {
        case .luaNone:
            return .luaNone
        case .luaNil:
            return .luaNil
        case .bool(let bool):
            return .bool(bool)
        case .number(let luaNumber):
            return .number(luaNumber)
        case .lightUserData(let unsafeMutableRawPointer):
            return .lightUserData(unsafeMutableRawPointer)
        case .string(let unsafeLuaRef):
            return .string(unsafeLuaRef.copy())
        case .table(let unsafeLuaRef):
            return .table(unsafeLuaRef.copy())
        case .function(let unsafeLuaRef):
            return .function(unsafeLuaRef.copy())
        case .userData(let unsafeLuaRef):
            return .userData(unsafeLuaRef.copy())
        case .thread(let unsafeLuaRef):
            return .thread(unsafeLuaRef.copy())
        }
    }
    
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
    public func asString() -> UnsafeLuaRef? {
        switch self {
        case .string(let ref):
            return ref
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
    public func asTable() -> UnsafeLuaRef? {
        switch self {
        case .table(let ref):
            return ref
        default:
            return nil
        }
    }
    
    @inlinable
    public func asUserData() -> UnsafeLuaRef? {
        switch self {
        case .userData(let ref):
            return ref
        default:
            return nil
        }
    }
    
    
    @inlinable
    @inline(__always)
    public func unref(){
        switch self {
        case .luaNone, .luaNil, .bool, .number, .lightUserData:
            break
        case .table(let ref), .string(let ref), .function(let ref), .userData(let ref), .thread(let ref):
            ref.unref()
        }
    }
}

public enum LuaNumber: Equatable, Sendable {
    case int(Int64)
    case double(Double)
    
    @inlinable
    @inline(__always)
    public var int: Int? {
        if let int64 {
            return Int(exactly: int64)!
        }
        return nil
    }
    
    @inlinable
    @inline(__always)
    public var int64: Int64? {
        switch self {
        case .int(let int):
            return int
        case .double:
            return nil
        }
    }
    
    @inlinable
    @inline(__always)
    public var double: Double {
        switch self {
        case .int(let int):
            return Double(int)
        case .double(let double):
            return double
        }
    }
}

/// A value held inside a Lua VM. Call `.copyToSwift()` to decouple from the Lua VM. Must call `unref` or a memory leak will happen.
public struct UnsafeLuaRef: Sendable {
    
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
    
    @inlinable
    @inline(__always)
    init(luaState: LuaState, ref: Int32) {
        self.luaState = luaState
        self.ref = ref
    }
    
    @inlinable
    @inline(__always)
    public func copy() -> UnsafeLuaRef {
        _ = luaState.rawGetIRegistryIndex(ref: Int64(ref))
        return Self.init(
            luaState: luaState,
            ref: luaState.ref()
        )
    }
    
    @inlinable
    @inline(__always)
    public func unref() {
        luaState.unref(ref: ref)
    }
}

