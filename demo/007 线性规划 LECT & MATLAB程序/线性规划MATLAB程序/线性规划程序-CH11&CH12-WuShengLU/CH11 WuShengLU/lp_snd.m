% Program: lp_snd.m
% Title: Simplex algorithm for standard-form LP problems
% with non-degenerate vertices.
% Description: Implements Algorithm 11.3 for standard-form 
% LP problems with non-degenerate vertices.
% Theory: See Practical Optimization Sec. 11.3.2.2.
% Input:  
%    A, b, c - input data matrices
%    x0 - a feasible initial point
% Output:        
%    xs - a vertex minimizer.
%    fs - objective function at xs
%    k - number of iteration at convergence
% Example:
% Find a minimizer of the standard-form LP problem
%    minimize c'*x 
%    subject to A*x = b, x>=0.
% where
%    A = [-2 2 1 -1 0; 1 4 -1 0 -1]
%    b = [1 1]'
%    c = [2 9 3 0 0]'
% The initial point is given by
%    x0 = [0 0.5 0 0 1]'
% Solution:
% Execute the command
%    [xs,fs,k] = lp_snd(A,b,c,x0)
% ====================================================
function [xs,fs,k] = lp_snd(A,b,c,x0)
disp('    ')
disp('Program lp_snd.m')
k = 0;
[p,n] = size(A);
I0 = (1:1:n)';
x = find_vs(A,b,x0);
I1 = find(abs(x) > 1e-10);
L1 = length(I1);
if L1 == p,
 IB = I1;
 else
   A1 = A(:,I1);
   r1 = rank(A1);
   I2 = setdiff(I0,I1);
   for i = 1:n-L1,
      if r1 < p & rank([A1 A(:,I2(i))]) > r1,
         A1 = [A1 A(:,I2(i))];
         I1 = [I1; I2(i)];
         r1 = r1 + 1;
      end
   end
 IB = sort(I1);
end  
IN = setdiff(I0,IB);
B = A(:,IB);
N = A(:,IN);
xB = x(IB);
while 1,
 cB = c(IB);
 cN = c(IN);
 mu_h = cN-N'*(inv(B')*cB);
 if min(mu_h) > -1e-10,
  break
 end
 [y,l] = min(mu_h);
 dB = -inv(B)*N(:,l);
 I3 = find(dB <= -1e-10);
 if isempty(I3),
   disp('The objective function is unbounded from below.')
   xs = [];
   fs = [];
   return
 end
 [alpha, j1] = min(xB(I3)./(-dB(I3)));
 js = I3(j1);
 xB = xB + alpha*dB;
 xB(js) = alpha;
 tmp = IB(js);
 IB(js) = IN(l);
 IN(l) = tmp;
 B = A(:,IB);
 N = A(:,IN);
 x = zeros(n,1);
 x(IB) = xB;
 k = k + 1;
end
xs = x;
fs = c'*xs;