# Calculate structure factor
# special case: only for 1 species with Z = 1
function structure_factor( Xpos::Array{Float64,2}, G::Array{Float64,2} )
    Ng = size(G)[2]
    Na = size(Xpos)[2]
    println("Natoms = $(Na)")
    Sf = zeros(ComplexF64,Ng)
    for ia = 1:Na
        for ig = 1:Ng
            GX = Xpos[1,ia]*G[1,ig] + Xpos[2,ia]*G[2,ig] + Xpos[3,ia]*G[3,ig]
            Sf[ig] = Sf[ig] + cos(GX) - im*sin(GX)
        end
    end
    return Sf
end
