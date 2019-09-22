#! octave

# Select a slice from an n-D array

# Problem
#
#   For an array A with arbitrary number of dimensions, select, for example, 
#   the first column. This would be A(:, 1) if A was 2-D, A(:, 1, :) if A was 
#   3-D, and so on.
#
# Solution
#
#   One possibility is to use subsref with the input idx created dynamically 
#   with repelems to have the right number of dimensions. 
#   This can be written as a function: 

function [B]= array_slice (A,k,d)
#return the k-th slice (row, column...) of A, with d specifying the dimension to slice on
  idx.type = "()";
  idx.subs = repelems ({':'}, [1;ndims(A)]);
  idx.subs(d) = k;
  B = subsref (A,idx);
endfunction

#test cases
%!shared A
%! A=rand(2, 3);
%!assert (array_slice (A,1,2), A(:, 1))
%! A=rand(2, 3, 4);
%!assert (array_slice (A,2,1), A(2, :, :))
%! A=rand(2, 3, 4, 5);
%!assert (array_slice (A,1,2), A(:, 1, :, :))
%! A=rand(2, 3, 4, 5, 6);
%!assert (array_slice (A,2,3), A(:, :, 2, :, :))

# To remove the singleton dimension d from the result B, use
#
#   B = reshape(B, [size(B)([1:d-1 d+1:end])]);
