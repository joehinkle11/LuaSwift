import Lua

/// A value held inside a Lua VM. Call `.copyToSwift()` to decouple from the Lua VM.
public struct LuaValue: ~Copyable {
    
    @usableFromInline
    let unsafeLuaValue: UnsafeLuaValue
    
    @usableFromInline
    init(unsafeLuaValue: UnsafeLuaValue) {
        self.unsafeLuaValue = unsafeLuaValue
    }
    
    @inlinable
    @inline(__always)
    public consuming func toUnsafeValue() -> UnsafeLuaValue {
        let res = unsafeLuaValue
        discard self
        return res
    }

    @inlinable
    @inline(__always)
    public var isNil: Bool {
        return unsafeLuaValue.isNil
    }
    
    @inlinable
    @inline(__always)
    public var asBool: Bool? {
        return unsafeLuaValue.asBool
    }
    
    @inlinable
    @inline(__always)
    public var asNumber: LuaNumber? {
        return unsafeLuaValue.asNumber
    }
    
    @inlinable
    @inline(__always)
    public consuming func asString() -> LuaString? {
        if let string = unsafeLuaValue.asString() {
            discard self
            return LuaString(unsafeLuaString: string)
        }
        discard self
        return nil
    }
    
    @inlinable
    @inline(__always)
    public func asLightUserData<T>(type: T.Type = T.self) -> UnsafeMutablePointer<T>? {
        return unsafeLuaValue.asLightUserData(type: type)
    }
    
    @inlinable
    @inline(__always)
    public consuming func asUserData() -> LuaUserData? {
        if let ud = unsafeLuaValue.asUserData() {
            discard self
            return LuaUserData(unsafeLuaUserData: ud)
        }
        discard self
        return nil
    }
    
    @inlinable
    @inline(__always)
    public consuming func asTable() -> LuaTable? {
        if let ref = unsafeLuaValue.asTable() {
            discard self
            return LuaTable(unsafeLuaTable: ref)
        }
        discard self
        return nil
    }
    

    @inlinable
    @inline(__always)
    public static var luaNone: LuaValue {
        return LuaValue(unsafeLuaValue: .luaNone)
    }
    
    @inlinable
    @inline(__always)
    public static var luaNil: LuaValue {
        return LuaValue(unsafeLuaValue: .luaNil)
    }
        
    @inlinable
    @inline(__always)
    public static func bool(_ bool: Bool) -> LuaValue {
        return LuaValue(unsafeLuaValue: .bool(bool))
    }

    @inlinable
    @inline(__always)
    public static func number(_ number: LuaNumber) -> LuaValue {
        return LuaValue(unsafeLuaValue: .number(number))
    }

    @inlinable
    @inline(__always)
    public static func string(_ string: UnsafeLuaRef) -> LuaValue {
        return LuaValue(unsafeLuaValue: .string(string))
    }

    @inlinable
    @inline(__always)
    public static func lightUserData(_ lightUserData: UnsafeMutableRawPointer) -> LuaValue {
        return LuaValue(unsafeLuaValue: .lightUserData(lightUserData))
    }

    @inlinable
    @inline(__always)
    public static func table(_ table: UnsafeLuaRef) -> LuaValue {
        return LuaValue(unsafeLuaValue: .table(table))
    }
    
    
    @inlinable
    @inline(__always)
    public static func function(_ function: UnsafeLuaRef) -> LuaValue {
        return LuaValue(unsafeLuaValue: .function(function))
    }
    
    @inlinable
    @inline(__always)
    public static func userData(_ userData: UnsafeLuaRef) -> LuaValue {
        return LuaValue(unsafeLuaValue: .userData(userData))
    }
    
    @inlinable
    @inline(__always)
    public static func thread(_ thread: UnsafeLuaRef) -> LuaValue {
        return LuaValue(unsafeLuaValue: .thread(thread))
    }
    
