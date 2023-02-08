function [f] = objective_st(x)

%%% Extracting input information:
inner_loc = x(1); % Inner location of the aileron w.r.t. wing span
outer_loc = x(2); % Outer location of the aileron w.r.t. wing span
C_a = x(3); % Aileron chord
delta_Amax = x(4); % Maximum aileron deflection


%%% Geometrical Features of Cessna 182:
b = 10.9728; % b wing span (GIVEN)
C = 1.63; % Wing chord in meters

Ca_b_ratio = C_a/C; % Calculating Ca/C ratio

% Wing, Horizontal Tail, and Vertical Tail Surface Areas (in units of m^2):
S_w = 21;
S_ht = 5.3; 
S_vt = 4.2; 
S_tot = S_w + S_ht + S_vt; % Sum of all three areas 

AR = (b^2)/S_w; % Aspect Ratio
C = b/AR; % Mean Wing Chord

Ixx = wblpdf(90, 1) + 1285.3; % Moment of inertia of Cessna 182 (Weibull Distribution with scale parameter of 90 and shape parameter of 1)

%%% Desired Bank Angles:
phi_des_deg = 30; % Desired bank angle in degrees
phi_des_rad = (phi_des_deg .* pi)/180; % Desired angle in radians

L_ail = (b/2) .* (outer_loc - inner_loc); % Calculated length of aileron in meters

lambda = 0.8; % Taper ratio of wing
rho_air = 1.225; % Density of air  

% Calculating Wind Speed:
Vs = 55; % Stall speed in knots
stall_coeff = normrnd(1.2, 0.03); % Values ranging from 1.1 to 1.3 (Do normal distribution with mu of 1.2 and std of 0.03)
V_app = (stall_coeff * Vs)/1.94384; % Convert to m/s

drag_momarm_percentage = 0.4;

C_D_R = (0.3 .* rand(1)) + 0.8; % Rolling drag coefficient (uncertainty as it ranges from 0.8 to 1.1)

C_r = (1.5*C)/((1+lambda+lambda^2)/(1+lambda)); % Wing Root Chord

C_l_del_w = 4.5; % Idk how to calculate so leave constant 
yi = inner_loc * (b/2); % Inboard position of aileron
yo = outer_loc * (b/2); % Outboard position of aileron

tau = get_tau(Ca_b_ratio); % Aileron effectiveness parameter from Figure 12.12 From aileron to wing chord ratio --> Maybe linear regression

% Aileron Rolling Moment Coefficient Derivative:
C_l_del_A_p1 = ((2 * C_l_del_w * tau * C_r)/(S_w * b));
C_l_del_A_p2 = ((yo^2/2)+((2/3)*((lambda-1)/b))*(yo^3));
C_l_del_A_p3 = ((yi^2/2)+((2/3)*((lambda-1)/b))*(yi^3));
C_l_del_A = C_l_del_A_p1*(C_l_del_A_p2-C_l_del_A_p3); 

delta_A = delta_Amax/57.3;

C_l = C_l_del_A * delta_A; % Roll control derivative 

L_A = 0.5 * rho_air * (V_app^2) * S_w * C_l * b; % Aircraft Rolling Moment

yD = drag_momarm_percentage * (b/2); % Drag moment arm - 40% of wing span

Pss = sqrt((2 * L_A)/(rho_air * S_tot * C_D_R * (yD.^3))); % Steady state roll rate 

phi1 = (Ixx/(rho_air * (yD^3) * S_tot * C_D_R)) * log(Pss^2); % Bank angle of steady state roll rate
P_dot = (Pss.^2)/(2 * phi1); % Derivative of roll rate

% Conditional statement to calculate t2:
if(phi1 >= phi_des_deg)
    t2 = sqrt((2 .* phi_des_rad)./P_dot); % If the time to turn is less than the time to achieve Pss
else
    t2 = sqrt((2 .* phi1)./P_dot) + ((1./Pss).*(phi_des_deg - phi1)); % If the time to turn is more than the time to achieve Pss
end

P_turn = 0.06.*t2; % Cost of turning

rho_mat = 2833; % Density of the material
P_material = 9.55 * rho_mat * S_tot * 0.2; % Volume = rho * S_tot * 0.2

P_dm = 515000*0.27*(((outer_loc-inner_loc)*S_w)/S_w); % Cost of manufacturing

% Compute objective function (total cost):
f = P_turn+ P_material + P_dm;

end


