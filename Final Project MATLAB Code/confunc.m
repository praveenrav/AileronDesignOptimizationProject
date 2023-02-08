function [C,ceq] = confunc(x)
% Calculates constraint values to be used by fmincon()

% Extract design variables:
inner_loc = x(1);
outer_loc = x(2); 
C_a = x(3); 
delta_Amax = x(4);

% Calculate constraint functions:
c1 = outer_loc - inner_loc - 0.20;
c2 = 0.10 - outer_loc + inner_loc; 

% Output constraint values:
ceq = 0;
C = [c1 c2];
end