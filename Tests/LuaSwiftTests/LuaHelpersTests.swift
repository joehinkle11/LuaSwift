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
    let val = L.toLuaValue()
    #expect(val?.asString == "hello")
    L.close()
}

@Test func simpleLightUserDataExtraction() {
    let L = LuaState.newLuaState()
    let pt = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    pt.pointee = 42
    L.pushLightUserData(pt)
    let val = L.toLuaValue()
    #expect(val?.asLightUserData(type: Int.self)?.pointee == 42)
    pt.pointee = 43
    #expect(val?.asLightUserData(type: Int.self)?.pointee == 43)
    pt.deallocate()
    L.close()
}

@Test func simpleTable() throws {
    let L = LuaState.newLuaState()
    let emptyTable: Table = [:]
    L.pushTable(emptyTable)
    let val = L.toLuaValue()
    let copiedTbl: Table = try #require(try val?.asTable()?.copyToSwift())
    #expect(copiedTbl.dictionary.isEmpty)
    L.close()
}

@Test func simpleTable2() throws {
    let L = LuaState.newLuaState()
    let origTable: Table = [
        "hello" : "world",
        "true" : "string_true",
        "false" : "string_false",
        true : "bool_true",
        false : "bool_false",
        1: "int_1",
        2: "int_2",
        3: "int_3",
        0: "int_0",
        0.0: "int_0.0",
        1.5: "int_1.5",
    ]
    L.pushTable(origTable)
    let val = L.toLuaValue()
    let copiedTbl: Table = try #require(try val?.asTable()?.copyToSwift())
    #expect(copiedTbl.dictionary.count == origTable.dictionary.count)
    #expect(copiedTbl.array.count == origTable.array.count)
    #expect(copiedTbl.dictionary[.bool(true)] == .string("bool_true"))
    #expect(copiedTbl[true] == "bool_true")
    #expect(copiedTbl.dictionary[.string("true")] == .string("string_true"))
    #expect(copiedTbl["true"] == "string_true")
    #expect(copiedTbl[0] == "int_0.0")
    #expect(copiedTbl[1] == "int_1")
    #expect(copiedTbl[1.5] == "int_1.5")
    #expect(copiedTbl.array[0] == "int_1")
    #expect(copiedTbl.dictionary[.nonIndexNumber(0)] == "int_0.0")
    #expect(copiedTbl.dictionary[.nonIndexNumber(1)] == nil)
    #expect(copiedTbl.dictionary[.nonIndexNumber(1.5)] == "int_1.5")
    L.close()
}


@Test func simpleSwiftStructUserdataAsUserData() throws {
    struct MyStruct: SwiftStructUserdata {
        var val1: Int = 1
    }
    let L = LuaState.newLuaState()
    let myStruct = L.new(MyStruct())
    #expect(myStruct.pointee.val1 == 1)
    myStruct.pointee.val1 = 5
    #expect(myStruct.pointee.val1 == 5)
    L.close()
}

@Test func simpleSwiftStructUserdataAsUserData2() throws {
    struct MyStruct: SwiftStructUserdata {
        static nonisolated(unsafe) var didGC = false
        var val1: Int
        init() {
            self.val1 = 90
        }
        func __gc(_ L: LuaState) -> Int32 {
            Self.didGC = true
            return 0
        }
    }
    let L = LuaState.newLuaState()
    let myStruct = L.new(MyStruct())
    #expect(MyStruct.didGC == false)
    #expect(myStruct.pointee.val1 == 90)
    myStruct.pointee.val1 = 5
    #expect(myStruct.pointee.val1 == 5)
    #expect(MyStruct.didGC == false)
    L.close()
    #expect(MyStruct.didGC == true)
}

@Test func simpleSwiftStructUserdataAsUserData3() throws {
    struct MyStruct: SwiftStructUserdata {
        var val1: Int
        init() {
            self.val1 = 90
        }
        func __call(_ L: LuaState) -> Int32 {
            L.pushString("asdf")
            return 1
        }
    }
    let L = LuaState.newLuaState()
    let myStruct = L.new(MyStruct())
    L.setGlobal("myStruct")
    #expect(myStruct.pointee.val1 == 90)
    myStruct.pointee.val1 = 5
    #expect(myStruct.pointee.val1 == 5)
    var status = L.loadBufferX(buffer: #"return myStruct()"#, name: "hello")
    #expect(status == .LUA_OK)
    status = L.pcall(nargs: 0)
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TSTRING)
    #expect(L.toString(-1) == "asdf")
    L.close()
}

@Test func simpleSwiftStructUserdataAsUserData4() throws {
    final class C: Sendable {
        static nonisolated(unsafe) var count = 0
        init() {
            Self.count += 1
        }
        deinit {
            Self.count -= 1
        }
    }
    struct MyStruct: SwiftStructUserdata {
        var val1: Int
        let c: C
        init(c: C) {
            self.c = c
            self.val1 = 90
        }
    }
    let L = LuaState.newLuaState()
    #expect(C.count == 0)
    let myStruct = L.new(MyStruct(c: C()))
    #expect(C.count == 1)
    L.setGlobal("myStruct")
    #expect(myStruct.pointee.val1 == 90)
    myStruct.pointee.val1 = 5
    #expect(myStruct.pointee.val1 == 5)
    #expect(C.count == 1)
    L.close()
    #expect(C.count == 0)
}

@Test func simpleSwiftStructUserdataAsUserData5() throws {
    struct MyStruct: SwiftStructUserdata {
        var val1: Int
        init() {
            self.val1 = 90
        }
        func __index(_ L: LuaState) -> Int32 {
            L.pushString("You accessed: \(L.toString() ?? "")")
            return 1
        }
    }
    let L = LuaState.newLuaState()
    let myStruct = L.new(MyStruct())
    L.setGlobal("myStruct")
    #expect(myStruct.pointee.val1 == 90)
    myStruct.pointee.val1 = 5
    #expect(myStruct.pointee.val1 == 5)
    var status = L.loadBufferX(buffer: #"return myStruct.test"#, name: "hello")
    #expect(status == .LUA_OK)
    status = L.pcall(nargs: 0)
    #expect(status == .LUA_OK)
    #expect(L.getTop() == 1)
    #expect(L.type(-1) == .LUA_TSTRING)
    #expect(L.toString(-1) == "You accessed: test")
    L.close()
}

@Test func simpleCFunc() throws {
    let L = LuaState.newLuaState()
    L.openLibs()
    #expect(L.getTop() == 0)
    #expect(L.type(-1) == .LUA_TNIL)
    L.pushCFunction { state in
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

@Test func testNativeModule2() async throws {
    let L = LuaState.newLuaState()
    
    L.openLibs()
    
    L.getGlobal("package")
    L.getField(-1, key: "preload")
    
    L.pushCFunction { L in
        L.newLib(functionRegistration: [
            LuaFunctionRegistration(
                name: "hello",
                cFunction: { L in
                    L.pushString("world")
                    return 1
                }
            )
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
