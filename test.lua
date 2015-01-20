local sass = require "sass"
local compile, compile_file = sass.compile, sass.compile_file
local assert, write = assert, io.write
local _ENV = nil

do -- Compilation of valid SCSS strings should work
    local scsstext = "$x: red; a {color: $x / 3}"
    local expected = "a{color:#550000}"
    local output = assert(compile(scsstext, "compressed"))
    assert(output == expected)
end

do -- Compilation of valid SCSS files should work
    local filename = "test.scss"
    local expected = "p{width:550px;color:#cc5500;border-radius:7px}"
    local output = assert(compile_file(filename, "compressed"))
    assert(output == expected)
end

do -- Source maps should be disabled by default and enabled when specified
    local scsstext = "\n\n\n$x: red; a {color: $x / 3}"
    local expected = "a {\n  color: #550000; }\n"
    local expected_maps = "/* line 4, stdin */\n" .. expected
    assert(compile(scsstext, "nested") == expected)
    assert(compile(scsstext, "nested", false) == expected)
    assert(compile(scsstext, "nested", true) == expected_maps)
    assert(compile(scsstext, "nested", 1) == expected_maps)
end

do -- Compilation of UTF-8 input containing multi-byte characters should work
    local prefix = '@charset "UTF-8";\n'
    local scsstext = prefix .. "$สี: blue; .สีน้ำเงิน {color: $สี / 4}"
    local expected = prefix .. ".สีน้ำเงิน{color:#000040}"
    local output = compile(scsstext, "compressed")
    assert(output == expected)
end

--Errors should return nil, rather than terminating
assert(not compile "invalid-syntax!")
assert(not compile_file "non-existant.file")

write "All tests passed\n"
