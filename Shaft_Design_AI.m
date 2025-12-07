function shaft_diameter_calculator()
% Interactive MATLAB tool for machinists to estimate shaft diameter
% Follows Shigley DE-Goodman method (similar to Ex 7-1)

clear; clc; close all;

fprintf('=== Shaft Diameter Calculator (DE-Goodman) ===\n');

% Input loads
M_min = input('Minimum bending moment (lb·in): ');
M_max = input('Maximum bending moment (lb·in): ');
T_min = input('Minimum torque (lb·in): ');
T_max = input('Maximum torque (lb·in): ');

M_m = (M_max + M_min)/2;    % Midrange bending [web:11]
M_a = (M_max - M_min)/2;    % Alternating bending [web:11]
T_m = (T_max + T_min)/2;    % Midrange torque [web:11]
T_a = (T_max - T_min)/2;    % Alternating torque [web:11]

% Material properties
S_ut = input('Ultimate strength S_ut (ksi): ') * 1000;  % Convert to psi
S_y  = input('Yield strength S_y (ksi): ') * 1000;      % Convert to psi

% Surface finish selection
surf_factor = input('Surface finish factor ka (ground=1.58, machined=2.70, hot-rolled=14.4): ');
ka = surf_factor * (S_ut/1000)^(-0.265);  % Marin surface factor [web:11][web:13]

% Operating temperature factor (default room temp)
temp_factor = input('Temperature factor kc (room temp=1): ');
kc = temp_factor;

% Reliability factor
rel_options = {'50% (1.0)', '99% (0.814)', '99.9% (0.753)', '99.99% (0.702)'};
rel_idx = listdlg('PromptString', 'Select reliability:', 'SelectionMode', 'single', ...
                  'ListString', rel_options);
rel_factors = [1.0, 0.814, 0.753, 0.702];
kr = rel_factors(rel_idx);

% Safety factor
n = input('Safety factor n: ');

% Shoulder geometry
shoulder_type = questdlg('Shoulder type?', 'Geometry', 'Sharp (r/d=0.02)', ...
                         'Well-rounded (r/d=0.1)', 'Well-rounded (r/d=0.1)');
switch shoulder_type
    case 'Sharp (r/d=0.02)'
        r_d_ratio = 0.02; D_d_ratio = 1.1;
    case 'Well-rounded (r/d=0.1)'
        r_d_ratio = 0.1;  D_d_ratio = 1.2;
end

% Initial guess and iteration (Shigley method) with history tracking
d = 1.0;  % Initial diameter guess (in) [web:11]
d_history = [d];  % Track diameter history [web:22]
error_history = [0];  % Track relative error history [web:22]
tol = 0.001;
max_iter = 50;
iter = 0;

while iter < max_iter
    prev_d = d;
    
    % Marin factors
    S_e_prime = 0.5 * S_ut;  % Rotary beam endurance limit
    k_b = (d/0.3)^(-0.107);  % Size factor (0.11-2in range) [web:11]
    k_d = 1;  % Assume no miscellaneous effects
    S_e = ka * k_b * kc * kr * k_d * S_e_prime;  % Endurance limit [web:13]
    
    % Stress concentration factors (approximated from Shigley Table 7-1)
    r = r_d_ratio * d;
    D = D_d_ratio * d;
    K_t_bend = 1.75 - 0.5*(r_d_ratio-0.02)/0.08;  % Bending ~1.75 to 1.5
    K_ts_tors = 1.55 - 0.3*(r_d_ratio-0.02)/0.08;  % Torsion ~1.55 to 1.25
    q_bend = 0.6; q_tors = 0.5;  % Notch sensitivity (steel)
    K_f_bend = 1 + q_bend*(K_t_bend - 1);
    K_fs_tors = 1 + q_tors*(K_ts_tors - 1);
    
    % Stresses (psi)
    sigma_a = (32 * K_f_bend * M_a) / (pi * d^3);
    sigma_m = (32 * K_f_bend * M_m) / (pi * d^3);
    tau_a   = (16 * K_fs_tors * T_a) / (pi * d^3);
    tau_m   = (16 * K_fs_tors * T_m) / (pi * d^3);
    
    % DE-Goodman criterion (von Mises effective)
    term1 = sigma_a / S_e;
    term2 = sigma_m / S_ut;
    term3 = sqrt(3) * tau_a / S_y;
    term4 = sqrt(3) * tau_m / S_y;
    n_calc = 1 / (term1 + term2 + term3 + term4);
    
    % Update diameter and track history
    if n_calc < n
        d = d * (n / n_calc)^(1/3);  % Cubic scaling [web:11]
    else
        d = d * 0.95;  % Conservative adjustment
    end
    
    iter = iter + 1;
    rel_error = abs(d - prev_d)/prev_d;
    d_history = [d_history, d];
    error_history = [error_history, rel_error * 100];
    
    if rel_error < tol
        break;
    end
end

% Results
fprintf('\n=== RESULTS ===\n');
fprintf('Recommended minimum diameter d = %.3f inches\n', d);
fprintf('Shoulder diameter D = %.3f inches (%.0f%% larger)\n', D, 100*(D_d_ratio-1));
fprintf('Fillet radius r = %.3f inches\n', r);
fprintf('Calculated safety factor = %.2f\n', n_calc);
fprintf('Endurance limit S_e = %.0f psi\n', S_e);
fprintf('\nStresses:\n');
fprintf('  Alternating bending σ_a = %.0f psi\n', sigma_a);
fprintf('  Midrange bending σ_m = %.0f psi\n', sigma_m);
fprintf('  Alternating shear τ_a = %.0f psi\n', tau_a);
fprintf('  Midrange shear τ_m = %.0f psi\n', tau_m);

% Plot convergence history [web:22]
figure;
subplot(2,1,1);
plot(0:iter, d_history, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
title('Diameter Convergence');
xlabel('Iteration'); ylabel('Diameter (in)');
grid on;

subplot(2,1,2);
semilogy(0:iter, error_history, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
title('Relative Error Convergence');
xlabel('Iteration'); ylabel('Relative Error (%)');
grid on;

end
