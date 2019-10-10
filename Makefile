SRCS=scraper.scm templates.scm sawp.scm 
OBJS=$(subst .scm,.o,$(SRCS))

AWFUL_FLAGS=--development-mode

.PHONY : run compile run-compiled clean

%.o : %.scm
	csc -shared -c $^

run :
	awful $(AWFUL_FLAGS) $(SRCS)

run-compiled : compile
	awful $(AWFUL_FLAGS) sawp.so

compile : sawp.so


sawp.so : $(OBJS)
	csc -shared -o $@ $^

clean :
	rm -f $(OBJS) sawp.so
