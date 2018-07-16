JEXEC=~/apps/julia-0.7.0/bin/julia # For testing only

test: src/*jl test/*jl
	$(JEXEC) -e 'using Pkg; Pkg.add(pwd()); Pkg.update(); include("test/runtests.jl")'

docs: src/*
	$(JEXEC) --color=yes docs/make.jl
