""" Whittaker measure of beta-diversity """
function whittaker(S::T) where {T<:NamedTuple}
  return (S.a+S.b+S.c)/((S.a + (S.a+S.b+S.c))/2.0) - 1.0
end

""" Sorensen measure of beta-diversity """
function sorensen(S::T) where {T<:NamedTuple}
  return (2.0*S.a)/(S.a + (S.a+S.b+S.c))
end

""" Jaccard measure of beta-diversity """
function jaccard(S::T) where {T<:NamedTuple}
  return S.a/(S.a+S.b+S.c)
end

""" Gaston measure of beta-diversity """
function gaston(S::T) where {T<:NamedTuple}
  return (S.b+S.c)/(S.a+S.b+S.c)
end

""" Williams measure of beta-diversity """
function williams(S::T) where {T<:NamedTuple}
  return minimum(vec([S.b S.c]))/(S.a+S.b+S.c)
end

""" Lande measure of beta-diversity """
function lande(S::T) where {T<:NamedTuple}
  return (S.b + S.c)/2.0
end

""" Ruggiero measure of beta-diversity """
function ruggiero(S::T) where {T<:NamedTuple}
  return (S.a)/(S.a + S.c)
end

""" Harte-Kinzig measure of beta-diversity """
function hartekinzig(S::T) where {T<:NamedTuple}
  return 1.0 - (2.0 * S.a)/(S.a + (S.a+S.b+S.c))
end

""" Harrison measure of beta-diversity """
function harrison(S::T) where {T<:NamedTuple}
  return minimum(vec([S.b S.c]))/(minimum(vec([S.b S.c])) + S.a)
end
