module TestBetaDiv
  using Test
  using EcologicalNetwork

  A = convert(BinaryNetwork, web_of_life("A_HP_001"))
  B = convert(BinaryNetwork, web_of_life("A_HP_002"))

  @test βs(A, A).a == richness(A)
  @test βs(A, A).b == 0
  @test βs(A, A).c == 0
  @test βs(B, B).a == richness(B)
  @test βs(B, B).b == 0
  @test βs(B, B).c == 0

  @test βs(A,B).a+βs(A,B).b == richness(B)
  @test βs(A,B).a+βs(A,B).c == richness(A)

  @test βos(A, A).a == links(A)
  @test βos(A, A).b == 0
  @test βos(A, A).c == 0

  @test βwn(A, A).a == links(A)
  @test βwn(A, A).b == 0
  @test βwn(A, A).c == 0

  X = first(nz_stream_foodweb())

  @test βos(X, X).a == links(X)
  @test βos(X, X).b == 0
  @test βos(X, X).c == 0

end
