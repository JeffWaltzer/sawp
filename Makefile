SRCS=sawp.scm scraper.scm
OBJS=$(subst .scm,.o,$(SRCS))

AWFUL_FLAGS=--development-mode

.PHONY : run run-compiled clean

%.o : %.scm
	csc -shared -c $^

run :
	awful $(AWFUL_FLAGS) $(SRCS)

run-compiled : sawp.so
	awful $(AWFUL_FLAGS) sawp.so

sawp.so : $(OBJS)
	csc -shared -o $@ $^

clean :
	rm -f $(OBJS) sawp.so
