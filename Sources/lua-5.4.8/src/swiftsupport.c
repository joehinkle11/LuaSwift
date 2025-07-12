
#include "lapi.h"
#include "lua.h"
#include "swiftsupport.h"

/*
** Garbage-collection function, non varadic
*/
LUA_API int lua_gc_non_varadic (lua_State *L, int what) {
    return lua_gc(L, what);
}

/*
** Garbage-collection function, non varadic with data
*/
LUA_API int lua_gc_non_varadic_with_data (lua_State *L, int what, int data) {
    return lua_gc(L, what, data);
}

/*
** Get pointer to extra space that can be used for any purpose
*/
LUA_API void* lua_getextraspace_function(lua_State *L) {
    return (void *)((char *)(L) - LUA_EXTRASPACE);
}

/*
** Size of extra space for any purpose
*/
LUA_API size_t LUA_EXTRASPACE_SIZE() {
    return LUA_EXTRASPACE;
}

LUA_API void luaL_newlib_nonmacro (lua_State *L, const luaL_Reg l[]) {
    luaL_newlib(L, l);
}

LUA_API void (luaL_newlibtable_nonmacro) (lua_State *L, const luaL_Reg l[]) {
    return lua_createtable(L, 0, sizeof(l)/sizeof((l)[0]) - 1);
}

LUA_API int luaL_dostring_nonmacro (lua_State *L, const char *str) {
    luaL_dostring(L, str);
}
