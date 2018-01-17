local sass = require "sass"
local compile = assert(sass.compile)
local compile_file = assert(sass.compile_file)
local type, assert, write = type, assert, io.write
local _ENV = nil

do -- Compilation of valid SCSS strings should work
    local scsstext = "$x: red; a {color: $x / 3}"
    local expected = "a{color:#500}\n"
    local output = assert(compile(scsstext, "compressed"))
    assert(output == expected)
end

do -- Compilation of valid SCSS files should work
    local filename = "test.scss"
    local expected = "p{width:550px;color:#c50;border-radius:7px}\n"
    local output = assert(compile_file(filename, "compressed"))
    assert(output == expected)
end

-- Errors should return nil, rather than terminating
assert(not compile "invalid-syntax!")
assert(not compile_file "non-existant.file")

-- Version information should be available
assert(type(sass.LIBSASS_VERSION) == "string")

write "All tests passed\n"
