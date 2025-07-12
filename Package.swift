// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LuaSwift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LuaSwift",
            targets: ["LuaSwift", "LuaHelpers", "Lua", "CLua"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LuaSwift",
            dependencies: ["LuaHelpers", "Lua", "CLua"]
        ),
        .target(
            name: "LuaHelpers",
            dependencies: [
                "Lua"
            ]
        ),
        .target(
            name: "Lua",
            dependencies: [
                "CLua"
            ]
        ),
        .target(
            name: "CLua",
            path: "Sources/lua-5.4.8/src",
            cxxSettings: [
                .define("LUA_USE_IOS", .when(platforms: [.iOS])),
            ]
        ),
        .testTarget(
            name: "LuaSwiftTests",
            dependencies: ["LuaSwift", "LuaHelpers", "Lua", "CLua"]
        ),
    ]
)
