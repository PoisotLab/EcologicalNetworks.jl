# Motif enumeration

## Example

```@setup econet
using EcologicalNetwork
```

```@example econet
N = last(nz_stream_foodweb())
length(find_motif(N, unipartitemotifs()[:S1]))
```

## List of canonical motifs

```@docs
unipartitemotifs
```

## Motif counting

```@docs
find_motif
```

## Probabilistic case

```@docs
expected_motif_count
```
