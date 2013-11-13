/*
 Lua bindings for the the libsass library.
 Copyright (c) 2012-2013 Craig Barnes

 Permission to use, copy, modify, and/or distribute this software for any
 purpose with or without fee is hereby granted, provided that the above
 copyright notice and this permission notice appear in all copies.

 THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

/*
NOTE:
 The various casts from "const char*" to "char*" are a temporary workaround.
 The data is never actually mutated by libsass, but the declarations in
 sass_interface.h are lacking const-correctness.

 TODO: Remove casts when libsass API is fixed.
*/

#include <sass_interface.h>
#include <lauxlib.h>
#include <lua.h>

static const char *const output_style[] = {
    "nested",
    "expanded",
    "compact",
    "compressed",
    NULL
};

static const char *const src_comment[] = {
    "none",
    "default",
    "map",
    NULL
};

static void push_error(lua_State *L, const char *message) {
    lua_pushnil(L);
    lua_pushstring(L, message ? message : "An unknown error occurred");
}

static struct sass_options check_options(lua_State *L, int i) {
    struct sass_options options;
    options.output_style = luaL_checkoption(L, i++, "nested", output_style);
    options.source_comments = luaL_checkoption(L, i++, "default", src_comment);
    options.include_paths = (char*)luaL_optstring(L, i++, "");
    options.image_path = (char*)luaL_optstring(L, i++, "images");
    return options;
}

static int compile(lua_State *L) {
    const char *input = luaL_checkstring(L, 1);
    struct sass_options options = check_options(L, 2);
    struct sass_context *ctx = sass_new_context();

    ctx->options = options;
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
    const char *filename = luaL_checkstring(L, 1);
    struct sass_options options = check_options(L, 2);
    struct sass_file_context *ctx = sass_new_file_context();

    ctx->options = options;
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

int luaopen_sass(lua_State *L) {
    lua_createtable(L, 0, 2);
    lua_pushcfunction(L, compile);
    lua_setfield(L, -2, "compile");
    lua_pushcfunction(L, compile_file);
    lua_setfield(L, -2, "compile_file");
    return 1;
}
