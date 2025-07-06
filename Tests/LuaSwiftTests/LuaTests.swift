import Testing
import Lua

@Test func simpleReturnInCoroutine() {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    let co = L.newThread()
    #expect(L.getTop() == 1)
    let status = co.loadBufferX(buffer: #"coroutine.yield(101)"#, name: "hello")
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    var nresults: Int32 = 0
    let result = co.resume(nargs: 0, nresults: &nresults)
    #expect(co.getTop() == 1)
    #expect(L.getTop() == 1)
    #expect(result == .LUA_YIELD)
    #expect(nresults == 1)
    #expect(co.type(-1) == .LUA_TNUMBER)
    #expect(co.toNumber(-1) == 101.0)
    #expect(co.toInteger(-1) == 101)
    #expect(L.getTop() == 1)
    #expect(co.getTop() == 1)
    co.pop(1)
    #expect(L.getTop() == 1)
    #expect(co.getTop() == 0)
    #expect(co.toNumber(-1) == nil)
    #expect(co.toInteger(-1) == nil)
    L.close()
}

@Test func simpleNoCall() {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    let status = L.loadBufferX(buffer: #"return "asdf""#, name: "hello")
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TFUNCTION)
    L.pop(1)
    #expect(L.getTop() == 0)
    L.close()
}

@Test func simpleReturnString() {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    var status = L.loadBufferX(buffer: #"return "asdf""#, name: "hello")
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TFUNCTION)
    status = L.pcall(nargs: 0)
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TSTRING)
    #expect(L.toString(-1) == "asdf")
    L.pop(1)
    #expect(L.getTop() == 0)
    L.close()
}

@Test func simpleRef() {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    var status = L.loadBufferX(buffer: #"return "was_in_a_ref""#, name: "hello")
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TFUNCTION)
    let ref = L.ref()
    #expect(ref == 4)
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    let pushedType = L.rawGetI(LUA_REGISTRYINDEX, n: Int64(ref))
    #expect(pushedType == .LUA_TFUNCTION)
    status = L.pcall(nargs: 0)
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TSTRING)
    #expect(L.toString(-1) == "was_in_a_ref")
    L.pop(1)
    #expect(L.getTop() == 0)
    L.close()
}


@Test func testExtraSpace() {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    L.getExtraSpace().assumingMemoryBound(to: Int.self).pointee = 45
    #expect(L.getExtraSpace().assumingMemoryBound(to: Int.self).pointee == 45)
    #expect(LUA_EXTRASPACE == MemoryLayout<UnsafeRawPointer>.size)
    L.close()
}



@Test func simpleUserData() throws {
    let L = LuaState.newLuaState()
    let userData = L.newUserData(size: 1)
    #expect(userData.assumingMemoryBound(to: UInt8.self).pointee == 0)
    userData.assumingMemoryBound(to: UInt8.self).pointee = 5
    let userData2 = try #require(L.toUserData())
    #expect(userData2.assumingMemoryBound(to: UInt8.self).pointee == 5)
    userData.assumingMemoryBound(to: UInt8.self).pointee = 15
    #expect(userData2.assumingMemoryBound(to: UInt8.self).pointee == 15)
    #expect(userData.assumingMemoryBound(to: UInt8.self).pointee == 15)
    L.close()
}



@Test func simpleLuaCFunc() throws {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    L.pushLuaCFunction { statePt in
        let state = LuaState(state: statePt)
        state.pushString("asdf")
        return 1
    }
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TFUNCTION)
    L.setGlobal("myFunc")
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    var status = L.loadBufferX(buffer: #"return myFunc()"#, name: "hello")
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TFUNCTION)
    status = L.pcall(nargs: 0)
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TSTRING)
    #expect(L.toString(-1) == "asdf")
    L.pop(1)
    #expect(L.getTop() == 0)
    L.close()
}
