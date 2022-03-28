all:: libbiscuits.so libcheese.so libcheese+.so ex1 ex2 ex3 run

UNAME:=$(shell uname)
ifneq ($(UNAME),Darwin)
RPATH=-Wl,-rpath=$(PWD)
else
RPATH=-Wl,-rpath $(PWD)
endif
LDFLAGS+=-L. $(RPATH)

# On Darwin :/
# LDFLAGS+=-L. -Wl,-rpath $(PWD)

biscuits.o: CFLAGS+=-fPIC
biscuits.o: biscuits.c

libbiscuits.so: biscuits.o
	$(CC) $(LDFLAGS) -shared -o $@ $<

cheese.o: CFLAGS+=-fPIC
cheese.o: cheese.c

libcheese.so: cheese.o
	$(CC) $(LDFLAGS)  -shared -o $@ $<

libcheese+.so: cheese.o libbiscuits.so
	$(CC) $(LDFLAGS) -shared -o $@ $< -lbiscuits

ex1: main.o
	$(CC) -dynamic $(LDFLAGS) -o $@ $< -L. -lcheese+

ex2: main.o
	$(CC) -dynamic $(LDFLAGS) -o $@ $< -L. -lcheese

ex3: main.o
	$(CC) -dynamic $(LDFLAGS) -o $@ $< -L. -lcheese -lbiscuits

ifneq ($(UNAME),Darwin)
M4REDEF:=
else
M4REDEF:=-DLD_PRELOAD=DYLD_INSERT_LIBRARIES
endif

run: run.in
	M4 $(M4REDEF) $< > $@
	chmod +x $@

clean:
	rm -f biscuits.o libbiscuits.so cheese.o libcheese.so libcheese+.so ex1 ex2 ex3 main.o run
