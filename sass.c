/*
 Lua bindings for the libsass library.
 Copyright (c) 2012-2018 Craig Barnes

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

#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <sass/context.h>
#include <lua.h>
#include <lauxlib.h>
#include "compat.h"

static const char *const output_styles[] = {
    "nested",
    "expanded",
    "compact",
    "compressed",
    NULL
};

static int compile(lua_State *L) {
    size_t len;
    const char *str = luaL_checklstring(L, 1, &len);
    const int output_style = luaL_checkoption(L, 2, "nested", output_styles);
    struct Sass_Data_Context *data_ctx;
    struct Sass_Context *ctx;
    struct Sass_Options *options;

    /* libsass insists on owning (and freeing) the passed in string,
       so the string on the Lua heap must be copied here */
    char *copy = malloc(len + 1);
    if (copy == NULL) {
        lua_pushnil(L);
        lua_pushliteral(L, "malloc() failed");
        return 2;
    }
    strncpy(copy, str, len);
    copy[len] = '\0';

    data_ctx = sass_make_data_context(copy);
    ctx = sass_data_context_get_context(data_ctx);
    options = sass_context_get_options(ctx);
    sass_option_set_output_style(options, output_style);
    if (sass_compile_data_context(data_ctx) == 0) {
        lua_pushstring(L, sass_context_get_output_string(ctx));
        sass_delete_data_context(data_ctx);
        return 1;
    } else {
        lua_pushnil(L);
        lua_pushstring(L, sass_context_get_error_message(ctx));
        sass_delete_data_context(data_ctx);
        return 2;
    }
}

static int compile_file(lua_State *L) {
    const char *filename = luaL_checkstring(L, 1);
    const int output_style = luaL_checkoption(L, 2, "nested", output_styles);
    struct Sass_File_Context *file_ctx = sass_make_file_context(filename);
    struct Sass_Context *ctx = sass_file_context_get_context(file_ctx);
    struct Sass_Options *options = sass_context_get_options(ctx);
    sass_option_set_output_style(options, output_style);
    if (sass_compile_file_context(file_ctx) == 0) {
        lua_pushstring(L, sass_context_get_output_string(ctx));
        sass_delete_file_context(file_ctx);
        return 1;
    } else {
        lua_pushnil(L);
        lua_pushstring(L, sass_context_get_error_message(ctx));
        sass_delete_file_context(file_ctx);
        return 2;
    }
}

static const luaL_Reg lib[] = {
    {"compile", compile},
    {"compile_file", compile_file},
    {NULL, NULL}
};

EXPORT int luaopen_sass(lua_State *L) {
    luaL_newlib(L, lib);
    lua_pushstring(L, libsass_version());
    lua_setfield(L, -2, "LIBSASS_VERSION");
    return 1;
}
