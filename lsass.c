#include <sass_interface.h>
#include <lauxlib.h>
#include <lua.h>

static void push_error(lua_State *L, const char *message) {
    lua_pushnil(L);
    lua_pushstring(L, message ? message : "An unknown error occurred");
}

static int compile(lua_State *L) {
    const char *input;
    struct sass_context *ctx;

    input = luaL_checkstring(L, 1);
    ctx = sass_new_context();
    ctx->options.include_paths = "";
    ctx->options.image_path = "images";
    ctx->options.output_style = SASS_STYLE_NESTED;
    ctx->source_string = input;
    sass_compile(ctx);

    if (ctx->error_status || !ctx->output_string) {
        push_error(L, ctx->error_message);
        sass_free_context(ctx);
        return 2;
    } else {
        lua_pushstring(L, ctx->output_string);
        sass_free_context(ctx);
        return 1;
    }
}

static int compile_file(lua_State *L) {
    const char *filename;
    struct sass_file_context *ctx;

    filename = luaL_checkstring(L, 1);
    ctx = sass_new_file_context();
    ctx->options.include_paths = "";
    ctx->options.image_path = "images";
    ctx->options.output_style = SASS_STYLE_NESTED;

    /* This cast is potentially dangerous but in practice
       sass_file_context::input_path is not mutated by libsass.
       TODO: Remove cast if/when libsass API is made const correct. */
    ctx->input_path = (char*)filename;

    sass_compile_file(ctx);

    if (ctx->error_status || !ctx->output_string) {
        push_error(L, ctx->error_message);
        sass_free_file_context(ctx);
        return 2;
    } else {
        lua_pushstring(L, ctx->output_string);
        sass_free_file_context(ctx);
        return 1;
    }
}

LUALIB_API int luaopen_sass(lua_State *L) {
    lua_createtable(L, 0, 2);
    lua_pushcfunction(L, compile);
    lua_setfield(L, -2, "compile");
    lua_pushcfunction(L, compile_file);
    lua_setfield(L, -2, "compile_file");
    return 1;
}
