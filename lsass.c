#include <sass_interface.h>
#include <lauxlib.h>
#include <lua.h>

#define UERR "An unknown error occurred"

int lsass_compile(lua_State *L) {
    const char *source = luaL_checkstring(L, 1);
    struct sass_context* ctx = sass_new_context();
    ctx->options.include_paths = "";
    ctx->options.image_path = "images";
    ctx->options.output_style = SASS_STYLE_NESTED;
    ctx->source_string = source;

    sass_compile(ctx);

    if (ctx->error_status || !ctx->output_string) {
        lua_pushnil(L);
        lua_pushstring(L, ctx->error_message ? ctx->error_message : UERR);
        sass_free_context(ctx);
        return 2;
    }

    lua_pushstring(L, ctx->output_string);
    sass_free_context(ctx);
    return 1;
}

int lsass_compile_file(lua_State *L) {
    const char *filename = luaL_checkstring(L, 1);
    struct sass_file_context* ctx = sass_new_file_context();
    ctx->options.include_paths = "";
    ctx->options.image_path = "images";
    ctx->options.output_style = SASS_STYLE_NESTED;
    ctx->input_path = filename;

    sass_compile_file(ctx);

    if (ctx->error_status || !ctx->output_string) {
        lua_pushnil(L);
        lua_pushstring(L, ctx->error_message ? ctx->error_message : UERR);
        sass_free_file_context(ctx);
        return 2;
    }

    lua_pushstring(L, ctx->output_string);
    sass_free_file_context(ctx);
    return 1;
}

static const luaL_reg R[] = {
    {"compile", lsass_compile},
    {"compile_file", lsass_compile_file},
    {NULL, NULL}
};

LUALIB_API int luaopen_sass(lua_State *L) {
    luaL_register(L, "sass", R);
    return 1;
}
