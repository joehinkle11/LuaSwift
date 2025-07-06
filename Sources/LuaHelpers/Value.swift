
/// A "Lua" value which is not associated with any Lua VM
public enum Value: ExpressibleByNilLiteral, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByBooleanLiteral, Equatable {
    
    case luaNil
    case bool(Bool)
    case number(LuaNumber)
    case string(String)
    case table(Table)
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
    public func asTable() -> Table? {
        switch self {
        case .table(let table):
            return table
        default:
            return nil
        }
    }
    
    
    public typealias StringLiteralType = String
    public typealias IntegerLiteralType = Int64
    public typealias FloatLiteralType = Double
    
    @inlinable
    @inline(__always)
    public init(nilLiteral: ()) {
        self = .luaNil
    }
    @inlinable
    @inline(__always)
    public init(integerLiteral value: Int64) {
        self = .number(.int(value))
    }
    @inlinable
    @inline(__always)
    public init(floatLiteral value: Double) {
        self = .number(.double(value))
    }
    @inlinable
    @inline(__always)
    public init(stringLiteral value: String) {
        self = .string(value)
    }
    @inlinable
    @inline(__always)
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .bool(value)
    }
    
    
    @inlinable
    @inline(__always)
    public static func == (lhs: Value, rhs: Value) -> Bool {
        switch (lhs, rhs) {
        case (.luaNil, .luaNil):
            return true
        case (.bool(let l), .bool(let r)):
            return l == r
        case (.number(let l), .number(let r)):
            return l == r
        case (.string(let l), .string(let r)):
            return l == r
        case (.table, .table):
            // equality not supported for tables without lua vm
            return false
        case (.lightUserData(let l), .lightUserData(let r)):
            return l == r
        default:
            return false
        }
    }
}

/// A "Lua" table which is not associated with any Lua VM
public struct Table: ExpressibleByDictionaryLiteral, ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = LuaHelpers.Value
    public enum Key: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByBooleanLiteral {
        public typealias IntegerLiteralType = Int64
        
        case dictKey(DictKey)
        case arrayKey(Int64)
        
        @inlinable
        @inline(__always)
        public init(stringLiteral value: String) {
            self = .dictKey(.string(value))
        }
        @inlinable
        @inline(__always)
        public init(integerLiteral value: Int64) {
            if value <= 0 {
                self = .dictKey(.nonIndexNumber(Double(value)))
            } else {
                self = .arrayKey(value)
            }
        }
        @inlinable
        @inline(__always)
        public init(floatLiteral value: Double) {
            self = .dictKey(.nonIndexNumber(value))
        }
        @inlinable
        @inline(__always)
        public init(booleanLiteral value: BooleanLiteralType) {
            self = .dictKey(.bool(value))
        }
        
        public enum DictKey: Hashable {
            case bool(Bool)
            case string(String)
            case nonIndexNumber(Double)
        }
    }
    public typealias Value = LuaHelpers.Value
    
    
    public var array: [Value]
    public var dictionary: [Key.DictKey: Value]
    
    @inlinable
    @inline(__always)
    public var narr: Int {
        array.count
    }
    
    @inlinable
    @inline(__always)
    public var nrec: Int {
        dictionary.count
    }
    
    @inlinable
    @inline(__always)
    public init() {
        dictionary = [:]
        array = []
    }
    
    @inlinable
    @inline(__always)
    public init(arrayLiteral elements: Value...) {
        self.init()
        for element in elements {
            self.array.append(element)
        }
    }
    
    @inlinable
    @inline(__always)
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        for (k, v) in elements {
            self[k] = v
        }
    }
    
    @inlinable
    @inline(__always)
    public subscript(key: Key) -> Value {
        get {
            switch key {
            case .dictKey(let dictKey):
                return dictionary[dictKey] ?? .luaNil
            case .arrayKey(let i):
                if i <= 0 {
                    return dictionary[.nonIndexNumber(Double(i))] ?? .luaNil
                }
                if i > array.count {
                    return .luaNil
                }
                return array[Int(i - 1)]
            }
        }
        mutating set {
            switch key {
            case .dictKey(let dictKey):
                dictionary[dictKey] = newValue
                return
            case .arrayKey(let i):
                if i <= 0 {
                    dictionary[.nonIndexNumber(Double(i))] = newValue
                    return
                } else {
                    var c = array.count
                    while i > c {
                        c += 1
                        array.append(.luaNil)
                    }
                    array[Int(i - 1)] = newValue
                }
            }
        }
    }
    
    @inlinable
    @inline(__always)
    public init(luaTable: borrowing LuaTable) {
        self.init()
        luaTable.forEach { next in
            let swiftKey = next.key.copyToSwift()
            let swiftValue = next.value.copyToSwift()
            switch swiftKey {
            case .luaNil:
                break
            case .bool(let bool):
                self[.dictKey(.bool(bool))] = swiftValue
            case .number(let luaNumber):
                switch luaNumber {
                case .int(let int):
                    if int > 0 {
                        self[.arrayKey(int)] = swiftValue
                    } else {
                        self[.dictKey(.nonIndexNumber(Double(int)))] = swiftValue
                    }
                case .double(let double):
                    self[.dictKey(.nonIndexNumber(double))] = swiftValue
                }
            case .string(let stringKey):
                self[.dictKey(.string(stringKey))] = swiftValue
            case .table(_):
                fatalError("todo")
            case .lightUserData(_):
                fatalError("todo")
            }
            return true
        }
    }
}
