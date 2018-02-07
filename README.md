lua-sass
========

Lua bindings for [libsass].

Requirements
------------

* C compiler
* [Lua] `>= 5.1`
* [libsass]

Installation
------------

    luarocks install sass

Usage
-----

The `sass` module provides 2 functions, which are named in accordance with
their [libsass] counterparts:

### compile

    local css, err = sass.compile(scss, style)

**Parameters:**

1. `scss`: A string of [SCSS] input text.
2. `style`: The output style. Either `"nested"`or `"compressed"`
   (*optional*; defaults to `"nested"`).

**Returns:**

Either a string of CSS on success, or `nil` and an error message on failure.

### compile_file

    local css, err = sass.compile_file(filename, style)

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


[libsass]: https://sass-lang.com/libsass
[Lua]: https://www.lua.org/
[SCSS]: https://sass-lang.com/documentation/file.SASS_REFERENCE.html#syntax
