lua-sass
========
Lua binding to [libsass](https://github.com/hcatlin/libsass)

Installation
------------

    make && sudo make install

Usage
-----

Loading the `sass` module returns a single function, which takes a string of
SCSS and returns a string of compiled CSS on success, or `nil, errmsg`
on failure.

The following idiom can be used to simply throw an error (passing on the
correct error messsage) on failure:

    local sass = require "sass"
    local css = assert(sass "$x: red; div {color: $x}")
    print(css)

or alternatively error handling can be handled explicitly:

    local sass = require "sass"
    local css, err = sass "$x: red; div {color: $x}"
    if not err then
        print(css)
    else
        -- Your error handling here
    end

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
