local sass = assert(package.loadlib("./sass.so", "luaopen_sass"))()

-- Basic compilation of valid strings and files should work
assert(sass.compile("a {color: red}", "compressed", "map", "inc", "images"))
assert(sass.compile_file "test.scss")

-- Errors should return nil without causing fatal exceptions
assert(not sass.compile "invalid-syntax!")
assert(not sass.compile_file "non-existant.file")

print "All tests passed"
