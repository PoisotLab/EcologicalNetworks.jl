function thompson_townsend_catlins()
  n_path = joinpath(@__DIR__, "../..", "data", "catlins.csv")
  content = readdlm(n_path, ';')
  species_names = convert(Array{String}, content[:,1][2:end])
  interaction_matrix = map(Int64, content[2:end,2:end]).>0
  interaction_matrix = convert(Array{Bool,2}, interaction_matrix)
  UnipartiteNetwork(interaction_matrix, species_names)
end
