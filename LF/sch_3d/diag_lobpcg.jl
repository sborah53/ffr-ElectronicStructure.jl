function diag_lobpcg( LF, ∇2, prec, Potentials, X0;
                      tol=1e-5, tol_avg=1e-7, maxit=200, verbose=false )
  #
  ncols = size(X0)[2]
  if ncols <= 0
    @printf("diag_lobpcg requires at least one initial wave function!\n");
    return
  end
  Npoints = size(X0)[1]
  # orthonormalize the initial wave functions.
  X = copy(X0)
  ortho_gram_schmidt!(X)

  W  = zeros(Float64, Npoints, ncols)

  HX = op_H( LF, ∇2, Potentials, X )

  nconv  = 0
  iter   = 1
  resnrm = ones(ncols,1)

  sum_evals = 0.0
  sum_evals_old = 0.0
  conv = 0.0
  while iter <= maxit && nconv < ncols
    # Rayleigh quotient (approximate eigenvalue, obj func)
    S = X'*HX
    lambda = eigvals(S)
    #
    # Check for convergence
    #
    sum_evals = sum(lambda)
    conv = abs(sum_evals - sum_evals_old)/ncols
    sum_evals_old = sum_evals
    R = HX - X*S
    if verbose
      @printf("LOBPCG iter = %8d, %18.10e\n", iter, conv)
    end
    if conv <= tol_avg
      if verbose
        @printf("LOBPCG convergence: tol_avg\n")
      end
      break
    end
    #
    for ic = 1:ncols
      resnrm[ic] = norm( R[:,ic] )
    end
    #
    #W = R[:,:]
    # apply preconditioner
    for ic = 1:ncols
      W[:,ic] = apply_prec_ilu0( prec, R[:,ic] )
    end
    #
    HW = op_H( LF, ∇2, Potentials, W )
    #
    C  = W'*W
    C = ( C + C' )/2
    R  = chol(C)
    W  = W/R
    HW = HW/R
    #
    Q  = [X W]
    HQ = [HX HW]
    if iter > 1
      Q  = [Q P]
      HQ = [HQ HP]
    end


    T = Q'*(HQ)
    T = (T+T')/2
    G = Q'*Q
    G = (G+G')/2
    sd, S = eig( T, G ) # evals, evecs
    U = S[:,1:ncols]
    X = Q*U
    HX = HQ*U
    if iter > 1
      set2 = ncols  +1:2*ncols
      set3 = 2*ncols + 1:3*ncols
      P  = W*U[set2,:]  + P*U[set3,:]
      HP = HW*U[set2,:] + HP*U[set3,:]
      C = P'*P
      C = (C + C')/2
      R = chol(C)
      P = P/R
      HP = HP/R
    else
      P  = copy(W)
      HP = copy(HW)
    end

    iter = iter + 1
  end

  S = X'*HX
  S = (S+S')/2
  lambda, Q = eig(S)
  X = X*Q
  if verbose
    for j = 1:ncols
      @printf("eigval[%2d] = %18.10f, resnrm = %18.10e\n", j, lambda[j], resnrm[j] )
    end
  end
  return lambda, X
end
