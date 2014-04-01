include findlua.mk

PKGCONFIG    = pkg-config --silence-errors
SASS_CFLAGS  = $(shell $(PKGCONFIG) --cflags libsass)
SASS_LDLIBS  = $(or $(shell $(PKGCONFIG) --libs libsass), -lsass)
SASS_INCDIR  = $(shell $(PKGCONFIG) --variable=includedir libsass)

CFLAGS      ?= -O2 -fPIC -std=c89 -pedantic -Wall -Wextra
CFLAGS      += $(LUA_CFLAGS) $(SASS_CFLAGS)
LDLIBS       = $(SASS_LDLIBS)

all: sass.so

install: all
	mkdir -p '$(DESTDIR)$(LUA_CMOD_DIR)'
	install -pm0755 sass.so '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

uninstall:
	$(RM) '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

lua-sass-%.tar.gz lua-sass-%.zip: force
	git archive --prefix=lua-sass-$*/ -o $@ $*

tags: sass.c $(if $(SASS_INCDIR),$(SASS_INCDIR)/sass_interface.h,)
	ctags --c-kinds=+p $^

check test: all test.lua
	@LUA_PATH='./?.lua' LUA_CPATH='./?.so' lua test.lua

cppcheck: sass.c
	@cppcheck --enable=style,performance,portability --std=c89 $^

githooks: .git/hooks/pre-commit

.git/hooks/pre-commit: Makefile
	printf '#!/bin/sh\n\nmake -s check || exit 1' > $@
	chmod +x $@

clean:
	$(RM) sass.so sass.o sass.lo sass.la
	$(RM) lua-sass-*.tar.gz lua-sass-*.zip
	$(RM) -r .libs


.PHONY: all install uninstall check test cppcheck githooks clean force
