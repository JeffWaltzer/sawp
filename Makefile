SRC_NAMES=scraper.scm templates.scm sawp.scm
AWFUL_FLAGS=--development-mode


SRCS=$(patsubst %.scm,src/%.scm,$(SRC_NAMES))
OBJS=$(patsubst src/%.scm,o/%.o,$(SRCS))

o/%.o : src/%.scm
	csc -shared -c -o $@ $^

.PHONY : run compile run-compiled clean

run :
	awful $(AWFUL_FLAGS) $(SRCS)

run-compiled : compile
	awful $(AWFUL_FLAGS) sawp.so

compile : sawp.so

clean :
	rm -f $(OBJS) sawp.so


sawp.so : $(OBJS)
	csc -shared -o $@ $^
