INC=/usr/local/include
LIB=/usr/local/lib

weight.o: jopenfst.h weight.cc
	g++ -c -o weight.o -I$(INC) -fPIC weight.cc

fst-class.o: jopenfst.h fst-class.cc
	g++ -c -o fst-class.o -I$(INC) -fPIC fst-class.cc

fst-ops.o: jopenfst.h fst-ops.cc
	g++ -c -o fst-ops.o -I$(INC) -fPIC fst-ops.cc

fst-iterators.o: jopenfst.h fst-iterators.cc
	g++ -c -o fst-iterators.o -I$(INC) -fPIC fst-iterators.cc

jopenfst.so: weight.o fst-class.o fst-ops.o fst-iterators.o
	g++ -o jopenfst.so -fPIC -shared weight.o fst-class.o fst-ops.o \
            fst-iterators.o $(LIB)/libfst.so $(LIB)/libfstscript.so 
