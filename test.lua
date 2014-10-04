local sass = require "sass"

do -- Compilation of valid SCSS strings should work
    local scsstext = "$x: red; a {color: $x / 2}"
    local expected = "a{color:#800000;}"
    assert(sass.compile(scsstext, "compressed") == expected)
end

do -- Compilation of valid SCSS files should work
    local filename = "test.scss"
    local expected = "p{width:550px;color:#cc5200;border-radius:7px;}"
    assert(sass.compile_file(filename, "compressed") ==  expected)
end

do -- Source maps should be disabled by default and enabled when specified
    local scsstext = "\n\n\n$x: red; a {color: $x / 2}"
    local expected = "a {\n  color: #800000; }\n"
    local expected_maps = "/* line 4, source string */\n" .. expected
    assert(sass.compile(scsstext, "nested") == expected)
    assert(sass.compile(scsstext, "nested", false) == expected)
    assert(sass.compile(scsstext, "nested", true) == expected_maps)
    assert(sass.compile(scsstext, "nested", 1) == expected_maps)
end

do -- Compilation of UTF-8 input containing multi-byte characters should work
    local scsstext = "$สี: blue; .สีน้ำเงิน {color: $สี / 4}"
    local expected = ".สีน้ำเงิน{color:#000040;}"
    assert(sass.compile(scsstext, "compressed") == expected)
end

--Errors should return nil, rather than terminating
assert(not sass.compile "invalid-syntax!")
assert(not sass.compile_file "non-existant.file")

print "All tests passed"
