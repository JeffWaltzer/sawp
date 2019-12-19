.PHONY : test

SRCS=cache.scm sawp.scm scraper.scm templates.scm
OBJS=$(addsuffix .o,$(basename $(SRCS)))

o/%.o:src/%.scm
	csc -c $< -o $@

test:
	behave spec/*spec.scm

clean:
	rm sawp o/*

sawp: $(addprefix o/,$(OBJS))
	csc -o $@ $^
