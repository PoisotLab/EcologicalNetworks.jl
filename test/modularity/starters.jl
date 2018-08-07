module TestModularityStarters
using Test
using EcologicalNetworks

    A = [
      true true true false false false; true true true false false false;
      false false false true true true; false false false true true true
      ]
    B = BipartiteNetwork(A)

    @test length(unique(last(each_species_its_module(B)))) == richness(B)

    f2 = n_random_modules(2)
    n2 = f2(B)
    @test labs = length(unique(collect(values(last(n2))))) == 2

end
