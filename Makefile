.PHONY : test

SRCS=sawp.scm templates.scm scraper.scm
OBJS=$(addsuffix .o,$(basename $(SRCS)))

o/%.o:src/%.scm
	csc -c $< -o $@

test:
	csi src/scraper.scm spec/cache-spec.scm

sawp: $(addprefix o/,$(OBJS))
	csc -o $@ $^
