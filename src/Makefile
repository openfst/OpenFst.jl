# Set to where OpenFst is installed
PREFIX:=/usr/local

INC=$(PREFIX)/include
LIB=$(PREFIX)/lib
CXXFLAGS=--std=c++17 -fPIC -I$(INC)

all: jopenfst.so

clean: weight.o fst-class.o fst-ops.o fst-iterators.o jopenfst.so
	rm -f weight.o fst-class.o fst-ops.o fst-iterators.o jopenfst.so

weight.o: jopenfst.h weight.cc

fst-class.o: jopenfst.h fst-class.cc

fst-ops.o: jopenfst.h fst-ops.cc

fst-iterators.o: jopenfst.h fst-iterators.cc

jopenfst.so: weight.o fst-class.o fst-ops.o fst-iterators.o
	g++ -o jopenfst.so -fPIC -shared weight.o fst-class.o fst-ops.o \
               fst-iterators.o -Wl,-rpath=$(LIB) $(LIB)/libfst.so $(LIB)/libfstscript.so
