import Lua

public let SwiftStructUserdataWrapperName = "SwiftStructUserdataWrapper"

/// A Swift struct which is exposed to Lua as either user data or light user data.
/// Should be a `struct`, not a class.
public protocol SwiftStructUserdata: Sendable {
    
    static func __add(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __add(_ L: LuaState) -> Int32
    static func __sub(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __sub(_ L: LuaState) -> Int32
    static func __mul(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __mul(_ L: LuaState) -> Int32
    static func __div(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __div(_ L: LuaState) -> Int32
    static func __mod(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __mod(_ L: LuaState) -> Int32
    static func __pow(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __pow(_ L: LuaState) -> Int32
    static func __unm(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __unm(_ L: LuaState) -> Int32
    static func __idiv(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __idiv(_ L: LuaState) -> Int32
    static func __band(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __band(_ L: LuaState) -> Int32
    static func __bor(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __bor(_ L: LuaState) -> Int32
    static func __bxor(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __bxor(_ L: LuaState) -> Int32
    static func __bnot(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __bnot(_ L: LuaState) -> Int32
    static func __shl(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __shl(_ L: LuaState) -> Int32
    static func __shr(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __shr(_ L: LuaState) -> Int32
    static func __concat(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __concat(_ L: LuaState) -> Int32
    static func __len(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __len(_ L: LuaState) -> Int32
    static func __eq(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __eq(_ L: LuaState) -> Int32
    static func __lt(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __lt(_ L: LuaState) -> Int32
    static func __le(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __le(_ L: LuaState) -> Int32
    static func __index(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __index(_ L: LuaState) -> Int32
    static func __newindex(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __newindex(_ L: LuaState) -> Int32
    static func __call(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __call(_ L: LuaState) -> Int32
    static func __gc(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __gc(_ L: LuaState) -> Int32
    static func __tostring(self: OpaquePointer, _ L: LuaState) -> Int32
    mutating func __tostring(_ L: LuaState) -> Int32
    
}

extension SwiftStructUserdata {
    @inline(__always)
    public static func pt(from pt: OpaquePointer) -> UnsafeMutablePointer<any SwiftStructUserdata> {
        return UnsafeMutablePointer<any SwiftStructUserdata>(pt)
    }
    @usableFromInline
    internal static func destory(pt: OpaquePointer) {
        UnsafeMutablePointer<Self>(pt).deinitialize(count: 1)
    }
    @inline(__always)
    public static func __add(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__add(L) }
    public func __add(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __sub(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__sub(L) }
    public func __sub(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __mul(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__mul(L) }
    public func __mul(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __div(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__div(L) }
    public func __div(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __mod(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__mod(L) }
    public func __mod(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __pow(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__pow(L) }
    public func __pow(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __unm(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__unm(L) }
    public func __unm(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __idiv(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__idiv(L) }
    public func __idiv(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __band(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__band(L) }
    public func __band(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __bor(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__bor(L) }
    public func __bor(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __bxor(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__bxor(L) }
    public func __bxor(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __bnot(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__bnot(L) }
    public func __bnot(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __shl(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__shl(L) }
    public func __shl(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __shr(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__shr(L) }
    public func __shr(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __concat(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__concat(L) }
    public func __concat(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __len(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__len(L) }
    public func __len(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __eq(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__eq(L) }
    public func __eq(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __lt(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__lt(L) }
    public func __lt(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __le(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__le(L) }
    public func __le(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __index(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__index(L) }
    public func __index(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __newindex(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__newindex(L) }
    public func __newindex(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __call(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__call(L) }
    public func __call(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __gc(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__gc(L) }
    public func __gc(_ L: LuaState) -> Int32 { 0 }
    @inline(__always)
    public static func __tostring(self: OpaquePointer, _ L: LuaState) -> Int32 { UnsafeMutablePointer<Self>(self).pointee.__tostring(L) }
    public func __tostring(_ L: LuaState) -> Int32 { 0 }
}


extension LuaState {
    @inlinable
    @inline(__always)
    public func new<T: SwiftStructUserdata>(_ instance: consuming T) -> UnsafeMutablePointer<T> {
        let wrapperPointer = self.newUserData(
            size: MemoryLayout<SwiftStructUserdataWrapper<T>>.size
        ).initializeMemory(
            as: SwiftStructUserdataWrapper<T>.self,
            to: SwiftStructUserdataWrapper(
                value: instance
            )
        )
        if self.newMetatable(typeName: SwiftStructUserdataWrapperName) {
            // Binary operations - userdata at index -2
            self.setField(-2, key: "__add", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__add(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__sub", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__sub(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__mul", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__mul(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__div", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__div(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__mod", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__mod(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__pow", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__pow(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__idiv", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__idiv(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__band", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__band(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__bor", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__bor(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__bxor", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__bxor(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__shl", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__shl(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__shr", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__shr(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__concat", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__concat(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__eq", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__eq(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__lt", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__lt(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__le", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__le(self: wrappedInstance.value, L)
            })
            
            // Unary operations - userdata at index -1
            self.setField(-2, key: "__unm", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -1) else { return 0 }
                return wrappedInstance.tag.__unm(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__bnot", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -1) else { return 0 }
                return wrappedInstance.tag.__bnot(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__len", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -1) else { return 0 }
                return wrappedInstance.tag.__len(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__tostring", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -1) else { return 0 }
                return wrappedInstance.tag.__tostring(self: wrappedInstance.value, L)
            })
            
            // Index operations - userdata at index -2 for __index, -3 for __newindex
            self.setField(-2, key: "__index", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -2) else { return 0 }
                return wrappedInstance.tag.__index(self: wrappedInstance.value, L)
            })
            self.setField(-2, key: "__newindex", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -3) else { return 0 }
                return wrappedInstance.tag.__newindex(self: wrappedInstance.value, L)
            })
            
            // Call operation - userdata at index -1
            self.setField(-2, key: "__call", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: 1) else { return 0 }
                return wrappedInstance.tag.__call(self: wrappedInstance.value, L)
            })
            
            // GC operation - userdata at index -1
            self.setField(-2, key: "__gc", cFunction: { L in
                guard let wrappedInstance = L.getUserDataInstance(index: -1) else { return 0 }
                let res = wrappedInstance.tag.__gc(self: wrappedInstance.value, L)
                if let wrapperPt = L.toUserData(-1) {
                    let typePt = UnsafePointer<SwiftStructUserdata.Type>(OpaquePointer(wrapperPt))
                    let theType = typePt.pointee
                    theType.destory(pt: OpaquePointer(wrapperPt.advanced(by: MemoryLayout<SwiftStructUserdata.Type>.size)))
                } else {
                    assertionFailure()
                }
                return res
            })
        }
        self.setMetatable(-2)
        return withUnsafeMutablePointer(to: &wrapperPointer.pointee.value) { $0 }
    }
    
    @usableFromInline
    func getUserDataInstance(index: Int32 = -1) -> SwiftStructUserdataWrapperErased? {
        guard let wrapperPt = self.toUserData(index) else { return nil }
        return SwiftStructUserdataWrapperErased(wrapperPt)
    }
    
    @inlinable
    public func toUserDataInstancePointer<T: SwiftStructUserdata>(index: Int32 = -1, as: T.Type = T.self) -> UnsafeMutablePointer<T>? {
        guard let wrapperErased = getUserDataInstance(index: index) else { return nil }
        guard wrapperErased.tag == T.self else { return nil }
        return UnsafeMutablePointer(wrapperErased.value)
    }
}

@usableFromInline
struct SwiftStructUserdataWrapperErased {
    @usableFromInline
    let tag: SwiftStructUserdata.Type
    @usableFromInline
    let value: OpaquePointer
    
    @inlinable
    init(_ wrapperPt: UnsafeMutableRawPointer) {
        tag = UnsafePointer<any SwiftStructUserdata.Type>(OpaquePointer(wrapperPt)).pointee
        value = OpaquePointer(
            wrapperPt
                .advanced(
                    by: MemoryLayout<any SwiftStructUserdata.Type>.size
                )
        )
    }
}

@usableFromInline
struct SwiftStructUserdataWrapper<T: SwiftStructUserdata> {
    let tag: SwiftStructUserdata.Type
    @usableFromInline
    var value: T
    
    @usableFromInline
    init(value: T) {
        self.tag = T.self
        self.value = value
    }
}
