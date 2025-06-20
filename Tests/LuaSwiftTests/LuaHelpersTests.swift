import Testing
import Lua
import LuaHelpers

@Test func simpleRefWithHelper() {
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
    let pushedType = L.rawGetIRegistryIndex(ref: Int64(ref))
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

@Test func simpleValueExtraction() {
    let L = LuaState.newLuaState()
    L.pushString("hello")
    L.toAnyValue(-1)
    L.close()
}
