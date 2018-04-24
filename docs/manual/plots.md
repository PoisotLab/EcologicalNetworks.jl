---
title : Drawing networks
author : Timothée Poisot
date : 11th April 2018
layout: default
---




The network representations have been taken from @McG12. They are not meant to
offer a full network visualisation suite, but they allow to create pictures to
explore network structure. All data visualisation relies on the `Luxor` package --
this means that networks can be produced as `.png`, `.svg`, and `.pdf` files.

All layouts have a number of common options, passed as *keyword* arguments:

1. `filename` -- the name/path of the figure (defaults to `network.png`)
2. `fontname` -- the name of the font for labels (defaults to `Noto Sans Condensed`)
3. `fontsize` -- the size of the font for labels (defaults to `16`)
4. `steps` -- the number of layout positioning steps to do (defaults to `500` for circular, `15000` for graph)
5. `names` -- whether to display the species names (default to `true`) or not

Additionally, all functions share similarities in their output. In bipartite
networks, nodes from the top level are orange, and the bottom level nodes are
blue. In unipartite networks, all nodes are green. The colors come from @Won11 --
and have been picked to ensure maximum dissimilarity under normal vision,
deuteranopia, tritanopia, and protanopia.

This page will illustrate the currently implemented layouts using a bipartite
and a unipartite network:

````julia
N = fonseca_ganade_1996()
U = thompson_townsend_catlins()
````





## Circular layout

In the circular layout, all nodes are laid out on the diameter of a circle.
Nodes that are densely connected are moved together (as much as possible).
Interactions are represented by arcs of constant angle -- larger angles mean
that the interactions are essentially lines, and smaller angles have a more
pronounced bend. The parameter regulating the angle is `Θ`, which defaults to
`π/3`.

Circular layouts have a default number of steps of 500 -- this is much more than
needed, in many cases, but this will ensure that larger networks are close to
the "best" layout.

In the circular layout, self-interactions are currently *not* represented.

````julia
circular_network_plot(N; filename=joinpath(working_path, "circular_fg96.png"));
````





![Circular layout](/figures/circular_fg96.png)

````julia
circular_network_plot(U; filename=joinpath(working_path, "circular_ttc.png"));
````





![Circular layout](/figures/circular_ttc.png)

## Graph layout

Compared to circular layouts, graph layouts are a whole other beast. You know
how in some recipes, the only way to have it turn out great is to accept that it
will cook for a long time over low heat? Well, graph layouts are like this. We
have hard-coded a very small maximum allowed displacement (the "heat") per step,
which means that the overall behaviour is much more stable, *but* we need a lot
of steps to reach an equilibrium.

The graph layout implemented here has three main ingredients: all nodes want to
move away from every other node, connected nodes are brought closer together by
their interactions. and the center is pulling all nodes to itself (with a
strength of one-tenth of an interaction). All of this means that all points will
end up in a circle, and the connected components or modules will be well
isolated from one another. Bipartite networks, in particular, tend to be very
pretty when represented this way.

But it takes time... Specifically, the default number of steps is `15000` (this
is often not enough, and we recommend using `60000` if you need to make a very
nice figure).

The final product is determined by two parameters: the spring constant `L`,
which acts as a sort of *scale* of the network, and the repulsion/attraction
ratio `R`, which determines the coefficient of attraction *relative* to the
coefficient of repulsion [@McG12]. The defaults values of `L=50` and `R=0.05`
give generally sensible results:

````julia
graph_network_plot(N; filename=joinpath(working_path, "graph_fg96.png"), steps=1000);
````





![Circular layout](/figures/graph_fg96.png)

````julia
graph_network_plot(U; filename=joinpath(working_path, "graph_ttc.png"), steps=1000);
````





![Circular layout](/figures/graph_ttc.png)