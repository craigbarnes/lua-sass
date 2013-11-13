PREFIX  = /usr/local
LIBDIR  = $(PREFIX)/lib/lua/5.1
CFLAGS  = -O2 -Wall
LDFLAGS = -shared
LDLIBS  = -lsass

sass.so: lsass.o
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: sass.so
	mkdir -p $(DESTDIR)$(LIBDIR)
	install -pm0755 $< $(DESTDIR)$(LIBDIR)/$<

uninstall:
	$(RM) $(DESTDIR)$(LIBDIR)/sass.so

check test: sass.so test.lua
	@lua test.lua

cppcheck: lsass.c
	@cppcheck --enable=style,performance,portability --std=c89 $^

clean:
	$(RM) sass.so lsass.o


.PHONY: install uninstall check test cppcheck clean

ifeq ($(shell uname),Darwin)
  LDFLAGS = -undefined dynamic_lookup -dynamiclib
endif
