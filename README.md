lua-sass
========
Lua bindings for [libsass]

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

* `SASS_CFLAGS`: flags required to find the libsass headers.
* `SASS_LDFLAGS`: flags for linking to libsass (defaults to `-lsass`).
* `LUA_CFLAGS`: flags required to find the Lua headers.
* `LUA_CMOD_DIR`: the directory in which to install the compiled module.

If you don't have [pkg-config] or the relevant .pc files installed, you
may need to specify these variables manually, for example:

    make LUA_CFLAGS=-I/usr/include/lua5.2 SASS_CFLAGS=-I/usr/include/libsass
    make check
    [sudo] make install LUA_CMOD_DIR=/usr/lib/lua/5.2

Usage
-----

The `sass` module provides 2 functions, which are named in accordance with
their [libsass] counterparts:

### compile

    compile(scss, style, source_maps, include_paths, image_path)

**Parameters:**

1. `scss`: A string of [SCSS] input text.
2. `style`: The output style. Either `"nested"`or `"compressed"`
   (*optional*; defaults to `"nested"`).
3. `source_maps`: Whether to add CSS [source maps] to the output.
   (*optional*; defaults to `false`).
4. `include_paths`: A colon-delimited string of include paths
   (*optional*; defaults to `""`).
5. `image_path`: A string specifying the path to the images directory
   (*optional*; defaults to `"images"`).

**Returns:**

Either a string of CSS on success, or `nil` and an error message on failure.

### compile_file

    compile_file(filename, style, source_maps, include_paths, image_path)

**Parameters:**

1. `filename`: An [SCSS] file to read input from.
2. As above.
3. As above.
4. As above.
5. As above.

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
local css, err = sass.compile_file("file.scss", "nested", true)
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
[source maps]: https://developer.chrome.com/devtools/docs/css-preprocessors
