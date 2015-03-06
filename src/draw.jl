function draw_matrix(A::Array{Float64,2}; transform = (x) -> 1-x, file="pen.png")
   nbot, ntop = size(A)
   width  = 4 + nbot*(10+4)
   height = 4 + ntop*(10+4)
   # Initialize device
   c = CairoRGBSurface(width, height)
   cr = CairoContext(c)
   save(cr)
   # Background
   set_source_rgba(cr, 1.0, 1.0, 1.0, 1.0)
   rectangle(cr, 0.0, 0.0, float(width), float(height))
   fill(cr)
   restore(cr)
   save(cr)
   # Draw the blocks
   for top in 1:ntop
      for bot in 1:nbot
         p = transform(A[bot,top])
         set_source_rgb(cr, p, p, p)
         rectangle(cr, 4 + (bot-1)*14, 4 + (top-1)*14, 10, 10)
         fill(cr)
         save(cr)
      end
   end
   write_to_png(c, file)
end