    @inlinable
    @inline(__always)
    public func copyToSwift() -> Value? {
        switch self.unsafeLuaValue {
        case .luaNone:
            return nil
        case .luaNil:
            return .luaNil
        case .userData, .thread, .function:
            // not supported
            return nil
        case .table(let ref):
            let safeTable = LuaTable(unsafeLuaTable: ref)
            let result = Value.table(safeTable.copyToSwift())
            safeTable.discardWithoutUnref()
            return result
        case .string(let ref):
            let safeString = LuaString(unsafeLuaString: ref)
            let result = Value.string(safeString.copyToSwift())
            safeString.discardWithoutUnref()
            return result
        case .lightUserData(let lightUserData):
            return .lightUserData(lightUserData)
        case .bool(let bool):
            return .bool(bool)
        case .number(let number):
            return .number(number)
        }
    }
    
    deinit {
        unsafeLuaValue.unref()
    }
}

/// A string held inside a Lua VM. Call `.copyToSwift()` to decouple from the Lua VM.
public struct LuaString: ~Copyable {
    @usableFromInline
    let unsafeLuaString: UnsafeLuaRef
    
    @usableFromInline
    init(unsafeLuaString: UnsafeLuaRef) {
        self.unsafeLuaString = unsafeLuaString
    }
    
    
    @inlinable
    @inline(__always)
    public consuming func toUnsafeValue() -> UnsafeLuaRef {
        let res = unsafeLuaString
        discard self
        return res
    }
    
    
    @inlinable
    @inline(__always)
    public borrowing func copyToSwift() -> String {
        let type = unsafeLuaString.luaState.pushRef(unsafeLuaString.ref)
        if type != .LUA_TSTRING {
            assertionFailure()
            unsafeLuaString.luaState.pop()
            return ""
        }
        let res = unsafeLuaString.luaState.toString(unsafeLuaString.luaState.getTop()) ?? ""
        unsafeLuaString.luaState.pop()
        return res
    }
    
    public consuming func discardWithoutUnref() {
        discard self
    }
    
    deinit {
        unsafeLuaString.unref()
    }
}


/// A table held inside a Lua VM. Call `.copyToSwift()` to decouple from the Lua VM.
public struct LuaTable: ~Copyable {
    @usableFromInline
    let unsafeLuaTable: UnsafeLuaRef
    
    @usableFromInline
    init(unsafeLuaTable: UnsafeLuaRef) {
        self.unsafeLuaTable = unsafeLuaTable
    }
    
    
    @inlinable
    @inline(__always)
    public consuming func toUnsafeValue() -> UnsafeLuaRef {
        let res = unsafeLuaTable
        discard self
        return res
    }
    
    @inlinable
    @inline(__always)
    public func copyToSwift() -> Table {
        return Table(luaTable: self)
    }
    
    /// Iterate over the table.
    ///
    /// - Parameter block: A block that will be called with each key–value pair in the table. Return true to continue iterating, false to stop.
    @inlinable
    @inline(__always)
    public borrowing func forEach(block: (borrowing Next) -> Bool) {
        let type = unsafeLuaTable.luaState.pushRef(unsafeLuaTable.ref)
        if type != .LUA_TTABLE {
            assertionFailure()
            unsafeLuaTable.luaState.pop()
            return
        }
        unsafeLuaTable.luaState.pushNil()
        assert(unsafeLuaTable.luaState.type(-2) == .LUA_TTABLE)
        while (unsafeLuaTable.luaState.next(-2)) {
            let key = unsafeLuaTable.luaState.toLuaValue(-2)
            let value = unsafeLuaTable.luaState.toLuaValue(-1)
            let shouldContinue = block(Next(key: key, value: value))
            if shouldContinue {
                unsafeLuaTable.luaState.pop()
            } else {
                unsafeLuaTable.luaState.pop(2)
                break
            }
        }
        unsafeLuaTable.luaState.pop()
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
    
    
    public consuming func discardWithoutUnref() {
        discard self
    }
    
    deinit {
        unsafeLuaTable.unref()
    }
}

extension LuaState {
    @inlinable
    public func pushLuaFunction(_ function: borrowing LuaFunction) {
        self.pushRef(function.unsafeLuaFunction.ref)
    }
    @inlinable
    public func pushLuaTable(_ closure: borrowing LuaTable) {
        self.pushRef(closure.unsafeLuaTable.ref)
    }
    @inlinable
    public func pushLuaString(_ closure: borrowing LuaString) {
        self.pushRef(closure.unsafeLuaString.ref)
    }
    @inlinable
    public func toLuaValue(_ idx: Int32 = -1) -> LuaValue {
        switch self.typeEnum(idx) {
        case .NONE:
            return .luaNone
        case .NIL:
            return .luaNil
        case .BOOLEAN:
            return .bool(toBoolean(idx))
        case .LIGHTUSERDATA:
            if let lightUserData = toLightUserData(idx) {
                return .lightUserData(lightUserData)
            }
            return .luaNil
        case .NUMBER:
            if let int = self.toInteger(idx) {
                return .number(.int(int))
            } else if let double = self.toNumber(idx) {
                return .number(.double(double))
            } else {
                return .number(.int(0))
            }
        case .STRING:
            return .string(UnsafeLuaRef(luaState: self, idx: idx))
        case .TABLE:
            return .table(UnsafeLuaRef(luaState: self, idx: idx))
        case .FUNCTION:
            return .function(UnsafeLuaRef(luaState: self, idx: idx))
        case .USERDATA:
            return .userData(UnsafeLuaRef(luaState: self, idx: idx))
        case .THREAD:
            return .thread(UnsafeLuaRef(luaState: self, idx: idx))
        }
    }
}


/// A closure held inside a Lua VM. Call `.copyToSwift()` to decouple from the Lua VM.
public struct LuaFunction: ~Copyable {
    @usableFromInline
    let unsafeLuaFunction: UnsafeLuaRef
    
