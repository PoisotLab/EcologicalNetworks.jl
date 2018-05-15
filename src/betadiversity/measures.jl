""" Whittaker measure of beta-diversity """
function whittaker{T<:NamedTuple}(S::T)
  return (S.a+S.b+S.c)/((S.a + (S.a+S.b+S.c))/2.0) - 1.0
end

""" Sorensen measure of beta-diversity """
function sorensen{T<:NamedTuple}(S::T)
  return (2.0*S.a)/(S.a + (S.a+S.b+S.c))
end

""" Jaccard measure of beta-diversity """
function jaccard{T<:NamedTuple}(S::T)
  return S.a/(S.a+S.b+S.c)
end

""" Gaston measure of beta-diversity """
function gaston{T<:NamedTuple}(S::T)
  return (S.b+S.c)/(S.a+S.b+S.c)
end

""" Williams measure of beta-diversity """
function williams{T<:NamedTuple}(S::T)
  return minimum(vec([S.b S.c]))/(S.a+S.b+S.c)
end

""" Lande measure of beta-diversity """
function lande{T<:NamedTuple}(S::T)
  return (S.b + S.c)/2.0
end

""" Ruggiero measure of beta-diversity """
function ruggiero{T<:NamedTuple}(S::T)
  return (S.a)/(S.a + S.c)
end

""" Harte-Kinzig measure of beta-diversity """
function hartekinzig{T<:NamedTuple}(S::T)
  return 1.0 - (2.0 * S.a)/(S.a + (S.a+S.b+S.c))
end

""" Harrison measure of beta-diversity """
function harrison{T<:NamedTuple}(S::T)
  return minimum(vec([S.b S.c]))/(minimum(vec([S.b S.c])) + S.a)
end
