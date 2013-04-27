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
	rm -f $(DESTDIR)$(LIBDIR)/sass.so

test: sass.so
	@lua test.lua
	@echo "All tests passed"

clean:
	rm -f sass.so lsass.o


.PHONY: install uninstall test clean

ifeq ($(shell uname),Darwin)
  LDFLAGS = -undefined dynamic_lookup -dynamiclib
endif
