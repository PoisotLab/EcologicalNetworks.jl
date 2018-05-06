JEXEC=julia
ARCHIVENAME=EcologicalNetwork.tar.gz

.PHONY: clean

test: src/*jl test/*jl
	$(JEXEC) -e 'include("src/EcologicalNetwork.jl"); include("test/runtests.jl")'


mangroups = _manual _usecases
pagedirs = $(mangroups:%=docs/pages/%)
pages_sources = $(wildcard $(addsuffix /*.Jmd,$(pagedirs)))
pages_compiled = $(patsubst %.Jmd,%.md,$(pages_sources))

define MAKEPAGE

$(patsubst, %.Jmd,%.md,$(1)) : $(1).Jmd
	$(ECHO)     $$< from $$@

endef

$(foreach source,$(pages_compiled), $(eval $(call MAKEPAGE,$(source))))

%.md: %.Jmd
	julia -e 'using Weave;\
		include("src/EcologicalNetwork.jl");\
		weave("$<", out_path="$@", doctype="github", fig_path="docs/figures")'

docs: $(pages_compiled)

clean:
	rm $(pages_compiled)
