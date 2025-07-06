import Lua

/// A Swift struct which is exposed to Lua as either user data or light user data.
/// Should be a `struct`, not a class.
public protocol SwiftStructUserdata: Sendable {
    
    func __add(_ L: LuaState) -> Int32
    func __sub(_ L: LuaState) -> Int32
    func __mul(_ L: LuaState) -> Int32
    func __div(_ L: LuaState) -> Int32
    func __mod(_ L: LuaState) -> Int32
    func __pow(_ L: LuaState) -> Int32
    func __unm(_ L: LuaState) -> Int32
    func __idiv(_ L: LuaState) -> Int32
    func __band(_ L: LuaState) -> Int32
    func __bor(_ L: LuaState) -> Int32
    func __bxor(_ L: LuaState) -> Int32
    func __bnot(_ L: LuaState) -> Int32
    func __shl(_ L: LuaState) -> Int32
    func __shr(_ L: LuaState) -> Int32
    func __concat(_ L: LuaState) -> Int32
    func __len(_ L: LuaState) -> Int32
    func __eq(_ L: LuaState) -> Int32
    func __lt(_ L: LuaState) -> Int32
    func __le(_ L: LuaState) -> Int32
    func __index(_ L: LuaState) -> Int32
    func __newindex(_ L: LuaState) -> Int32
    func __call(_ L: LuaState) -> Int32
    func __gc(_ L: LuaState) -> Int32
    func __tostring(_ L: LuaState) -> Int32
    
}

extension SwiftStructUserdata {
    @usableFromInline
    internal init(fromPt pt: OpaquePointer) {
        self = UnsafePointer<Self>(pt).pointee
    }
    @usableFromInline
    internal static func destory(pt: OpaquePointer) {
        UnsafeMutablePointer<Self>(pt).deinitialize(count: 1)
    }
    public func __add(_ L: LuaState) -> Int32 { 0 }
    public func __sub(_ L: LuaState) -> Int32 { 0 }
    public func __mul(_ L: LuaState) -> Int32 { 0 }
    public func __div(_ L: LuaState) -> Int32 { 0 }
    public func __mod(_ L: LuaState) -> Int32 { 0 }
    public func __pow(_ L: LuaState) -> Int32 { 0 }
    public func __unm(_ L: LuaState) -> Int32 { 0 }
    public func __idiv(_ L: LuaState) -> Int32 { 0 }
    public func __band(_ L: LuaState) -> Int32 { 0 }
    public func __bor(_ L: LuaState) -> Int32 { 0 }
    public func __bxor(_ L: LuaState) -> Int32 { 0 }
    public func __bnot(_ L: LuaState) -> Int32 { 0 }
    public func __shl(_ L: LuaState) -> Int32 { 0 }
    public func __shr(_ L: LuaState) -> Int32 { 0 }
    public func __concat(_ L: LuaState) -> Int32 { 0 }
    public func __len(_ L: LuaState) -> Int32 { 0 }
    public func __eq(_ L: LuaState) -> Int32 { 0 }
    public func __lt(_ L: LuaState) -> Int32 { 0 }
    public func __le(_ L: LuaState) -> Int32 { 0 }
    public func __index(_ L: LuaState) -> Int32 { 0 }
    public func __newindex(_ L: LuaState) -> Int32 { 0 }
    public func __call(_ L: LuaState) -> Int32 { 0 }
    public func __gc(_ L: LuaState) -> Int32 { 0 }
    public func __tostring(_ L: LuaState) -> Int32 { 0 }
}


extension LuaState {
    
    @inlinable
    @inline(__always)
    public func new<T: SwiftStructUserdata>(_ instance: consuming T) -> UnsafeMutablePointer<T> {
        let wrapperPointer = self.newUserData(
            size: MemoryLayout<SwiftStructUserdataWrapper<T>>.size  // todo: figure out nuvalue param
        ).initializeMemory(
            as: SwiftStructUserdataWrapper<T>.self,
            to: SwiftStructUserdataWrapper(
                value: instance
            )
        )
        if self.newMetatable(typeName: "SwiftStructUserdataWrapper") {
            self.setField(-2, key: "__add", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__add(L)
            })
            self.setField(-2, key: "__sub", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__sub(L)
            })
            self.setField(-2, key: "__mul", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__mul(L)
            })
            self.setField(-2, key: "__div", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__div(L)
            })
            self.setField(-2, key: "__mod", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__mod(L)
            })
            self.setField(-2, key: "__pow", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__pow(L)
            })
            self.setField(-2, key: "__unm", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__unm(L)
            })
            self.setField(-2, key: "__idiv", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__idiv(L)
            })
            self.setField(-2, key: "__band", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__band(L)
            })
            self.setField(-2, key: "__bor", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__bor(L)
            })
            self.setField(-2, key: "__bxor", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__bxor(L)
            })
            self.setField(-2, key: "__bnot", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__bnot(L)
            })
            self.setField(-2, key: "__shl", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__shl(L)
            })
            self.setField(-2, key: "__shr", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__shr(L)
            })
            self.setField(-2, key: "__concat", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__concat(L)
            })
            self.setField(-2, key: "__len", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__len(L)
            })
            self.setField(-2, key: "__eq", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__eq(L)
            })
            self.setField(-2, key: "__lt", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__lt(L)
            })
            self.setField(-2, key: "__le", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__le(L)
            })
            self.setField(-2, key: "__index", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__index(L)
            })
            self.setField(-2, key: "__newindex", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__newindex(L)
            })
            self.setField(-2, key: "__call", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__call(L)
            })
            self.setField(-2, key: "__gc", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                let res = wrappedInstance.__gc(L)
                if let wrapperPt = L.toUserData() {
                    let typePt = UnsafePointer<SwiftStructUserdata.Type>(OpaquePointer(wrapperPt))
                    let theType = typePt.pointee
                    theType.destory(pt: OpaquePointer(wrapperPt.advanced(by: MemoryLayout<SwiftStructUserdata.Type>.size)))
                } else {
                    assertionFailure()
                }
                return res
            })
            self.setField(-2, key: "__tostring", cFunction: { L in
                guard let wrappedInstance = getUserDataInstance(L: L) else { return 0 }
                return wrappedInstance.__tostring(L)
            })
        }
        self.setMetatable(-2)
        return withUnsafeMutablePointer(to: &wrapperPointer.pointee.value) { $0 }
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

@usableFromInline
func getUserDataInstance(L: LuaState) -> SwiftStructUserdata? {
    guard let wrapperPt = L.toUserData() else { return nil }
    return UnsafePointer<SwiftStructUserdata.Type>(OpaquePointer(wrapperPt))
        .pointee
        .init(
            fromPt: OpaquePointer(
                wrapperPt
                    .advanced(
                        by: MemoryLayout<SwiftStructUserdata.Type>.size
                    )
            )
        )
}
