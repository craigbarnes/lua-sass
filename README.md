lua-sass
========

Lua bindings for [libsass].

Status
------

No stable releases available yet.

*Note*: the upstream libsass library is currently undergoing major API
refactoring. The lua-sass API will most likely change before the first
versioned release is ready.

Requirements
------------

* C99 compiler
* [GNU Make]
* [Lua] 5.1/5.2 or [LuaJIT] 2
* [libsass]

Installation
------------

For systems where Lua and libsass are installed globally (i.e. via a
package manager), the following commands should usually suffice:

    make
    make check
    [sudo] make install

The Makefile consults [pkg-config] for the following variables:

* `SASS_CFLAGS`: compiler flags required to find the libsass headers.
* `SASS_LDFLAGS`: linker flags required to find the libsass library.
* `SASS_LDLIBS`: linker flags for linking to the libsass library.
* `LUA_CFLAGS`: compiler flags required to find the Lua headers.
* `LUA_CMOD_DIR`: the directory in which to install the compiled module.

... using the first `lua*.pc` file found from the following list:

1. `lua` (if `Version >= 5.1`)
2. `lua52`
3. `lua5.2`
4. `lua-5.2`
5. `lua51`
6. `lua5.1`
7. `lua-5.1`
8. `luajit` (if `Version >= 2.0`)

If you have more than one of these files present and wish to build
against a specific version of Lua, set the `LUA_PC` variable
accordingly, for example:

    make LUA_PC=luajit
    make check LUA_PC=luajit
    [sudo] make install LUA_PC=luajit

If you don't have [pkg-config] or the relevant `.pc` files installed,
you may need to specify some variables manually, for example:

    make LUA_CFLAGS=-I/usr/include/lua5.2 SASS_CFLAGS=-I/usr/include/libsass
    make check
    [sudo] make install LUA_CMOD_DIR=/usr/lib/lua/5.2

For convenience, the Makefile first tries to load a `local.mk` file,
which can be used to store persistent variable overrides.

Usage
-----

The `sass` module provides 2 functions, which are named in accordance with
their [libsass] counterparts:

### compile

    compile(scss, style)

**Parameters:**

1. `scss`: A string of [SCSS] input text.
2. `style`: The output style. Either `"nested"`or `"compressed"`
   (*optional*; defaults to `"nested"`).

**Returns:**

Either a string of CSS on success, or `nil` and an error message on failure.

### compile_file

    compile_file(filename, style)

**Parameters:**

1. `filename`: An [SCSS] file to read input from.
2. As above.

**Returns:**

As above.

Examples
--------

Compiling a string and using the `assert` idiom for error handling:

```lua
local sass = require "sass"
local css = assert(sass.compile "$x: red; div {color: $x}")
print(css)
```

Compiling a file and using explicit error handling:

```lua
local sass = require "sass"
local css, err = sass.compile_file("file.scss", "nested")
if css then
    print(css)
else
    io.stderr:write("Error: ", err, "\n")
end
```

[License]
---------

Copyright (c) 2012-2014 Craig Barnes

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


[License]: http://en.wikipedia.org/wiki/ISC_license "ISC License"
[libsass]: https://github.com/hcatlin/libsass
[GNU Make]: https://www.gnu.org/software/make/
[Lua]: http://www.lua.org/
[LuaJIT]: http://luajit.org/
[pkg-config]: https://en.wikipedia.org/wiki/Pkg-config
[SCSS]: http://sass-lang.com/documentation/file.SASS_REFERENCE.html#syntax
