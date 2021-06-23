Networks are following the `AbstractArray` interface rather closely, with some
additional functionalities to get at interactions by using species names rather
than networks positions.

## Accessing elements

```@docs
getindex
```

## Changing elements

The ecological networks types are *all* mutable.

```@docs
setindex!
```

## Network size

```@docs
size
```