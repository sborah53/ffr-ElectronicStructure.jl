using Printf

include("constants.jl")
include("alias.jl")
include("utils.jl")
include("PGBF.jl")
include("CGBF.jl")
include("overlap.jl")
include("Atoms.jl")
include("sto3g.jl")
include("BasisSet.jl")

function test_old(filename)
    atoms = init_atoms_xyz(filename)
    println(atoms)

    basis = build_basis(atoms)
    Nbasis = length(basis)
    
    println("\nNbasis = ", Nbasis)
    for i = 1:Nbasis
        @printf("------------\n")        
        @printf("basis #%d\n", i)
        @printf("------------\n")
        println(basis[i])
    end
end

function test_new(filename)
    atoms = init_atoms_xyz(filename)
    println(atoms)

    basis = build_basis_new(atoms)
    Nbasis = length(basis)
    
    println("\nNbasis = ", Nbasis)
    for i = 1:Nbasis
        @printf("------------\n")        
        @printf("basis #%d\n", i)
        @printf("------------\n")
        println(basis[i])
    end
end

#test_old("H2O.xyz")
test_new("H2O.xyz")
