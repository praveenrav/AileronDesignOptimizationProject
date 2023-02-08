function [c,ceq] = stocon(x)
%calculates stochastic constraint values to be used by fmincon

%%% Geometrical Features of Cessna 182:
b = 10.9728; % b wing span (GIVEN)
C = 1.63; % Wing chord in meters

% Wing, Horizontal Tail, and Vertical Tail Surface Areas (in units of m^2):
S_w = 21;
S_ht = 5.3; 
S_vt = 4.2; 
S_tot = S_w + S_ht + S_vt; % Sum of all three areas 

AR = (b^2)/S_w; % Aspect Ratio
C = b/AR; % Mean Wing Chord

Ixx = 1285.3; % Moment of inertia of Cessna 182

% Extract design variables:
inner_loc = x(1);
outer_loc = x(2); 
Ca_tau = x(3); 
delta_Amax = x(4);

Ca_b_ratio = Ca_tau/C;

% Listing variables with uncertainty:

% Calculate constraint functions:
c1 = inner_loc - outer_loc + 0.30; 
c2 = delta_Amax - 30;

% Output constraint values:
ceq = 0;
C = [c1 c2];

%output constraint values
ceq = 0;
c = [c1 c2 c3 c4 c5];
end