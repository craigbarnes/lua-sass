lua-sass
========
Lua binding to libsass

Installation
------------

    make && sudo make install

Usage
-----

Loading the `sass` module returns a single function, which takes a string of
SCSS and returns either a string of compiled CSS on success, or
`nil, errmsg` on failure.

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


[libsass]: https://github.com/hcatlin/libsass
