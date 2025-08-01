import Testing
import Foundation
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

@Test func simpleSuspendCoroutine() {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    L.pushCFunction { L in
        L.pushString("hello")
        L.yield(nresults: 1)
    }
    L.setGlobal("c_func")
    let co = L.newThread()
    #expect(L.getTop() == 1)
    let status = co.loadBufferX(buffer: #"c_func()"#, name: "hello")
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    var nresults: Int32 = 0
    let result = co.resume(nargs: 0, nresults: &nresults)
    #expect(co.getTop() == 1)
    #expect(L.getTop() == 1)
    #expect(result == .LUA_YIELD)
    #expect(nresults == 1)
    #expect(co.toString() == "hello")
    co.pop(1)
    #expect(L.getTop() == 1)
    #expect(co.getTop() == 0)
    L.close()
}

@Test func simpleSuspendCoroutine2() {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    L.pushCFunction { L in
        L.pushString("first")
        L.yieldk(nresults: 1) { L, status, ctx in
            #expect(status == .LUA_YIELD)
            L.pushString("second")
            L.yield(nresults: 1)
        }
    }
    L.setGlobal("c_func")
    let co = L.newThread()
    #expect(L.getTop() == 1)
    let status = co.loadBufferX(buffer: #"c_func();return 'done'"#, name: "hello")
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    var nresults: Int32 = 0
    var result = co.resume(nargs: 0, nresults: &nresults)
    #expect(co.getTop() == 1)
    #expect(L.getTop() == 1)
    #expect(result == .LUA_YIELD)
    #expect(nresults == 1)
    #expect(co.toString() == "first")
    co.pop(1)
    #expect(L.getTop() == 1)
    #expect(co.getTop() == 0)
    result = co.resume(nargs: 0, nresults: &nresults)
    #expect(co.getTop() == 1)
    #expect(L.getTop() == 1)
    #expect(result == .LUA_YIELD)
    #expect(nresults == 1)
    #expect(co.toString() == "second")
    co.pop(1)
    #expect(L.getTop() == 1)
    #expect(co.getTop() == 0)
    result = co.resume(nargs: 0, nresults: &nresults)
    #expect(co.getTop() == 1)
    #expect(L.getTop() == 1)
    #expect(result == .LUA_OK)
    #expect(nresults == 1)
    #expect(co.toString() == "done")
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

@Test func testNativeModule() async throws {
    let L = LuaState.newLuaState()
    
    L.openLibs()
    
    L.getGlobal("package")
    L.getField(-1, key: "preload")
    
    L.pushCFunction { L in
        L.newLib(reg: [
            .init(
                name: strdup("hello"),
                func: { L in
                    let L = LuaState(state: L)
                    L.pushString("world")
                    return 1
                }
            ),
            .init(name: nil, func: nil)
        ])
        return 1
    }
    L.setField(-2, key: "mymodule")
    L.pop(2)

    // You can now use `require("mymodule")` in Lua scripts
    L.doString("local m = require('mymodule'); return m.hello()")
    
    #expect(L.toString() == "world")
    
    L.close()
}
