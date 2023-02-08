%% Deterministic and Stochastic Optimization

close all
clear
clc

x0 = [0.1 0.2 0.225 1]; % Initial values
options = optimoptions('fmincon','MaxIterations',200);

con = @(x) confunc(x); % Constraint function

%%% Find deterministic solution using fmincon():
[det_opt_vals, ~, ~, detData] = fmincon(@objective, x0, [], [], [], [], [0.6 0.6 0.15 0], [0.8 0.99 0.25 25], @confunc, options);
cDet = con(det_opt_vals);
fun_det = objective(det_opt_vals);
num_iter_det = detData.iterations;


%%% Find stochastic solution using fmincon():
[stoc_opt_vals, ~, ~, stocData] = fmincon(@objective_st, x0, [], [], [], [], [0.6 0.6 0.15 0], [0.8 0.99 0.25 25], @confunc, options);
[cDet,~] = con(stoc_opt_vals);
fun_stoc = objective(stoc_opt_vals);
num_iter = stocData.iterations;

%% Stochastic Optimization Results

close all
clear
clc

% Loading all data:
st1 = load('st1.mat');
st2 = load('st2.mat');
st3 = load('st3.mat');
st4 = load('st4.mat');
st5 = load('st5.mat');

% Iteration number values:
it1 = load('it1.mat');
it1 = it1.num_iter;

it2 = load('it2.mat');
it2 = it2.num_iter;

it3 = load('it3.mat');
it3 = it3.num_iter;

it4 = load('it4.mat');
it4 = it4.num_iter;

it5 = load('it5.mat');
it5 = it5.num_iter;

iter = [it1; it2; it3; it4; it5];

% Objective Function Values:
f1 = load('f1.mat');
f1 = f1.fun_stoc;

f2 = load('f2.mat');
f2 = f2.fun_stoc;

f3 = load('f3.mat');
f3 = f3.fun_stoc;

f4 = load('f4.mat');
f4 = f4.fun_stoc;

f5 = load('f5.mat');
f5 = f5.fun_stoc;

iter_vals = [f1; f2; f3; f4; f5]; % Containing all optimized function values from the 5 iterations

% Compiling results:
st_results = [st1.stoc_opt_vals; st2.stoc_opt_vals; st3.stoc_opt_vals; st4.stoc_opt_vals; st5.stoc_opt_vals];
st_results = [st_results, iter_vals, iter];


%% MCS:

close all
clear
clc

obj = @(x) objective_mcs(x);

% Iteration numbers for each layer of the MCS:
n_sim1 = 100;
n_sim2 = 1000;

% Empty placeholder vectors to store all desired information:
iter_vals_mins = []; % Empty vector to store optimized values of all important information

% Running the inner for loop for n_sim1 times to obtain more results
for j = 1:n_sim1
   
    iter_vals = []; % Empty vector to store all important information
    
    for i = 1:n_sim2
        % Design parameters to be optimized:
        x1 = (0.2*rand()) + 0.6; % Inner location of the aileron w.r.t. wing span
        x2 = (0.39*rand()) + 0.6; % Outer location of the aileron w.r.t. wing span
        x3 = (0.1*rand()) + 0.15; % Aileron chord
        x4 = 25*rand(); % Maximum aileron deflection
        
        x = [x1 x2 x3 x4]; % Combining all design parameters:
        
        func_val = obj(x); % Obtaining value of cost function
        
        % Constraints:
        if(((((x2 - x1) < 0.20)) && ((x2 - x1) > 0.10) && (x3 > 0.15) && (x3 < 0.25) && (isreal(func_val))))
            info_arr = [x1; x2; x3; x4; func_val];
            iter_vals = [iter_vals, info_arr];
        end

    end
    
    % Obtaining optimal point for each simulation of the nested for loop:
    func_vals_iter = iter_vals(5, :);
    [~, min_func_ind] = min(func_vals_iter);
    
    if(length(min_func_ind) > 1)
        min_func_ind = min_func_ind(1);
    end
    
    iter_vals_min = iter_vals(:, min_func_ind);
    iter_vals_mins = [iter_vals_mins, iter_vals_min];
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

% Obtaining optimal point for all (n_sim1 * n_sim2) simulations:
func_vals_mins = iter_vals_mins(5, :);
[~, min_func_ind2] = min(func_vals_mins);
iter_vals_min = iter_vals_mins(:, min_func_ind2);
iter_vals_min = iter_vals_min';