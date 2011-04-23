CXX?=g++
OPTFLAGS?=
OPTLIBS?=-L/usr/local/lib 
PREFIX?=/usr/local

CXXFLAGS=-ggdb -Wall -Wextra -Ilib $(OPTFLAGS)
LDFLAGS=$(OPTLIBS) -L.

LIBS=-lzmq -ljson -lm2pp

incdir=$(PREFIX)/include
libdir=$(PREFIX)/lib

AR=ar
RANLIB=ranlib
INSTALL=install -m 644
MKDIR=mkdir -p

LIBRARY=libm2pp.a
HEADER=lib/m2pp.hpp

TEST=m2pp-test
CGI=m2pp-cgi

LIBOBJS=$(patsubst %.cpp,%.o,$(wildcard lib/*.cpp))
CGIOBJS=$(patsubst %.cpp,%.o,$(wildcard cgi/*.cpp))

all: $(LIBRARY) $(TEST) $(CGI)

$(TEST): $(TEST).o $(LIBRARY)
	$(CXX) -o $@ $(CXXFLAGS) $(LDFLAGS) $(TEST).o $(LIBS)

$(CGI): $(CGIOBJS) $(LIBRARY)
	$(CXX) -o $@ $(CXXFLAGS) $(LDFLAGS) $(CGIOBJS) $(LIBS)

$(LIBRARY): $(LIBOBJS)
	$(RM) $@
	$(AR) qc $@ $^
	$(RANLIB) $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

clean:
	$(RM) $(LIBOBJS) $(LIBRARY) $(TEST) $(TEST).o $(CGI) $(CGIOBJS)

install:
	$(MKDIR) $(DESTDIR)$(libdir)
	$(INSTALL) $(LIBRARY) $(DESTDIR)$(libdir)
	$(MKDIR) $(DESTDIR)$(incdir)
	$(INSTALL) $(HEADER) $(DESTDIR)$(incdir)

.PHONY: clean install
