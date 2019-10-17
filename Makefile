SRCS=sawp.scm templates.scm scraper.scm
OBJS=$(addsuffix .o,$(basename $(SRCS)))

o/%.o:src/%.scm
	csc -c $< -o $@

sawp: $(addprefix o/,$(OBJS))
	csc -o $@ $^
