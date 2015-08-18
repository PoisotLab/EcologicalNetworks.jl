JEXEC=julia
ARCHIVENAME=EcologicalNetwork.tar.gz

.PHONY: clean

ALL: $(ARCHIVENAME)

$(ARCHIVENAME): test doc clean
	rm -f $(ARCHIVENAME)
	cd ..; tar -zcvf EcologicalNetwork/$(ARCHIVENAME) EcologicalNetwork

test: src/*jl test/*jl
	$(JEXEC) --code-coverage -e 'Pkg.test(pwd(), coverage=true)'

clean:
	- rm src/*.cov
	- rm test/network.log

doc: src/*jl CONTRIBUTING.md
	cp README.md doc/index.md
	cp CONTRIBUTING.md doc/contr.md
	$(JEXEC) ./test/makedoc.jl

CONTRIBUTING.md:
	wget -O $@ https://raw.githubusercontent.com/PoisotLab/PLCG/master/README.md
