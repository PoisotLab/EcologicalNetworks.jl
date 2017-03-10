"""
**Draw a network as a matrix to a png file**

    plot_network(N::EcoNetwork; order::Symbol=:degree, transform::Function=(x) -> x, file="en.png")

In the case of a quantitative or probabilistic network, nuances of grey indicate
interaction strength.

Arguments:
1. `N::EcoNetwork`, the network to draw

Keywords:
- `order::Symbol`, either `:none` or `:degree` (default), the criteria to use to re-order nodes
- `transform::Function`, the function to apply to every interaction (`x -> x` by default, but can be `sqrt`, `log`, ...)
- `file`, the name of the file (with the `.png` extension) to write to

"""
function plot_network(N::EcoNetwork; order::Symbol=:degree, transform::Function=(x) -> x, file="en.png")
    @assert order ∈ [:degree, :none]

    # Convert to floating point values
    A = map(Float64, N.A)

    # Ranges the matrix in 0-1
    A = A ./ maximum(A)

    # Apply the transformation if needed
    for i in eachindex(A)
        A[i] = A[i] == 0.0 ? 0.0 : transform(A[i])
    end

    # If we re-order the species by degree...
    if order == :degree
        if typeof(N) <: Unipartite
            ord = sortperm(degree(N))
            A = A[ord, ord]
        else
            ord_row = sortperm(degree_out(N))
            ord_col = sortperm(degree_in(N))
            A = A[ord_row, ord_col]
        end
    end

    # Draw the matrix
    draw_matrix(A, file=file)

end

"""
**Draw a network as a matrix to a png file**

    plot_network(N::EcoNetwork, P::Partition; order::Symbol=:degree, transform::Function=(x) -> x, file="en.png")

Respects the modules of every nodes. In the case of a quantitative or
probabilistic network, nuances of grey indicate interaction strength.

Arguments:
1. `N::EcoNetwork`, the network to draw
1. `P::Partition`, the partition of the network

Keywords:
- `order::Symbol`, either `:none` or `:degree` (default), the criteria to use to re-order nodes within modules
- `transform::Function`, the function to apply to every interaction (`x -> x` by default, but can be `sqrt`, `log`, ...)
- `file`, the name of the file (with the `.png` extension) to write to

"""
function plot_network(N::EcoNetwork, P::Partition; order::Symbol=:degree, transform::Function=(x) -> x, file="en.png")
    @assert order ∈ [:degree, :none]

    # Convert to floating point values
    A = map(Float64, N.A)

    # Ranges the matrix in 0-1
    A = A ./ maximum(A)

    # Apply the transformation if needed
    for i in eachindex(A)
        A[i] = A[i] == 0.0 ? 0.0 : transform(A[i])
    end

    # Re-order nodes by module

end

"""
**Low-level function to draw the network**
"""
function draw_matrix(A::Array{Float64,2}; file="ecologicalnetwork.png")
  nbot, ntop = size(A)
  # Check size
  @assert nbot <= 4000
  @assert ntop <= 4000
  # Get image size
  _GAP = 6
  _WDT = 18
  _TTL = _GAP + _WDT
  width  = _GAP + nbot*(_TTL)
  height = _GAP + ntop*(_TTL)
  # Initialize device
  c = CairoRGBSurface(width, height)
  cr = CairoContext(c)
  Cairo.save(cr)
  # Background
  set_source_rgba(cr, 1.0, 1.0, 1.0, 1.0)
  rectangle(cr, 0.0, 0.0, float(width), float(height))
  fill(cr)
  restore(cr)
  Cairo.save(cr)
  # Draw the blocks
  for top in 1:ntop
    for bot in 1:nbot
      if A[bot,top] > 0.0
        p = 1.0 - A[bot,top]
        set_source_rgb(cr, p, p, p)
        rectangle(cr, _GAP + (bot-1)*_TTL, _GAP + (top-1)*_TTL, _WDT, _WDT)
        fill(cr)
        Cairo.save(cr)
        set_source_rgb(cr, 0.0, 0.0, 0.0)
        set_line_width(cr, _GAP/4)
        rectangle(cr, _GAP + (bot-1)*_TTL, _GAP + (top-1)*_TTL, _WDT, _WDT)
        stroke(cr)
        Cairo.save(cr)
      end
    end
  end
  write_to_png(c, file)
end
