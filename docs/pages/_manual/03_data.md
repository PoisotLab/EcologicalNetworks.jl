---
title : Datasets
author : Timothée Poisot
date : 11th April 2018
layout: default
slug: datasets
---




`EcologicalNetwork` currently comes with two datasets. The first is the
`http://www.web-of-life.es/` database of bipartite networks, accessible through
`web_of_life()`. The second is a collection of food webs from New-Zealand
streams, accessible through `nz_stream_foodweb()`.

## Web of life

Calling the `web_of_life()` function *without* arguments will return an array of
`NamedTuple`, which can be used to select the networks we want.

````julia
all_of_wol = web_of_life()
eurasia_rodents = filter(x -> contains(x[:Reference], "Hadfield"), all_of_wol)
rodents_id = getfield.(eurasia_rodents, :ID)
rodents_id[1:3]
````


````
3-element Array{SubString{String},1}:
 "A_HP_001"
 "A_HP_002"
 "A_HP_003"
````





Any of these identifiers can be passed to the `web_of_life()` function, which
will return the network:

````julia
web_of_life(first(rodents_id))
````


````
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}([2 321 … 0 0
; 262 8 … 2 0; … ; 0 0 … 0 0; 0 3 … 0 0], String["Ctenophthalmus pr
oximus", "Ctenophthalmus hypanis", "Ctenophthalmus inornatus", "Megabothris
 turbidus", "Ctenophthalmus shovi", "Amphipsylla rossica", "Myoxopsylla jor
dani", "Nosopsyllus fasciatus", "Leptopsylla segnis", "Leptopsylla taschenb
ergi", "Hystrichopsylla talpae", "Amphipsylla georgica", "Hystrichopsylla s
atunini", "Rhadinopsylla integella", "Ceratophyllus sciurorum", "Amalaraeus
 penicilliger", "Ctenophthalmus euxinicus", "Palaeopsylla caucasica"], Stri
ng["Microtus arvalis", "Apodemus sylvaticus", "Prometheomys schaposchnikowi
", "Apodemus mystacinus", "Microtus majori", "Dryomys nitedula", "Cricetulu
s migratorius", "Sorex araneus", "Chionomys nivalis", "Myoxus glis"])
````





Note that many networks in this dataset have issues on the original website. We
corrected as many as we found, based on a complete download from Apr 28, 2018.
We will replace this dataset with a more carefully curated source in the near
future.

## New Zealand streams

The `nz_stream_foodweb()` returns an array of unipartite networks. Some foodwebs
from the original dataset have been removed due to formatting issues. Again,
they will be replaced by a curated set of data in the future.
