CFLAGS      ?= -O2 -fPIC -std=c89 -pedantic -Wall -Wextra
LDFLAGS      = -shared

PKGCONFIG    = pkg-config --silence-errors
SASS_CFLAGS  = $(shell $(PKGCONFIG) --cflags libsass)
SASS_LDFLAGS = $(or $(shell $(PKGCONFIG) --libs libsass), -lsass)

include findlua.mk

all: sass.so

sass.so: sass.o
	$(CC) $(LDFLAGS) $(SASS_LDFLAGS) -o $@ $<

sass.o: sass.c
	$(CC) $(CFLAGS) $(LUA_CFLAGS) $(SASS_CFLAGS) -c -o $@ $<

install: all
	mkdir -p '$(DESTDIR)$(LUA_CMOD_DIR)'
	install -pm0755 sass.so '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

uninstall:
	$(RM) '$(DESTDIR)$(LUA_CMOD_DIR)/sass.so'

lua-sass-%.tar.gz: force
	git archive --prefix=lua-sass-$*/ -o $@ $*

check test: all test.lua
	@LUA_PATH='./?.lua' LUA_CPATH='./?.so' lua test.lua

cppcheck: sass.c
	@cppcheck --enable=style,performance,portability --std=c89 $^

clean:
	$(RM) sass.so sass.o


.PHONY: all install uninstall check test cppcheck clean force

ifeq "$(shell uname)" "Darwin"
  LDFLAGS = -bundle -undefined dynamic_lookup
endif
