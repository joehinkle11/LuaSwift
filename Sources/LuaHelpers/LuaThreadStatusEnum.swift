import Lua

public enum LuaThreadStatusEnum: Int32, CaseIterable {
    case OK = 0
    case YIELD = 1
    case ERRRUN = 2
    case ERRSYNTAX = 3
    case ERRMEM = 4
    case ERRERR = 5
}
