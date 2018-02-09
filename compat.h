#ifndef LUA_VERSION_NUM
# error Lua >= 5.1 is required.
#endif

#if LUA_VERSION_NUM < 502
# define luaL_newlib(L, l) (lua_newtable(L), luaL_register(L, NULL, l))
#endif

#ifdef _WIN32
# define EXPORT __declspec(dllexport)
#else
# define EXPORT
#endif
