import CLua

@inline(__always)
public let LUA_REGISTRYINDEX: Int32 = -LUAI_MAXSTACK - 1000

@inline(__always)
public let LUA_EXTRASPACE: Int = LUA_EXTRASPACE_SIZE()
