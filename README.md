lua-sass
========
Lua binding to [libsass](https://github.com/hcatlin/libsass)

Installation
------------

    make && sudo make install

Usage
-----

Loading the `sass` module returns a single function, which takes a string of
SCSS and returns a string of CSS, or `nil, errmsg` on failure

```lua
local sass = require "sass"
local css = sass "$x: red; div {color: $x}"
print(css)
```

Error Handling
--------------

The above example will simply print `nil` on failure. Obviously some kind of
error handling is required for such cases. The most simple solution is the
following Lua idiom, which wraps the function call with `assert()` and passes
any error message to `error()` on failure.

```lua
local sass = require "sass"
local css = assert(sass "div {color: $x}")
print(css)
```

Alternatively, errors can be handled explicitly by checking the return value
of `errmsg`:

```lua
local sass = require "sass"
local css, errmsg = sass "div {color: $x}"
if not errmsg then
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
