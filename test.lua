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

--Errors should return nil, rather than terminating
assert(not sass.compile "invalid-syntax!")
assert(not sass.compile_file "non-existant.file")

print "All tests passed"
