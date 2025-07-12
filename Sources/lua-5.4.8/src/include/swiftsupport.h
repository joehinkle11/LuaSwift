#ifndef swiftsupport_h
#define swiftsupport_h

#include "lauxlib.h"

/*
** Garbage-collection function, non varadic
*/
LUA_API int lua_gc_non_varadic (lua_State *L, int what);

/*
** Garbage-collection function, non varadic with data
*/
LUA_API int lua_gc_non_varadic_with_data (lua_State *L, int what, int data);

/*
** Get pointer to extra space that can be used for any purpose
*/
LUA_API void* lua_getextraspace_function(lua_State *L);

/*
** Size of extra space for any purpose
*/
LUA_API size_t LUA_EXTRASPACE_SIZE();

LUA_API void luaL_newlib_nonmacro (lua_State *L, const luaL_Reg l[]);

LUA_API void (luaL_newlibtable_nonmacro) (lua_State *L, const luaL_Reg l[]);

LUA_API int luaL_dostring_nonmacro (lua_State *L, const char *str);

#endif


