local sass = require "sass"

assert(sass.compile "a {color: red}")
assert(sass.compile_file "test.scss")
