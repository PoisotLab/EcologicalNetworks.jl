JEXEC=julia
ARCHIVENAME=EcologicalNetwork.tar.gz

.PHONY: clean

test: src/*jl test/*jl
	$(JEXEC) -e 'include("src/EcologicalNetwork.jl"); include("test/runtests.jl")'

docs: src/*
	julia --color=yes docs/make.jl