    @usableFromInline
    init(unsafeLuaFunction: UnsafeLuaRef) {
        self.unsafeLuaFunction = unsafeLuaFunction
    }
    
    
    @inlinable
    @inline(__always)
    public consuming func toUnsafeValue() -> UnsafeLuaRef {
        let res = unsafeLuaFunction
        discard self
        return res
    }
    
    
    @inlinable
    @inline(__always)
    public borrowing func copyToSwift() -> String {
        fatalError("todo copy to swift as a closure")
//        let type = unsafeLuaClosure.luaState.pushRef(unsafeLuaClosure.ref)
//        if type != .LUA_TFUNCTION {
//            assertionFailure()
//            unsafeLuaClosure.luaState.pop()
//            return ""
//        }
//        let res = unsafeLuaClosure.luaState.toString(unsafeLuaClosure.luaState.getTop()) ?? ""
//        unsafeLuaClosure.luaState.pop()
//        return res
    }
    
    public consuming func discardWithoutUnref() {
        discard self
    }
    
    deinit {
        unsafeLuaFunction.unref()
    }
}


/// User data held inside a Lua VM.
public struct LuaUserData: ~Copyable {
    
    @usableFromInline
    let unsafeLuaUserData: UnsafeLuaRef
    
    @usableFromInline
    init(unsafeLuaUserData: UnsafeLuaRef) {
        self.unsafeLuaUserData = unsafeLuaUserData
    }
    
    
    @inlinable
    @inline(__always)
    public consuming func toUnsafeValue() -> UnsafeLuaRef {
        let res = unsafeLuaUserData
        discard self
        return res
    }
    
    @inlinable
    @inline(__always)
    public borrowing func getPointerTag() -> SwiftStructUserdata.Type? {
        let type = unsafeLuaUserData.luaState.pushRef(unsafeLuaUserData.ref)
        if type != .LUA_TUSERDATA {
            assertionFailure()
            unsafeLuaUserData.luaState.pop()
            return nil
        }
        return unsafeLuaUserData.luaState.toUserDataInstancePointerTag()
    }
    
    @inlinable
    @inline(__always)
    public borrowing func getInstancePointer<T: SwiftStructUserdata>(as: T.Type = T.self) -> UnsafeMutablePointer<T>? {
        let type = unsafeLuaUserData.luaState.pushRef(unsafeLuaUserData.ref)
        if type != .LUA_TUSERDATA {
            assertionFailure()
            unsafeLuaUserData.luaState.pop()
            return nil
        }
        return unsafeLuaUserData.luaState.toUserDataInstancePointer()
    }
    
    public consuming func discardWithoutUnref() {
        discard self
    }
    
    deinit {
        unsafeLuaUserData.unref()
    }
}
