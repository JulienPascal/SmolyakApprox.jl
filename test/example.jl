# This code presents an example to illustrate how SmolyakApprox can be used

using SmolyakApprox

function test_smolyak_approx()

  d  = 5  # Set the number of dimensions
  mu = 3  # Set the level of approximation

  grid, multi_ind = smolyak_grid(chebyshev_gauss_lobatto,d,mu)  # Construct the Smolyak grid and the multi index

  # An arbitrary test function

  function test(grid)

    y = (grid[:,1].+1).^0.1.*exp.(grid[:,2]).*log.(grid[:,3].+2).^0.2.*(grid[:,4].+2).^0.8.*(grid[:,5].+7).^0.1

    return y

  end

  y = test(grid)  # Evaluate the test function on the Smolyak grid

  point = [0.75, 0.45, 0.82, -0.15, -0.95]  # Choose a point to evaluate the approximated function

  # One way of computing the weights and evaluating the approximated function

  weights = smolyak_weights(y,grid,multi_ind)        # Compute the Smolyak weights
  y_hat = smolyak_evaluate(weights,point,multi_ind)  # Evaluate the approximated function

  #= A second way of computing the weights and evaluating the approximated function that
  computes the interpolation matrix just once. =#

  interp_mat = smolyak_inverse_interpolation_matrix(grid,multi_ind)  # Compute the interpolation matrix
  w = smolyak_weights(y,interp_mat)             # Compute the Smolyak weights
  y_hatt = smolyak_evaluate(w,point,multi_ind)  # Evaluate the approximated function

  # Evaluate the exact function at point

  y_actual = test(point')

  return y_hat, y_hatt, y_actual

end

test_smolyak_approx()
