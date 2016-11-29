using EcologicalNetwork

N = bluthgen()
L = rand(1:richness(N), richness(N))
P = best_partition(modularity(N, L))[1]

# We want to know the unique labels
labels = unique(P.L)
i_row = collect(1:size(N.A, 1))
i_col = size(N.A, 1) .+ collect(1:size(N.A, 2))

l_ord = sortperm(P.L)
r_ord = sortperm(l_ord[i_row])
c_ord = sortperm(l_ord[i_col])
R = typeof(N)(N[r_ord, c_ord])

plot_network(R, order=:none)

