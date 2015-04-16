JEXEC=julia

.PHONY: clean CONTRIBUTING.md ALL

ALL: test doc manual clean

test: src/*jl test/*jl
	$(JEXEC) --code-coverage ./test/runtests.jl

clean:
	- rm src/*.cov

doc: src/*jl
	$(JEXEC) ./test/makedoc.jl

manual: doc/*.md
	pandoc doc/api.md -o doc/manual.pdf --latex-engine=xelatex

CONTRIBUTING.md:
	wget -O $@ https://raw.githubusercontent.com/PoisotLab/PLCG/master/README.md
