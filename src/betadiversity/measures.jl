"""
    KGL01(S::T)

Whittaker
"""
function KGL01(S::T) where {T<:NamedTuple}
  return (S.a+S.b+S.c)/((S.a + (S.a+S.b+S.c))/2.0)
end

function KGL02(S::T) where {T<:NamedTuple}
  return KGL01(S).-1.0
end

function KGL03(S::T) where {T<:NamedTuple}
  return (S.b + S.c)/2.0
end

function KGL04(S::T) where {T<:NamedTuple}
  return S.b + S.c
end

function KGL05(S::T) where {T<:NamedTuple}
  return ((S.a+S.b+S.c)^2)/((S.a+S.b+S.c)^2-2*S.b*S.c)-1.0
end

function KGL06(S::T) where {T<:NamedTuple}
  one_over_sum = 1/(2*S.a+S.b+S.c)
  s1 = (S.a+S.b)*log(S.a+S.b)
  s2 = (S.a+S.c)*log(S.a+S.c)
  return log(2*S.a+S.b+S.c)-(one_over_sum*2*S.a*log(2))-(one_over_sum*(s1+s2))
end

function KGL07(S::T) where {T<:NamedTuple}
  return exp(KGL06(S))-1.0
end

function KGL08(S::T) where {T<:NamedTuple}
  return (S.b + S.c) / (2*S.a + S.b + S.c)
end

function KGL09(S::T) where {T<:NamedTuple}
  return KGL08(S)
end

function KGL10(S::T) where {T<:NamedTuple}
  return S.a / (S.a + S.b + S.c)
end

function KGL11(S::T) where {T<:NamedTuple}
  return (2*S.a) / (2*S.a + S.b + S.c)
end

function KGL12(S::T) where {T<:NamedTuple}
  return (2*S.a+S.b+S.c) * ( 1 - (S.a/(S.a+S.b+S.c)))
end

function KGL13(S::T) where {T<:NamedTuple}
  return min(S.b, S.c) / (max(S.b, S.c) + S.a)
end

function KGL14(S::T) where {T<:NamedTuple}
  return 1 - (S.a*(2*S.a+S.b+S.c))/(2*(S.a+S.b)*(S.a+S.c))
end

function KGL15(S::T) where {T<:NamedTuple}
  return (S.b + S.c)/(S.a + S.b + S.c)
end

function KGL16(S::T) where {T<:NamedTuple}
  return KGL15(S)
end

function KGL17(S::T) where {T<:NamedTuple}
  return min(S.b, S.c)/(S.a+S.b+S.c)
end

function KGL18(S::T) where {T<:NamedTuple}
  return (S.b+S.c)/2
end

function KGL19(S::T) where {T<:NamedTuple}
  return ((S.b*S.c)+1)/((S.a+S.b+S.c)^2-(S.a+S.b+S.c)/2)
end

function KGL20(S::T) where {T<:NamedTuple}
  return 1 - (2*S.a)/(2*Sa.+S.b+S.c)
end

function KGL21(S::T) where {T<:NamedTuple}
  return S.a/(S.a+S.c)
end

function KGL22(S::T) where {T<:NamedTuple}
  return min(S.b, S.c)/(min(S.b, S.c) + S.a)
end

function KGL23(S::T) where {T<:NamedTuple}
  return 2*abs(S.b-S.c)/(2*S.a+S.b+S.c)
end

function KGL24(S::T) where {T<:NamedTuple}
  in_par = (2*S.a+S.b+S.c)/(S.a+S.b+S.c)
  return 1-log(in_par)/log(2)
end
