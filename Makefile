.PHONY : test

SRCS=sawp.scm templates.scm scraper.scm
OBJS=$(addsuffix .o,$(basename $(SRCS)))

o/%.o:src/%.scm
	csc -c $< -o $@

test:
	behave --nocolor src/scraper.scm spec/*spec.scm

sawp: $(addprefix o/,$(OBJS))
	csc -o $@ $^
