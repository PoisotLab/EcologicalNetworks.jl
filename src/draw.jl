"""
Draw a network as a matrix to a png file. In the case of a quantitative or
probabilistic network, nuances of grey indicate interaction strength.

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
Low-level function to draw the network.
"""
function draw_matrix(A::Array{Float64,2}; file="ecologicalnetwork.png")
    nbot, ntop = size(A)
    # Check size
    @assert nbot <= 4000
    @assert ntop <= 4000
    # Get image size
    width  = 4 + nbot*(10+4)
    height = 4 + ntop*(10+4)
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
            p = 1.0 - A[bot,top]
            set_source_rgb(cr, p, p, p)
            rectangle(cr, 4 + (bot-1)*14, 4 + (top-1)*14, 10, 10)
            fill(cr)
            Cairo.save(cr)
        end
    end
    write_to_png(c, file)
end
