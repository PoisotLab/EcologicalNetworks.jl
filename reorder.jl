using EcologicalNetwork

a = rand((50, 50)) .* 0.05
a[1:25, 1:25] = rand((25, 25)) .* 0.6
a[26:50, 26:50] = rand((25, 25)) .* 0.8

N = make_bernoulli(BipartiteProbaNetwork(a))
L = rand(1:richness(N), richness(N))
P = label_propagation(N, L)

# We want to know the unique labels
labels = unique(P.L)
i_row = collect(1:size(N.A, 1))
i_col = size(N.A, 1) .+ collect(1:size(N.A, 2))

l_ord = sortperm(P.L)
r_ord = sortperm(l_ord[i_row])
c_ord = sortperm(l_ord[i_col])
R = typeof(N)(N[r_ord, c_ord])

plot_network(R, order=:none)

