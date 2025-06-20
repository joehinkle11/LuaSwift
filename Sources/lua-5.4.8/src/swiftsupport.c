
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
