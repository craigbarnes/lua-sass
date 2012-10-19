#include <sass_interface.h>
#include <lauxlib.h>
#include <lua.h>

int lsass_compile(lua_State *L) {
    struct sass_context* ctx = sass_new_context();
    int ret;

    ctx->options.include_paths = "";
    ctx->options.image_path = "images";
    ctx->options.output_style = SASS_STYLE_NESTED;
    ctx->source_string = (char*)luaL_checkstring(L, 1);

    sass_compile(ctx);

    if (ctx->error_status) {
        lua_pushnil(L);
        if (ctx->error_message) {
            lua_pushstring(L, ctx->error_message);
        } else {
            lua_pushstring(L, "An unknown error occurred");
        }
        ret = 2;
    } else if (ctx->output_string) {
        lua_pushstring(L, ctx->output_string);
        ret = 1;
    } else {
        lua_pushnil(L);
        lua_pushstring(L, "An unknown internal error occurred");
        ret = 2;
    }

    sass_free_context(ctx);
    return ret;
}

int luaopen_sass(lua_State *L) {
    lua_pushcfunction(L, lsass_compile);
    return 1;
}
