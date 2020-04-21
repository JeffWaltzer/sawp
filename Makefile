.PHONY : test

SRCS=cache.scm page-handlers.scm routes.scm sawp.scm scraper.scm templates.scm
OBJS=$(addsuffix .o,$(basename $(SRCS)))

o/%.o:src/%.scm
	csc -c $< -o $@

test:
	behave spec/spec-helper.scm spec/*.spec.scm

run: sawp
	./sawp

clean:
	rm sawp o/*

sawp: $(addprefix o/,$(OBJS))
	csc -o $@ $^
