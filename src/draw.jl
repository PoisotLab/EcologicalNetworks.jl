"""
**Plot a bipartite network (ordered by degree)**
"""
@recipe function f(n::Bipartite)

   legend --> false
   grid --> false
   ticks --> nothing
   foreground_color_axis --> nothing
   foreground_color_border --> nothing

   markersize --> 10
   markerstrokewidth --> 0.8
   markerstrokecolor --> colorant"#888888"

   # Re-order the matrix by degree
   dout = degree_out(n)
   din  = degree_in(n)
   rout = sortperm(dout, rev=true)
   rin  = sortperm(din, rev=true)
   n.A = n.A[rout, rin]

   largest_dim = maximum(size(n))
   smallest_dim = minimum(size(n))
   xlims := (0, largest_dim+1)
   ylims := (-1, 8)

   if size(n.A,1) > 1
      x_top = collect(linspace(1, largest_dim, size(n.A,1)))
   else 
      x_top = [mean([1, largest_dim])]
   end
   y_top = [7 for i in x_top]

   if size(n.A,2) > 1
      x_bot = collect(linspace(1, largest_dim, size(n.A,2)))
   else 
      x_bot = [mean([1, largest_dim])]
   end
   y_bot = [0 for i in x_bot]

   for i in 1:size(n)[1]
      for j in 1:size(n)[2]
         if has_interaction(n, i, j)
            @series begin
               color --> colorant"#888888"
               xi = [x_top[i], x_bot[j]]
               yi = [y_top[i].-0.30, y_bot[j].+0.30]
               xi, yi
            end
         end
      end
   end

   # Draw the top layer
   @series begin
      seriestype --> :scatter
      markercolor --> colorant"#f1a340"
      marker --> :circle
      x_top, y_top
   end

   # Draw the bottom layer
   @series begin
      seriestype --> :scatter
      markercolor --> colorant"#998ec3"
      marker --> :rect
      x_bot, y_bot
   end

end

"""
**Plot a bipartite network (order by module)**
"""
@recipe function f(n::Bipartite, p::Partition)

   legend --> false
   grid --> false
   ticks --> nothing
   foreground_color_axis --> nothing
   foreground_color_border --> nothing

   markersize --> 10
   markerstrokewidth --> 0.8
   markerstrokecolor --> colorant"#888888"

   # Re-order the matrix by module
   module_ids = unique(p.L)
   module_richness = vec(sum(p.L .== module_ids', 1))
   module_order = module_ids[sortperm(module_richness)]
   module_top = p.L[1:size(n.A,1)]
   module_bot = p.L[(length(module_top)+1):end]

   # Order the top level
   top_order = zeros(module_top)
   i = 0
   for m in module_order
       sub_samp = filter(x -> module_top[x] == m, 1:size(n.A,1))
       #sub_samp = sub_samp[sortperm(degree_out(n)[sub_samp])]
       top_order[(i+1):(i+length(sub_samp))] = sub_samp
       i = i + length(sub_samp)
   end

   # Order the bottom level
   bot_order = zeros(module_bot)
   i = 0
   for m in module_order
       sub_samp = filter(x -> module_bot[x] == m, 1:size(n.A,2))
       #sub_samp = sub_samp[sortperm(degree_in(n)[sub_samp])]
       bot_order[(i+1):(i+length(sub_samp))] = sub_samp
       i = i + length(sub_samp)
   end

   largest_dim = maximum(size(n))
   smallest_dim = minimum(size(n))
   xlims := (0, largest_dim+1)
   ylims := (-1, 8)

   if size(n.A,1) > 1
      x_top = collect(linspace(1, largest_dim, size(n.A,1)))
   else 
      x_top = [mean([1, largest_dim])]
   end
   y_top = [7 for i in x_top]
   x_top = x_top[top_order]

   if size(n.A,2) > 1
      x_bot = collect(linspace(1, largest_dim, size(n.A,2)))
   else 
      x_bot = [mean([1, largest_dim])]
   end
   y_bot = [0 for i in x_bot]
   x_bot = x_bot[bot_order]

   for i in 1:size(n)[1]
      for j in 1:size(n)[2]
         if has_interaction(n, i, j)
            @series begin
               color --> colorant"#888888"
               xi = [x_top[i], x_bot[j]]
               yi = [y_top[i].-0.30, y_bot[j].+0.30]
               xi, yi
            end
         end
      end
   end

   # Draw the top layer
   @series begin
      seriestype --> :scatter
      markercolor --> colorant"#f1a340"
      marker --> :circle
      x_top, y_top
   end

   # Draw the bottom layer
   @series begin
      seriestype --> :scatter
      markercolor --> colorant"#998ec3"
      marker --> :rect
      x_bot, y_bot
   end

end

