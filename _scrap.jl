N = web_of_life("A_HP_003")

K = copy(N)
@progress for i in 1:20
    global K
    s1 = sample(species(K; dims=1), 2; replace=false)
    s2 = sample(species(K; dims=2), 2; replace=false)
    while (links(K[s1,s2]) < 4)&(minimum(K[s1,s2].A)<=1)
        s1 = sample(species(K; dims=1), 2; replace=false)
        s2 = sample(species(K; dims=2), 2; replace=false)
    end

    @info K[s1,s2].A

    m = rand(1:(maximum(K[s1,s2].A)-1))
    y = sample([[-1 1; 1 -1], [1 -1; -1 1]]).*m
    while minimum(K[s1,s2].A.+y) <= 1
        @info K[s1,s2].A.+y
        m = rand(1:(maximum(K[s1,s2].A)-1))
        y = sample([[-1 1; 1 -1], [1 -1; -1 1]]).*m
    end
    Y = typeof(K)(y, s1, s2)
    K = K + Y
    @info nodf(K)
end
