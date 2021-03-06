# System

- Complete implementation of `latgen_*`, for both PWSCF and ASE version.
- ASE `Atoms`-like data structure

# Poisson solver

- Implement Poisson solver for isolated, polymer and surface boundary condition.

# Iterative diagonalization

- Tidy up blocked-Davidson implementation
- Enable locking in LOBPCG

# Direct minimization

- Original Beigi-Arias CG algorithm
- Direct minimization for multiple k-points
- Direct minimization for metals


# Self-consistent field

- SCF for multiple k-points
- Implement Chebyshev filtered-subspace iteration for SCF
- Potential mixing as an alternative to density mixing
- Various methods for charge mixing: Broyden, Anderson, etc



# Hamiltonian

- Non-local pseudopotentials
