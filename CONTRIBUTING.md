# Guidelines for contributions

<!-- TODO -->

## Code style

### Functions

Functions must begin by a multi-line comment, and respect the `julia` convention
of having a lowercase name with no underscore.

``` julia
#=
This describes the function in one line

And this gives more details
=#
function fname(x::Type)
end
```
