JEXEC=julia

.PHONY: clean

test: src/*jl test/*jl
	$(JEXEC) --code-coverage ./test/runtests.jl

clean:
	- rm src/*.cov

doc: src/*jl
	$(JEXEC) ./test/makedoc.jl
