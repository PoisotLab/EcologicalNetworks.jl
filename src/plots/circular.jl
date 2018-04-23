function circle_angle(p, N)
   return (p*2.0*π)/N
end

function angle_of_vector(x,y)
   hypotenuse = sqrt(x*x+y*y)
   θ = asin(y/hypotenuse)
   if x < 0.0
      θ = π - θ
   end
   if θ < 0.0
      θ += 2.0*π
   end
   return θ
end

function circular_network_plot{T<:AbstractEcologicalNetwork}(N::T; filename="network.png", steps=500, Θ=π/3, fontname="Noto Sans Condensed", fontsize=16)
   nodes = Dict([species(N)[i] => i for i in 1:richness(N)])
   angles = Dict([species(N)[i] => 0.0 for i in 1:richness(N)])

   # Radial barycenter algorithm
   for step in 1:steps
      for s1 in species(N)
         p1 = nodes[s1]
         sx = cos(circle_angle(p1, richness(N)))
         sy = sin(circle_angle(p1, richness(N)))
         if s1 in species(N,1)
            for s2 in species(N, 2)
               if has_interaction(N,s1,s2)
                  p2 = nodes[s2]
                  sx += cos(circle_angle(p2, richness(N)))
                  sy += sin(circle_angle(p2, richness(N)))
               end
            end
         end
         if s1 in species(N,2)
            for s2 in species(N, 1)
               if has_interaction(N,s2,s1)
                  p2 = nodes[s2]
                  sx += cos(circle_angle(p2, richness(N)))
                  sy += sin(circle_angle(p2, richness(N)))
               end
            end
         end
         angles[s1] = angle_of_vector(sx, sy)
      end

      nodes = Dict(zip(keys(angles), sortperm(collect(values(angles)))))
      angles = Dict([s => circle_angle(v, richness(N)) for (s,v) in nodes])
   end

   r = 400.0


   points = Dict([
   s => Point(r * cos(angles[s]), r * sin(angles[s])) for s in species(N)
   ])

   Drawing(1360, 1360, filename)
   setfont(fontname, fontsize)
   origin()

   circle_center = Point(0.0, 0.0)

   setline(3.5)
   setopacity(0.75)
   for s1 in species(N,1)
      has_int = false
      for s2 in species(N,2)
         if has_interaction(N, s1, s2)
            sethue("#222")
            p2, p1 = points[s1], points[s2]
            detp1p2 = (p1.x) * (p2.y) - (p2.x) * (p1.y) < 0
            if detp1p2
               p1, p2 = points[s1], points[s2]
            end
            mid = midpoint(p1, p2)
            chord_length = sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
            opposite_side = chord_length/2.0
            adjacent_side = opposite_side/(2.0*tan(Θ/2.0))
            dist_midpoint = sqrt(mid.x^2+mid.y^2)
            dist_adj = (dist_midpoint + adjacent_side)/dist_midpoint
            arc_center = between(circle_center, mid, dist_adj)
            arc2r(arc_center, p2, p1, :stroke)
         end
      end
   end

   setopacity(1.0)
   setline(2)

   for s in species(N)

      if typeof(N) <: AbstractBipartiteNetwork
         if s in species(N, 1)
            sethue(230/255, 159/255, 0/255)
         else
            sethue(0/255, 114/255, 178/255)
         end
      else
         sethue(0/255, 158/255, 115/255)
      end

      circle(points[s], 15, :fill)
      sethue("#222")
      circle(points[s], 15, :stroke)

      sethue("#000")

      tpos = between(circle_center, points[s], 1.05)
      this_angle = rad2deg(slope(circle_center, points[s]))
      align = "left"
      if 90 <= this_angle <= 270
         this_angle = this_angle+180
         align="right"
      end
      settext(string(s), tpos, angle=-this_angle, halign=align, valign="center")
   end
   finish()
end
