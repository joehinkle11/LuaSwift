# LuaSwift

A Swift package that provides integration with Lua 5.4.8.

> ☑️ NOTICE: While this repo works, I recommend using the fork found https://github.com/nubetools/LuaSwift

## Overview

LuaSwift is a Swift package that embeds the complete Lua 5.4.8 interpreter and provides multiple levels of API access:

- **CLua**: Direct access to the native Lua 5.4.8 C API
- **Lua**: Swift-friendly wrapper around the C API which avoids changing the original C API
- **LuaHelpers**: High-level Swift helpers for easy Lua integration
- **LuaSwift**: A convenience import which simply imports both Lua and LuaHelpers together

## Features

- ✅ Complete Lua 5.4.8 implementation
- ✅ C API provided in Swift
- ✅ Type-safe API with Swift enums and structs
- ✅ Coroutine support
- ✅ All standard Lua libraries included
- ✅ Cross-platform support (iOS, macOS, watchOS, tvOS, Linux)
- WASM does not work in this repo. See the repo https://github.com/nubetools/LuaSwift for WASM support

## Installation

### Swift Package Manager

Add LuaSwift to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/joehinkle11/LuaSwift.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["LuaSwift"]
)
```

## API Layers

### CLua Target

The `CLua` target provides direct access to the Lua 5.4.8 C API.

Some small modifications to the C code were necessary to get Lua compiling in SPM. These changes are listed [here](Sources/lua-5.4.8/README).

```swift
import CLua

let L = luaL_newstate()
luaL_openlibs(L)

// Direct C API usage
lua_pushstring(L, "Hello from C API")
lua_setglobal(L, "message")

lua_close(L)
```

### Lua Target

The `Lua` target provides a Swift-friendly wrapper around the C API by simply putting most of lua's functions into methods on a struct called `LuaState`. `LuaState` only has one member property which points to the c object lua_State.

One of the unit tests looks like this.

```swift
let L = LuaState.newLuaState()
L.openLibs()
#expect(L.getTop() == 0) // ✅
#expect(L.type(-1) == .LUA_TNIL) // ✅
var status = L.loadBufferX(buffer: #"return "asdf""#, name: "hello")
#expect(status == .LUA_OK) // ✅
#expect(L.getTop() == 1) // ✅
#expect(L.type(-1) == .LUA_TFUNCTION) // ✅
status = L.pcall(nargs: 0)
#expect(status == .LUA_OK) // ✅
#expect(L.getTop() == 1) // ✅
#expect(L.type(-1) == .LUA_TSTRING) // ✅
#expect(L.toString(-1) == "asdf") // ✅
L.pop(1)
#expect(L.getTop() == 0) // ✅
L.close()
```

The idea of the `Lua` target in this package is to just expose as much of the C API of Lua but as methods on the `LuaState` type (which is simply a struct with a reference to the underlying C lua_State object).

### LuaHelpers Target

Todo. Adds additional extensions to the `LuaState` type and helpers for interop with Swift/Lua.

### LuaSwift Target

This is the one you should be importing. This target simply imports both the `Lua` and `LuaHelpers` targets.

## Platform Support

LuaSwift supports all platforms that Swift supports:
- macOS
- iOS
- watchOS
- tvOS
- Linux
- Windows
- WASM (but at the repo located [here](https://github.com/nubetools/LuaSwift))

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

This package includes Lua 5.4.8, which is licensed under the MIT License. See the Lua source files for details.

The Swift package itself is under the MIT License as well.

## Credits

- Lua 5.4.8 by the Lua Team (PUC-Rio)


