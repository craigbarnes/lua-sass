include lualib.mk

SASS_CFLAGS  ?= $(shell $(PKGCONFIG) --cflags libsass)
SASS_LDFLAGS ?= $(shell $(PKGCONFIG) --libs-only-L libsass)
SASS_LDLIBS  ?= $(or $(shell $(PKGCONFIG) --libs-only-l libsass), -lsass)
SASS_INCDIR  ?= $(shell $(PKGCONFIG) --variable=includedir libsass)

CFLAGS       ?= -g -O2 -Wall -Wextra -Wswitch-enum -Wwrite-strings -Wshadow
XCFLAGS      += -std=c99 -pedantic -fPIC
XCFLAGS      += $(LUA_CFLAGS) $(SASS_CFLAGS)
XLDFLAGS     += $(SASS_LDFLAGS) $(SASS_LDLIBS)

all: sass.so
sass.o: compat.h

install: all
	$(MKDIR) '$(DESTDIR)$(LUA_CMOD_DIR)'
	$(INSTALLX) sass.so '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

uninstall:
	$(RM) '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

lua-sass-%.tar.gz lua-sass-%.zip: force
	git archive --prefix=lua-sass-$*/ -o $@ $*

tags: sass.c $(if $(SASS_INCDIR),$(SASS_INCDIR)/sass_interface.h,)
	ctags --c-kinds=+p $^

# Ensure the tests only load modules from within the current directory
export LUA_PATH = ./?.lua
export LUA_CPATH = ./?.so

check: all test.lua
	@$(LUA) test.lua

check-compat:
	$(MAKE) -sB check LUA_PC=luajit
	$(MAKE) -sB check CC=clang
	$(MAKE) -sB check

check-install: DESTDIR = TMP
check-install: export LUA_PATH =
check-install: export LUA_CPATH = $(DESTDIR)$(LUA_CMOD_DIR)/?.so
check-install: install check uninstall
	rmdir -p "$(DESTDIR)$(LUA_CMOD_DIR)"

check-cppcheck: sass.c
	@cppcheck --enable=style,performance,portability --std=c99 $^

githooks: .git/hooks/pre-commit

.git/hooks/pre-commit: Makefile
	printf '#!/bin/sh\n\nmake -s check || exit 1' > $@
	chmod +x $@

clean:
	$(RM) sass.so sass.o lua-sass-*.tar.gz lua-sass-*.zip


.PHONY: all install uninstall githooks clean force
.PHONY: check check-compat check-install check-cppcheck
