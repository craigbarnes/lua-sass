package = "sass"
version = "scm-1"

description = {
    summary = "Lua bindings for libsass",
    homepage = "https://github.com/craigbarnes/lua-sass",
    license = "ISC"
}

source = {
    url = "git+https://github.com/craigbarnes/lua-sass.git",
    branch = "master"
}

dependencies = {
    "lua >= 5.1"
}

external_dependencies = {
    SASS = {
        header = "sass/context.h",
        library = "sass"
    }
}

build = {
    type = "builtin",
    modules = {
        sass = {
            sources = {"sass.c"},
            libraries = {"sass"}
        }
    }
}
