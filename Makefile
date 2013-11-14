PREFIX  = /usr/local
LUAVER  = 5.1
LUACDIR = $(PREFIX)/lib/lua/$(LUAVER)
LUADIR  = $(PREFIX)/share/lua/$(LUAVER)
CFLAGS  = -O2 -std=c89 -Wall -Wextra -Wpedantic
LDFLAGS = -shared
LDLIBS  = -lsass

all: lsass.so

lsass.so: lsass.o
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: lsass.so
	mkdir -p '$(DESTDIR)$(LUACDIR)' '$(DESTDIR)$(LUADIR)'
	install -pm0755 lsass.so '$(DESTDIR)$(LUACDIR)'
	install -pm0644 sass.lua '$(DESTDIR)$(LUADIR)'

uninstall:
	$(RM) '$(DESTDIR)$(LUACDIR)/lsass.so'
	$(RM) '$(DESTDIR)$(LUADIR)/sass.lua'

check test: lsass.so sass.lua test.lua
	@LUA_PATH='./?.lua' LUA_CPATH='./?.so' lua test.lua

cppcheck: lsass.c
	@cppcheck --enable=style,performance,portability --std=c89 $^

clean:
	$(RM) lsass.so lsass.o


.PHONY: all install uninstall check test cppcheck clean

ifeq ($(shell uname),Darwin)
  LDFLAGS = -undefined dynamic_lookup -dynamiclib
endif
