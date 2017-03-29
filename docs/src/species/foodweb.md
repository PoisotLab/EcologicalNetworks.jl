# Food-web specific measures

## Measures of trophic level

These measure work by counting the distance to a primary producer -- where
"primary producer" is defined as the fact of not having outgoing interactions.
Primary producers have a trophic level of 1, and species that consume primary
producers have trophic levels of 2, etc. This represents a species' *fractional*
trophic level.

~~~@docs
fractional_trophic_level
~~~

Because some species higher-up the food chain eat preys at various fractional
trophic levels, there is also a more integrative measure -- the trophic level of
a species is the weighted average of the fractional trophic level of its preys:

~~~@docs
trophic_level
~~~

## Measures of trophic positions

For every species in a food web, this will return an array with its overall
position:

~~~@docs
foodweb_position
~~~
