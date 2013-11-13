lua-sass
========
Lua bindings for [libsass]

Installation
------------

    make
    [sudo] make install

Note: you may need to add the appropriate include paths for Lua/libsass
to `CPPFLAGS`, if the headers are not found by default.

e.g.

    make CPPFLAGS='-I /usr/include/lua5.1 -I /usr/include/libsass'

Usage
-----

The `sass` module provides 2 functions, which are named in accordance with
their [libsass] counterparts:

* `css = sass.compile(scss_string)`
* `css = sass.compile_file(filename)`

If any errors are encountered when calling either function, `nil, errmsg`
will be returned.

Examples
--------

#### Compiling a string and using the `assert` idiom for error handling:

```lua
local sass = require "sass"
local css = assert(sass.compile "$x: red; div {color: $x}")
print(css)
```

#### Compiling a file and using explicit error handling:

```lua
local sass = require "sass"
local css, errmsg = sass.compile_file "file.scss"
if css then
    print(css)
else
    io.stderr:write("Error: " .. errmsg)
    -- Error handling goes here
end
```

[License](http://en.wikipedia.org/wiki/ISC_license "ISC license")
---------

Copyright (c) 2012, Craig Barnes

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


[libsass]: https://github.com/hcatlin/libsass
