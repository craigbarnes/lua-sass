CFLAGS      ?= -O2 -fPIC -std=c89 -pedantic -Wall -Wextra
LDFLAGS      = -shared

PKGCONFIG    = pkg-config --silence-errors
SASS_CFLAGS  = $(shell $(PKGCONFIG) --cflags libsass)
SASS_LDFLAGS = $(or $(shell $(PKGCONFIG) --libs libsass), -lsass)
SASS_INCDIR  = $(shell $(PKGCONFIG) --variable=includedir libsass)

LIBTOOL      = libtool --tag=CC --silent
LTLINK       = $(LIBTOOL) --mode=link
LTCOMPILE    = $(LIBTOOL) --mode=compile

include findlua.mk

all: sass.so

ifndef USE_LIBTOOL
sass.so: sass.o
	$(CC) $(LDFLAGS) $(SASS_LDFLAGS) -o $@ $<
else
sass.so: .libs/libluasass.so.0.0.0
	cp $< $@
endif

sass.o: sass.c
	$(CC) $(CFLAGS) $(LUA_CFLAGS) $(SASS_CFLAGS) -c -o $@ $<

.libs/libluasass.so.0.0.0: libluasass.la

libluasass.la: sass.lo
	$(LTLINK) $(CC) $(SASS_LDFLAGS) -rpath $(LUA_CMOD_DIR) -o $@ $<

sass.lo: sass.c
	$(LTCOMPILE) $(CC) $(CFLAGS) $(LUA_CFLAGS) $(SASS_CFLAGS) -c $<

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

clean:
	$(RM) sass.so sass.o sass.lo libluasass.la
	$(RM) lua-sass-*.tar.gz lua-sass-*.zip
	$(RM) -r .libs


.PHONY: all install uninstall check test cppcheck clean force

ifeq "$(shell uname)" "Darwin"
  LDFLAGS = -bundle -undefined dynamic_lookup
endif
