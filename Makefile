JEXEC=julia
ARCHIVENAME=EcologicalNetwork.tar.gz

.PHONY: clean

ALL: $(ARCHIVENAME)

$(ARCHIVENAME): test clean
	rm -f $(ARCHIVENAME)
	cd ..; tar -zcvf EcologicalNetwork/$(ARCHIVENAME) EcologicalNetwork

test: src/*jl test/*jl
	$(JEXEC) -e 'include("src/EcologicalNetwork.jl"); include("test/runtests.jl")'

CONTRIBUTING.md:
	wget -O $@ https://raw.githubusercontent.com/PoisotLab/PLCG/master/README.md

manual:test/casestudies/*.jl
	julia manual/build.jl
