include lualib.mk

SASS_CFLAGS ?= $(shell $(PKGCONFIG) --cflags libsass)
SASS_LDFLAGS ?= $(shell $(PKGCONFIG) --libs-only-L libsass)
SASS_LDLIBS ?= $(or $(shell $(PKGCONFIG) --libs-only-l libsass), -lsass)

CFLAGS ?= -g -O2 -Wall -Wextra -Wwrite-strings -Wshadow -Werror=c90-c99-compat
XCFLAGS += -std=c99 -pedantic -fPIC
XCFLAGS += $(LUA_CFLAGS) $(SASS_CFLAGS)
XLDFLAGS += $(SASS_LDFLAGS) $(SASS_LDLIBS)

all: sass.so
sass.o: compat.h

install: all
	$(MKDIR) '$(DESTDIR)$(LUA_CMOD_DIR)'
	$(INSTALLX) sass.so '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

uninstall:
	$(RM) '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

lua-sass-%.tar.gz:
	git archive --prefix=lua-sass-$*/ -o $@ $*

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

githooks: .git/hooks/pre-commit

.git/hooks/pre-commit: Makefile
	printf '#!/bin/sh\n\nmake -s check || exit 1' > $@
	chmod +x $@

clean:
	$(RM) sass.so sass.o lua-sass-*.tar.gz


.PHONY: all install uninstall githooks clean
.PHONY: check check-compat check-install
