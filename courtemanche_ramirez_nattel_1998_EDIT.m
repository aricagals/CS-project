
function [VOI, STATES, ALGEBRAIC, CONSTANTS, RATES] = courtemanche_ramirez_nattel_1998_EDIT(parameters)
    % This is the "main function".  In Matlab, things work best if you rename this function to match the filename.
   [VOI, STATES, ALGEBRAIC, CONSTANTS, RATES] = solveModel(parameters);
end

function [algebraicVariableCount] = getAlgebraicVariableCount()
    % Used later when setting a global variable with the number of algebraic variables.
    % Note: This is not the "main method".
    algebraicVariableCount =75;
end

% There are a total of 21 entries in each of the rate and state variable arrays.
% There are a total of 49 entries in the constant variable array.
%

function [VOI, STATES, ALGEBRAIC, CONSTANTS, RATES] = solveModel(parameters)
    % Create ALGEBRAIC of correct size
    global algebraicVariableCount;  algebraicVariableCount = getAlgebraicVariableCount();
    % Initialise constants and state variables
    [INIT_STATES, CONSTANTS] = initConsts(parameters);

    % Set timespan to solve over
    tspan = [0, 1000];

    % Set numerical accuracy options for ODE solver
    options = odeset('RelTol', 1e-06, 'AbsTol', 1e-06, 'MaxStep', 1);

    % Solve model with ODE solver
    [VOI, STATES] = ode15s(@(VOI, STATES)computeRates(VOI, STATES, CONSTANTS), tspan, INIT_STATES, options);

    % Compute algebraic variables
    [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS);
    ALGEBRAIC = computeAlgebraic(ALGEBRAIC, CONSTANTS, STATES, VOI);

    % Plot state variables against variable of integration
%     [LEGEND_STATES, LEGEND_ALGEBRAIC, LEGEND_VOI, LEGEND_CONSTANTS] = createLegends();
%     figure();
%     plot(VOI, STATES);
%     xlabel(LEGEND_VOI);
%     l = legend(LEGEND_STATES);
%     set(l,'Interpreter','none');

end


function [LEGEND_STATES, LEGEND_ALGEBRAIC, LEGEND_VOI, LEGEND_CONSTANTS] = createLegends()
    LEGEND_STATES = ''; LEGEND_ALGEBRAIC = ''; LEGEND_VOI = ''; LEGEND_CONSTANTS = '';
    LEGEND_VOI = strpad('time in component environment (millisecond)');
    LEGEND_STATES(:,1) = strpad('V in component membrane (millivolt)');
    LEGEND_CONSTANTS(:,1) = strpad('R in component membrane (joule_per_mole_kelvin)');
    LEGEND_CONSTANTS(:,2) = strpad('T in component membrane (kelvin)');
    LEGEND_CONSTANTS(:,3) = strpad('F in component membrane (coulomb_per_millimole)');
    LEGEND_CONSTANTS(:,4) = strpad('Cm in component membrane (picoF)');
    LEGEND_ALGEBRAIC(:,1) = strpad('i_st in component membrane (picoA)');
    LEGEND_ALGEBRAIC(:,31) = strpad('i_Na in component fast_sodium_current (picoA)');
    LEGEND_ALGEBRAIC(:,51) = strpad('i_K1 in component time_independent_potassium_current (picoA)');
    LEGEND_ALGEBRAIC(:,52) = strpad('i_to in component transient_outward_K_current (picoA)');
    LEGEND_ALGEBRAIC(:,54) = strpad('i_Kur in component ultrarapid_delayed_rectifier_K_current (picoA)');
    LEGEND_ALGEBRAIC(:,55) = strpad('i_Kr in component rapid_delayed_rectifier_K_current (picoA)');
    LEGEND_ALGEBRAIC(:,56) = strpad('i_Ks in component slow_delayed_rectifier_K_current (picoA)');
    LEGEND_ALGEBRAIC(:,57) = strpad('i_Ca_L in component L_type_Ca_channel (picoA)');
    LEGEND_ALGEBRAIC(:,65) = strpad('i_CaP in component sarcolemmal_calcium_pump_current (picoA)');
    LEGEND_ALGEBRAIC(:,59) = strpad('i_NaK in component sodium_potassium_pump (picoA)');
    LEGEND_ALGEBRAIC(:,64) = strpad('i_NaCa in component Na_Ca_exchanger_current (picoA)');
    LEGEND_ALGEBRAIC(:,62) = strpad('i_B_Na in component background_currents (picoA)');
    LEGEND_ALGEBRAIC(:,63) = strpad('i_B_Ca in component background_currents (picoA)');
    LEGEND_CONSTANTS(:,5) = strpad('stim_start in component membrane (millisecond)');
    LEGEND_CONSTANTS(:,6) = strpad('stim_end in component membrane (millisecond)');
    LEGEND_CONSTANTS(:,7) = strpad('stim_period in component membrane (millisecond)');
    LEGEND_CONSTANTS(:,8) = strpad('stim_duration in component membrane (millisecond)');
    LEGEND_CONSTANTS(:,9) = strpad('stim_amplitude in component membrane (picoA)');
    LEGEND_ALGEBRAIC(:,18) = strpad('E_Na in component fast_sodium_current (millivolt)');
    LEGEND_CONSTANTS(:,10) = strpad('g_Na in component fast_sodium_current (nanoS_per_picoF)');
    LEGEND_STATES(:,2) = strpad('Na_i in component intracellular_ion_concentrations (millimolar)');
    LEGEND_CONSTANTS(:,11) = strpad('Na_o in component standard_ionic_concentrations (millimolar)');
    LEGEND_STATES(:,3) = strpad('m in component fast_sodium_current_m_gate (dimensionless)');
    LEGEND_STATES(:,4) = strpad('h in component fast_sodium_current_h_gate (dimensionless)');
    LEGEND_STATES(:,5) = strpad('j in component fast_sodium_current_j_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,2) = strpad('alpha_m in component fast_sodium_current_m_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,19) = strpad('beta_m in component fast_sodium_current_m_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,32) = strpad('m_inf in component fast_sodium_current_m_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,42) = strpad('tau_m in component fast_sodium_current_m_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,3) = strpad('alpha_h in component fast_sodium_current_h_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,20) = strpad('beta_h in component fast_sodium_current_h_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,33) = strpad('h_inf in component fast_sodium_current_h_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,43) = strpad('tau_h in component fast_sodium_current_h_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,4) = strpad('alpha_j in component fast_sodium_current_j_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,21) = strpad('beta_j in component fast_sodium_current_j_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,34) = strpad('j_inf in component fast_sodium_current_j_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,44) = strpad('tau_j in component fast_sodium_current_j_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,41) = strpad('E_K in component time_independent_potassium_current (millivolt)');
    LEGEND_CONSTANTS(:,12) = strpad('g_K1 in component time_independent_potassium_current (nanoS_per_picoF)');
    LEGEND_CONSTANTS(:,13) = strpad('K_o in component standard_ionic_concentrations (millimolar)');
    LEGEND_STATES(:,6) = strpad('K_i in component intracellular_ion_concentrations (millimolar)');
    LEGEND_CONSTANTS(:,14) = strpad('K_Q10 in component transient_outward_K_current (dimensionless)');
    LEGEND_CONSTANTS(:,15) = strpad('g_to in component transient_outward_K_current (nanoS_per_picoF)');
    LEGEND_STATES(:,7) = strpad('oa in component transient_outward_K_current_oa_gate (dimensionless)');
    LEGEND_STATES(:,8) = strpad('oi in component transient_outward_K_current_oi_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,5) = strpad('alpha_oa in component transient_outward_K_current_oa_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,22) = strpad('beta_oa in component transient_outward_K_current_oa_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,35) = strpad('tau_oa in component transient_outward_K_current_oa_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,45) = strpad('oa_infinity in component transient_outward_K_current_oa_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,6) = strpad('alpha_oi in component transient_outward_K_current_oi_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,23) = strpad('beta_oi in component transient_outward_K_current_oi_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,36) = strpad('tau_oi in component transient_outward_K_current_oi_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,46) = strpad('oi_infinity in component transient_outward_K_current_oi_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,53) = strpad('g_Kur in component ultrarapid_delayed_rectifier_K_current (nanoS_per_picoF)');
    LEGEND_STATES(:,9) = strpad('ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (dimensionless)');
    LEGEND_STATES(:,10) = strpad('ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,7) = strpad('alpha_ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,24) = strpad('beta_ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,37) = strpad('tau_ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,47) = strpad('ua_infinity in component ultrarapid_delayed_rectifier_K_current_ua_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,8) = strpad('alpha_ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,25) = strpad('beta_ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,38) = strpad('tau_ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,48) = strpad('ui_infinity in component ultrarapid_delayed_rectifier_K_current_ui_gate (dimensionless)');
    LEGEND_CONSTANTS(:,16) = strpad('g_Kr in component rapid_delayed_rectifier_K_current (nanoS_per_picoF)');
    LEGEND_STATES(:,11) = strpad('xr in component rapid_delayed_rectifier_K_current_xr_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,9) = strpad('alpha_xr in component rapid_delayed_rectifier_K_current_xr_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,26) = strpad('beta_xr in component rapid_delayed_rectifier_K_current_xr_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,39) = strpad('tau_xr in component rapid_delayed_rectifier_K_current_xr_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,49) = strpad('xr_infinity in component rapid_delayed_rectifier_K_current_xr_gate (dimensionless)');
    LEGEND_CONSTANTS(:,17) = strpad('g_Ks in component slow_delayed_rectifier_K_current (nanoS_per_picoF)');
    LEGEND_STATES(:,12) = strpad('xs in component slow_delayed_rectifier_K_current_xs_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,10) = strpad('alpha_xs in component slow_delayed_rectifier_K_current_xs_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,27) = strpad('beta_xs in component slow_delayed_rectifier_K_current_xs_gate (per_millisecond)');
    LEGEND_ALGEBRAIC(:,40) = strpad('tau_xs in component slow_delayed_rectifier_K_current_xs_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,50) = strpad('xs_infinity in component slow_delayed_rectifier_K_current_xs_gate (dimensionless)');
    LEGEND_CONSTANTS(:,18) = strpad('g_Ca_L in component L_type_Ca_channel (nanoS_per_picoF)');
    LEGEND_STATES(:,13) = strpad('Ca_i in component intracellular_ion_concentrations (millimolar)');
    LEGEND_STATES(:,14) = strpad('d in component L_type_Ca_channel_d_gate (dimensionless)');
    LEGEND_STATES(:,15) = strpad('f in component L_type_Ca_channel_f_gate (dimensionless)');
    LEGEND_STATES(:,16) = strpad('f_Ca in component L_type_Ca_channel_f_Ca_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,11) = strpad('d_infinity in component L_type_Ca_channel_d_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,28) = strpad('tau_d in component L_type_Ca_channel_d_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,12) = strpad('f_infinity in component L_type_Ca_channel_f_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,29) = strpad('tau_f in component L_type_Ca_channel_f_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,13) = strpad('f_Ca_infinity in component L_type_Ca_channel_f_Ca_gate (dimensionless)');
    LEGEND_CONSTANTS(:,45) = strpad('tau_f_Ca in component L_type_Ca_channel_f_Ca_gate (millisecond)');
    LEGEND_CONSTANTS(:,19) = strpad('Km_Na_i in component sodium_potassium_pump (millimolar)');
    LEGEND_CONSTANTS(:,20) = strpad('Km_K_o in component sodium_potassium_pump (millimolar)');
    LEGEND_CONSTANTS(:,21) = strpad('i_NaK_max in component sodium_potassium_pump (picoA_per_picoF)');
    LEGEND_ALGEBRAIC(:,58) = strpad('f_NaK in component sodium_potassium_pump (dimensionless)');
    LEGEND_CONSTANTS(:,46) = strpad('sigma in component sodium_potassium_pump (dimensionless)');
    LEGEND_ALGEBRAIC(:,61) = strpad('i_B_K in component background_currents (picoA)');
    LEGEND_CONSTANTS(:,22) = strpad('g_B_Na in component background_currents (nanoS_per_picoF)');
    LEGEND_CONSTANTS(:,23) = strpad('g_B_Ca in component background_currents (nanoS_per_picoF)');
    LEGEND_CONSTANTS(:,24) = strpad('g_B_K in component background_currents (nanoS_per_picoF)');
    LEGEND_ALGEBRAIC(:,60) = strpad('E_Ca in component background_currents (millivolt)');
    LEGEND_CONSTANTS(:,25) = strpad('Ca_o in component standard_ionic_concentrations (millimolar)');
    LEGEND_CONSTANTS(:,26) = strpad('I_NaCa_max in component Na_Ca_exchanger_current (picoA_per_picoF)');
    LEGEND_CONSTANTS(:,27) = strpad('K_mNa in component Na_Ca_exchanger_current (millimolar)');
    LEGEND_CONSTANTS(:,28) = strpad('K_mCa in component Na_Ca_exchanger_current (millimolar)');
    LEGEND_CONSTANTS(:,29) = strpad('K_sat in component Na_Ca_exchanger_current (dimensionless)');
    LEGEND_CONSTANTS(:,30) = strpad('gamma in component Na_Ca_exchanger_current (dimensionless)');
    LEGEND_CONSTANTS(:,31) = strpad('i_CaP_max in component sarcolemmal_calcium_pump_current (picoA_per_picoF)');
    LEGEND_ALGEBRAIC(:,66) = strpad('i_rel in component Ca_release_current_from_JSR (millimolar_per_millisecond)');
    LEGEND_ALGEBRAIC(:,67) = strpad('Fn in component Ca_release_current_from_JSR (dimensionless)');
    LEGEND_CONSTANTS(:,32) = strpad('K_rel in component Ca_release_current_from_JSR (per_millisecond)');
    LEGEND_CONSTANTS(:,48) = strpad('V_rel in component intracellular_ion_concentrations (micrometre_3)');
    LEGEND_STATES(:,17) = strpad('Ca_rel in component intracellular_ion_concentrations (millimolar)');
    LEGEND_STATES(:,18) = strpad('u in component Ca_release_current_from_JSR_u_gate (dimensionless)');
    LEGEND_STATES(:,19) = strpad('v in component Ca_release_current_from_JSR_v_gate (dimensionless)');
    LEGEND_STATES(:,20) = strpad('w in component Ca_release_current_from_JSR_w_gate (dimensionless)');
    LEGEND_CONSTANTS(:,47) = strpad('tau_u in component Ca_release_current_from_JSR_u_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,69) = strpad('u_infinity in component Ca_release_current_from_JSR_u_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,70) = strpad('tau_v in component Ca_release_current_from_JSR_v_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,72) = strpad('v_infinity in component Ca_release_current_from_JSR_v_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,14) = strpad('tau_w in component Ca_release_current_from_JSR_w_gate (millisecond)');
    LEGEND_ALGEBRAIC(:,30) = strpad('w_infinity in component Ca_release_current_from_JSR_w_gate (dimensionless)');
    LEGEND_ALGEBRAIC(:,68) = strpad('i_tr in component transfer_current_from_NSR_to_JSR (millimolar_per_millisecond)');
    LEGEND_CONSTANTS(:,33) = strpad('tau_tr in component transfer_current_from_NSR_to_JSR (millisecond)');
    LEGEND_STATES(:,21) = strpad('Ca_up in component intracellular_ion_concentrations (millimolar)');
    LEGEND_CONSTANTS(:,34) = strpad('I_up_max in component Ca_uptake_current_by_the_NSR (millimolar_per_millisecond)');
    LEGEND_ALGEBRAIC(:,71) = strpad('i_up in component Ca_uptake_current_by_the_NSR (millimolar_per_millisecond)');
    LEGEND_CONSTANTS(:,35) = strpad('K_up in component Ca_uptake_current_by_the_NSR (millimolar)');
    LEGEND_ALGEBRAIC(:,73) = strpad('i_up_leak in component Ca_leak_current_by_the_NSR (millimolar_per_millisecond)');
    LEGEND_CONSTANTS(:,36) = strpad('Ca_up_max in component Ca_leak_current_by_the_NSR (millimolar)');
    LEGEND_CONSTANTS(:,37) = strpad('CMDN_max in component Ca_buffers (millimolar)');
    LEGEND_CONSTANTS(:,38) = strpad('TRPN_max in component Ca_buffers (millimolar)');
    LEGEND_CONSTANTS(:,39) = strpad('CSQN_max in component Ca_buffers (millimolar)');
    LEGEND_CONSTANTS(:,40) = strpad('Km_CMDN in component Ca_buffers (millimolar)');
    LEGEND_CONSTANTS(:,41) = strpad('Km_TRPN in component Ca_buffers (millimolar)');
    LEGEND_CONSTANTS(:,42) = strpad('Km_CSQN in component Ca_buffers (millimolar)');
    LEGEND_ALGEBRAIC(:,15) = strpad('Ca_CMDN in component Ca_buffers (millimolar)');
    LEGEND_ALGEBRAIC(:,16) = strpad('Ca_TRPN in component Ca_buffers (millimolar)');
    LEGEND_ALGEBRAIC(:,17) = strpad('Ca_CSQN in component Ca_buffers (millimolar)');
    LEGEND_CONSTANTS(:,43) = strpad('V_cell in component intracellular_ion_concentrations (micrometre_3)');
    LEGEND_CONSTANTS(:,44) = strpad('V_i in component intracellular_ion_concentrations (micrometre_3)');
    LEGEND_CONSTANTS(:,49) = strpad('V_up in component intracellular_ion_concentrations (micrometre_3)');
    LEGEND_ALGEBRAIC(:,74) = strpad('B1 in component intracellular_ion_concentrations (millimolar_per_millisecond)');
    LEGEND_ALGEBRAIC(:,75) = strpad('B2 in component intracellular_ion_concentrations (dimensionless)');
    LEGEND_RATES(:,1) = strpad('d/dt V in component membrane (millivolt)');
    LEGEND_RATES(:,3) = strpad('d/dt m in component fast_sodium_current_m_gate (dimensionless)');
    LEGEND_RATES(:,4) = strpad('d/dt h in component fast_sodium_current_h_gate (dimensionless)');
    LEGEND_RATES(:,5) = strpad('d/dt j in component fast_sodium_current_j_gate (dimensionless)');
    LEGEND_RATES(:,7) = strpad('d/dt oa in component transient_outward_K_current_oa_gate (dimensionless)');
    LEGEND_RATES(:,8) = strpad('d/dt oi in component transient_outward_K_current_oi_gate (dimensionless)');
    LEGEND_RATES(:,9) = strpad('d/dt ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (dimensionless)');
    LEGEND_RATES(:,10) = strpad('d/dt ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (dimensionless)');
    LEGEND_RATES(:,11) = strpad('d/dt xr in component rapid_delayed_rectifier_K_current_xr_gate (dimensionless)');
    LEGEND_RATES(:,12) = strpad('d/dt xs in component slow_delayed_rectifier_K_current_xs_gate (dimensionless)');
    LEGEND_RATES(:,14) = strpad('d/dt d in component L_type_Ca_channel_d_gate (dimensionless)');
    LEGEND_RATES(:,15) = strpad('d/dt f in component L_type_Ca_channel_f_gate (dimensionless)');
    LEGEND_RATES(:,16) = strpad('d/dt f_Ca in component L_type_Ca_channel_f_Ca_gate (dimensionless)');
    LEGEND_RATES(:,18) = strpad('d/dt u in component Ca_release_current_from_JSR_u_gate (dimensionless)');
    LEGEND_RATES(:,19) = strpad('d/dt v in component Ca_release_current_from_JSR_v_gate (dimensionless)');
    LEGEND_RATES(:,20) = strpad('d/dt w in component Ca_release_current_from_JSR_w_gate (dimensionless)');
    LEGEND_RATES(:,2) = strpad('d/dt Na_i in component intracellular_ion_concentrations (millimolar)');
    LEGEND_RATES(:,6) = strpad('d/dt K_i in component intracellular_ion_concentrations (millimolar)');
    LEGEND_RATES(:,13) = strpad('d/dt Ca_i in component intracellular_ion_concentrations (millimolar)');
    LEGEND_RATES(:,21) = strpad('d/dt Ca_up in component intracellular_ion_concentrations (millimolar)');
    LEGEND_RATES(:,17) = strpad('d/dt Ca_rel in component intracellular_ion_concentrations (millimolar)');
    LEGEND_STATES  = LEGEND_STATES';
    LEGEND_ALGEBRAIC = LEGEND_ALGEBRAIC';
    LEGEND_RATES = LEGEND_RATES';
    LEGEND_CONSTANTS = LEGEND_CONSTANTS';
end

function [states, constants] = initConsts(parameters)
    VOI = 0; constants = []; states = []; ALGEBRAIC = [];
    states(:,1) = -81.18;   %V in component membrane
    constants(:,1) = 8.3143;
    constants(:,2) = 310;
    constants(:,3) = 96.4867;
    constants(:,4) = 100;  %75 + 50*rand(1,1);
    constants(:,5) = 50;
    constants(:,6) = 50000;
    constants(:,7) = 1000;
    constants(:,8) = 2;
    constants(:,9) = -2000;
    constants(:,10) = 7.8;  %7.8*rand(1,1) + 3.9;
    states(:,2) = 1.2e+01;    %Na_i intracellular ion concentration
    constants(:,11) = 140;   %126 + 28*rand(1,1);
    states(:,3) = 2.908e-3;     %fast sodium current m gate
    states(:,4) = 9.649e-1;     %fast sodium current h gate
    states(:,5) = 9.775e-1;     %fast sodium current j gate
    constants(:,12) = parameters(1,1);  %0.045*rand(1,1) + 0.0675   % 0.09;
    constants(:,13) = 5.4;   %4.86 + 1.08*rand(1,1);
    states(:,6) = 1.39e+02;     %K_i intracellular ion concentration
    constants(:,14) = 3;
    constants(:,15) = parameters(1,2); % 0.0825 + 0.165*rand(1,1);
    states(:,7) = 3.043e-2;     %outward K current oa gate
    states(:,8) = 9.992e-1;     %transient outward K current oi gate
    states(:,9) = 4.966e-3;     %ultrarapid delayed rectifier K current ua gate
    states(:,10) = 9.986e-1;    %ultrarapid delayed rectifier K current ui gate
    constants(:,16) = parameters(1,3); %0.0147 + 0.0294*rand(1,1);
    states(:,11) = 3.296e-5;    %rapid delayed rectifier K current xr gate
    constants(:,17) = 0.12941176;     %0.0647 + 0.1294*rand(1,1);
    states(:,12) = 1.869e-2;    %rapid delayed rectifier K current xr gate
    constants(:,18) = parameters(1,4); %0.06185 + 0.1237*rand(1,1);
    states(:,13) = 1.013e-4;    %Ca_i intracellular ion concentration
    states(:,14) = 1.367e-4;    %L type Ca channel d gate
    states(:,15) = 9.996e-1;    %L tyoe Ca channel f gate
    states(:,16) = 7.755e-1;    %L type Ca channel f Ca gate
    constants(:,19) = 10;
    constants(:,20) = 1.5;
    constants(:,21) = parameters(1,5); %0.29965 + 0.5993*rand(1,1);
    constants(:,22) = 0.0006744375;   %0.0003 + 0.0006*rand(1,1);
    constants(:,23) = parameters(1,6); %0.00055 + 0.0011*rand(1,1);
    constants(:,24) = 0;
    constants(:,25) = 1.8;    %1.62 + 0.36*rand(1,1);
    constants(:,26) = 1600;   %800 + 1600*rand(1,1);
    constants(:,27) = 87.5;
    constants(:,28) = 1.38;
    constants(:,29) = 0.1;
    constants(:,30) = 0.35;
    constants(:,31) = 0.275;  %0.1375 + 0.275*rand(1,1);
    constants(:,32) = 30;
    states(:,17) = 1.488;       %rel Ca intracellular ion concentration
    states(:,18) = 2.35e-112;   %Ca release current from JSR u gate
    states(:,19) = 1;           %Ca release current from JSR v gate
    states(:,20) = 0.9992;      %Ca release current from JSR w gate
    constants(:,33) = 180;   %90 + 180*rand(1,1);
    states(:,21) = 1.488;       %Ca_up intracellular ion concentration
    constants(:,34) = 0.005;   %0.0025 + 0.005*rand(1,1);
    constants(:,35) = 0.00092;  %0.00046 + 0.00092*rand(1,1);
    constants(:,36) = 15;
    constants(:,37) = 0.05;
    constants(:,38) = 0.07;
    constants(:,39) = 10;
    constants(:,40) = 0.00238;
    constants(:,41) = 0.0005;
    constants(:,42) = 0.8;
    constants(:,43) = 20100;
    constants(:,44) =  constants(:,43).*0.680000;
    constants(:,45) = 2.00000;
    constants(:,46) =  (1.00000./7.00000).*(exp(constants(:,11)./67.3000) - 1.00000);
    constants(:,47) = 8.00000;
    constants(:,48) =  0.00480000.*constants(:,43);
    constants(:,49) =  0.0552000.*constants(:,43);
    if (isempty(states)), warning('Initial values for states not set');, end
end

function [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS)
    global algebraicVariableCount;
    statesSize = size(STATES);
    statesColumnCount = statesSize(2);
    if ( statesColumnCount == 1)
        STATES = STATES';
        ALGEBRAIC = zeros(1, algebraicVariableCount);
        utilOnes = 1;
    else
        statesRowCount = statesSize(1);
        ALGEBRAIC = zeros(statesRowCount, algebraicVariableCount);
        RATES = zeros(statesRowCount, statesColumnCount);
        utilOnes = ones(statesRowCount, 1);
    end
    ALGEBRAIC(:,13) = power(1.00000+STATES(:,13)./0.000350000,  - 1.00000);
    RATES(:,16) = (ALGEBRAIC(:,13) - STATES(:,16))./CONSTANTS(:,45);
    ALGEBRAIC(:,11) = power(1.00000+exp((STATES(:,1)+10.0000)./ - 8.00000),  - 1.00000);
    ALGEBRAIC(:,28) = piecewise({abs(STATES(:,1)+10.0000)<1.00000e-10, 4.57900./(1.00000+exp((STATES(:,1)+10.0000)./ - 6.24000)) }, (1.00000 - exp((STATES(:,1)+10.0000)./ - 6.24000))./( 0.0350000.*(STATES(:,1)+10.0000).*(1.00000+exp((STATES(:,1)+10.0000)./ - 6.24000))));
    RATES(:,14) = (ALGEBRAIC(:,11) - STATES(:,14))./ALGEBRAIC(:,28);
    ALGEBRAIC(:,12) = exp( - (STATES(:,1)+28.0000)./6.90000)./(1.00000+exp( - (STATES(:,1)+28.0000)./6.90000));
    ALGEBRAIC(:,29) =  9.00000.*power( 0.0197000.*exp(  - power(0.0337000, 2.00000).*power(STATES(:,1)+10.0000, 2.00000))+0.0200000,  - 1.00000);
    RATES(:,15) = (ALGEBRAIC(:,12) - STATES(:,15))./ALGEBRAIC(:,29);
    ALGEBRAIC(:,14) = piecewise({abs(STATES(:,1) - 7.90000)<1.00000e-10, ( 6.00000.*0.200000)./1.30000 }, ( 6.00000.*(1.00000 - exp( - (STATES(:,1) - 7.90000)./5.00000)))./( (1.00000+ 0.300000.*exp( - (STATES(:,1) - 7.90000)./5.00000)).*1.00000.*(STATES(:,1) - 7.90000)));
    ALGEBRAIC(:,30) = 1.00000 - power(1.00000+exp( - (STATES(:,1) - 40.0000)./17.0000),  - 1.00000);
    RATES(:,20) = (ALGEBRAIC(:,30) - STATES(:,20))./ALGEBRAIC(:,14);
    ALGEBRAIC(:,2) = piecewise({STATES(:,1)== - 47.1300, 3.20000 }, ( 0.320000.*(STATES(:,1)+47.1300))./(1.00000 - exp(  - 0.100000.*(STATES(:,1)+47.1300))));
    ALGEBRAIC(:,19) =  0.0800000.*exp( - STATES(:,1)./11.0000);
    ALGEBRAIC(:,32) = ALGEBRAIC(:,2)./(ALGEBRAIC(:,2)+ALGEBRAIC(:,19));
    ALGEBRAIC(:,42) = 1.00000./(ALGEBRAIC(:,2)+ALGEBRAIC(:,19));
    RATES(:,3) = (ALGEBRAIC(:,32) - STATES(:,3))./ALGEBRAIC(:,42);
    ALGEBRAIC(:,3) = piecewise({STATES(:,1)< - 40.0000,  0.135000.*exp((STATES(:,1)+80.0000)./ - 6.80000) }, 0.00000);
    ALGEBRAIC(:,20) = piecewise({STATES(:,1)< - 40.0000,  3.56000.*exp( 0.0790000.*STATES(:,1))+ 310000..*exp( 0.350000.*STATES(:,1)) }, 1.00000./( 0.130000.*(1.00000+exp((STATES(:,1)+10.6600)./ - 11.1000))));
    ALGEBRAIC(:,33) = ALGEBRAIC(:,3)./(ALGEBRAIC(:,3)+ALGEBRAIC(:,20));
    ALGEBRAIC(:,43) = 1.00000./(ALGEBRAIC(:,3)+ALGEBRAIC(:,20));
    RATES(:,4) = (ALGEBRAIC(:,33) - STATES(:,4))./ALGEBRAIC(:,43);
    ALGEBRAIC(:,4) = piecewise({STATES(:,1)< - 40.0000, ( (  - 127140..*exp( 0.244400.*STATES(:,1)) -  3.47400e-05.*exp(  - 0.0439100.*STATES(:,1))).*(STATES(:,1)+37.7800))./(1.00000+exp( 0.311000.*(STATES(:,1)+79.2300))) }, 0.00000);
    ALGEBRAIC(:,21) = piecewise({STATES(:,1)< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*STATES(:,1)))./(1.00000+exp(  - 0.137800.*(STATES(:,1)+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*STATES(:,1)))./(1.00000+exp(  - 0.100000.*(STATES(:,1)+32.0000))));
    ALGEBRAIC(:,34) = ALGEBRAIC(:,4)./(ALGEBRAIC(:,4)+ALGEBRAIC(:,21));
    ALGEBRAIC(:,44) = 1.00000./(ALGEBRAIC(:,4)+ALGEBRAIC(:,21));
    RATES(:,5) = (ALGEBRAIC(:,34) - STATES(:,5))./ALGEBRAIC(:,44);
    ALGEBRAIC(:,5) =  0.650000.*power(exp((STATES(:,1) -  - 10.0000)./ - 8.50000)+exp(((STATES(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);
    ALGEBRAIC(:,22) =  0.650000.*power(2.50000+exp(((STATES(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);
    ALGEBRAIC(:,35) = power(ALGEBRAIC(:,5)+ALGEBRAIC(:,22),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,45) = power(1.00000+exp(((STATES(:,1) -  - 10.0000)+10.4700)./ - 17.5400),  - 1.00000);
    RATES(:,7) = (ALGEBRAIC(:,45) - STATES(:,7))./ALGEBRAIC(:,35);
    ALGEBRAIC(:,6) = power(18.5300+ 1.00000.*exp(((STATES(:,1) -  - 10.0000)+103.700)./10.9500),  - 1.00000);
    ALGEBRAIC(:,23) = power(35.5600+ 1.00000.*exp(((STATES(:,1) -  - 10.0000) - 8.74000)./ - 7.44000),  - 1.00000);
    ALGEBRAIC(:,36) = power(ALGEBRAIC(:,6)+ALGEBRAIC(:,23),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,46) = power(1.00000+exp(((STATES(:,1) -  - 10.0000)+33.1000)./5.30000),  - 1.00000);
    RATES(:,8) = (ALGEBRAIC(:,46) - STATES(:,8))./ALGEBRAIC(:,36);
    ALGEBRAIC(:,7) =  0.650000.*power(exp((STATES(:,1) -  - 10.0000)./ - 8.50000)+exp(((STATES(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);
    ALGEBRAIC(:,24) =  0.650000.*power(2.50000+exp(((STATES(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);
    ALGEBRAIC(:,37) = power(ALGEBRAIC(:,7)+ALGEBRAIC(:,24),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,47) = power(1.00000+exp(((STATES(:,1) -  - 10.0000)+20.3000)./ - 9.60000),  - 1.00000);
    RATES(:,9) = (ALGEBRAIC(:,47) - STATES(:,9))./ALGEBRAIC(:,37);
    ALGEBRAIC(:,8) = power(21.0000+ 1.00000.*exp(((STATES(:,1) -  - 10.0000) - 195.000)./ - 28.0000),  - 1.00000);
    ALGEBRAIC(:,25) = 1.00000./exp(((STATES(:,1) -  - 10.0000) - 168.000)./ - 16.0000);
    ALGEBRAIC(:,38) = power(ALGEBRAIC(:,8)+ALGEBRAIC(:,25),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,48) = power(1.00000+exp(((STATES(:,1) -  - 10.0000) - 109.450)./27.4800),  - 1.00000);
    RATES(:,10) = (ALGEBRAIC(:,48) - STATES(:,10))./ALGEBRAIC(:,38);
    ALGEBRAIC(:,9) = piecewise({abs(STATES(:,1)+14.1000)<1.00000e-10, 0.00150000 }, ( 0.000300000.*(STATES(:,1)+14.1000))./(1.00000 - exp((STATES(:,1)+14.1000)./ - 5.00000)));
    ALGEBRAIC(:,26) = piecewise({abs(STATES(:,1) - 3.33280)<1.00000e-10, 0.000378361 }, ( 7.38980e-05.*(STATES(:,1) - 3.33280))./(exp((STATES(:,1) - 3.33280)./5.12370) - 1.00000));
    ALGEBRAIC(:,39) = power(ALGEBRAIC(:,9)+ALGEBRAIC(:,26),  - 1.00000);
    ALGEBRAIC(:,49) = power(1.00000+exp((STATES(:,1)+14.1000)./ - 6.50000),  - 1.00000);
    RATES(:,11) = (ALGEBRAIC(:,49) - STATES(:,11))./ALGEBRAIC(:,39);
    ALGEBRAIC(:,10) = piecewise({abs(STATES(:,1) - 19.9000)<1.00000e-10, 0.000680000 }, ( 4.00000e-05.*(STATES(:,1) - 19.9000))./(1.00000 - exp((STATES(:,1) - 19.9000)./ - 17.0000)));
    ALGEBRAIC(:,27) = piecewise({abs(STATES(:,1) - 19.9000)<1.00000e-10, 0.000315000 }, ( 3.50000e-05.*(STATES(:,1) - 19.9000))./(exp((STATES(:,1) - 19.9000)./9.00000) - 1.00000));
    ALGEBRAIC(:,40) =  0.500000.*power(ALGEBRAIC(:,10)+ALGEBRAIC(:,27),  - 1.00000);
    ALGEBRAIC(:,50) = power(1.00000+exp((STATES(:,1) - 19.9000)./ - 12.7000),  - 0.500000);
    RATES(:,12) = (ALGEBRAIC(:,50) - STATES(:,12))./ALGEBRAIC(:,40);
    ALGEBRAIC(:,41) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log(CONSTANTS(:,13)./STATES(:,6));
    ALGEBRAIC(:,51) = ( CONSTANTS(:,4).*CONSTANTS(:,12).*(STATES(:,1) - ALGEBRAIC(:,41)))./(1.00000+exp( 0.0700000.*(STATES(:,1)+80.0000)));
    ALGEBRAIC(:,52) =  CONSTANTS(:,4).*CONSTANTS(:,15).*power(STATES(:,7), 3.00000).*STATES(:,8).*(STATES(:,1) - ALGEBRAIC(:,41));
    ALGEBRAIC(:,53) = 0.00500000+0.0500000./(1.00000+exp((STATES(:,1) - 15.0000)./ - 13.0000));
    ALGEBRAIC(:,54) =  CONSTANTS(:,4).*ALGEBRAIC(:,53).*power(STATES(:,9), 3.00000).*STATES(:,10).*(STATES(:,1) - ALGEBRAIC(:,41));
    ALGEBRAIC(:,55) = ( CONSTANTS(:,4).*CONSTANTS(:,16).*STATES(:,11).*(STATES(:,1) - ALGEBRAIC(:,41)))./(1.00000+exp((STATES(:,1)+15.0000)./22.4000));
    ALGEBRAIC(:,56) =  CONSTANTS(:,4).*CONSTANTS(:,17).*power(STATES(:,12), 2.00000).*(STATES(:,1) - ALGEBRAIC(:,41));
    ALGEBRAIC(:,58) = power(1.00000+ 0.124500.*exp((  - 0.100000.*CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2)))+ 0.0365000.*CONSTANTS(:,46).*exp((  - CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2))),  - 1.00000);
    ALGEBRAIC(:,59) = ( (( CONSTANTS(:,4).*CONSTANTS(:,21).*ALGEBRAIC(:,58).*1.00000)./(1.00000+power(CONSTANTS(:,19)./STATES(:,2), 1.50000))).*CONSTANTS(:,13))./(CONSTANTS(:,13)+CONSTANTS(:,20));
    ALGEBRAIC(:,61) =  CONSTANTS(:,4).*CONSTANTS(:,24).*(STATES(:,1) - ALGEBRAIC(:,41));
    RATES(:,6) = ( 2.00000.*ALGEBRAIC(:,59) - (ALGEBRAIC(:,51)+ALGEBRAIC(:,52)+ALGEBRAIC(:,54)+ALGEBRAIC(:,55)+ALGEBRAIC(:,56)+ALGEBRAIC(:,61)))./( CONSTANTS(:,44).*CONSTANTS(:,3));
    ALGEBRAIC(:,18) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log(CONSTANTS(:,11)./STATES(:,2));
    ALGEBRAIC(:,31) =  CONSTANTS(:,4).*CONSTANTS(:,10).*power(STATES(:,3), 3.00000).*STATES(:,4).*STATES(:,5).*(STATES(:,1) - ALGEBRAIC(:,18));
    ALGEBRAIC(:,64) = ( CONSTANTS(:,4).*CONSTANTS(:,26).*( exp(( CONSTANTS(:,30).*CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2))).*power(STATES(:,2), 3.00000).*CONSTANTS(:,25) -  exp(( (CONSTANTS(:,30) - 1.00000).*CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2))).*power(CONSTANTS(:,11), 3.00000).*STATES(:,13)))./( (power(CONSTANTS(:,27), 3.00000)+power(CONSTANTS(:,11), 3.00000)).*(CONSTANTS(:,28)+CONSTANTS(:,25)).*(1.00000+ CONSTANTS(:,29).*exp(( (CONSTANTS(:,30) - 1.00000).*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2)))));
    ALGEBRAIC(:,62) =  CONSTANTS(:,4).*CONSTANTS(:,22).*(STATES(:,1) - ALGEBRAIC(:,18));
    RATES(:,2) = (  - 3.00000.*ALGEBRAIC(:,59) - ( 3.00000.*ALGEBRAIC(:,64)+ALGEBRAIC(:,62)+ALGEBRAIC(:,31)))./( CONSTANTS(:,44).*CONSTANTS(:,3));
    ALGEBRAIC(:,1) = piecewise({VOI>=CONSTANTS(:,5)&VOI<=CONSTANTS(:,6)&(VOI - CONSTANTS(:,5)) -  floor((VOI - CONSTANTS(:,5))./CONSTANTS(:,7)).*CONSTANTS(:,7)<=CONSTANTS(:,8), CONSTANTS(:,9) }, 0.00000);
    ALGEBRAIC(:,57) =  CONSTANTS(:,4).*CONSTANTS(:,18).*STATES(:,14).*STATES(:,15).*STATES(:,16).*(STATES(:,1) - 65.0000);
    ALGEBRAIC(:,65) = ( CONSTANTS(:,4).*CONSTANTS(:,31).*STATES(:,13))./(0.000500000+STATES(:,13));
    ALGEBRAIC(:,60) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./( 2.00000.*CONSTANTS(:,3))).*log(CONSTANTS(:,25)./STATES(:,13));
    ALGEBRAIC(:,63) =  CONSTANTS(:,4).*CONSTANTS(:,23).*(STATES(:,1) - ALGEBRAIC(:,60));
    RATES(:,1) =  - (ALGEBRAIC(:,31)+ALGEBRAIC(:,51)+ALGEBRAIC(:,52)+ALGEBRAIC(:,54)+ALGEBRAIC(:,55)+ALGEBRAIC(:,56)+ALGEBRAIC(:,62)+ALGEBRAIC(:,63)+ALGEBRAIC(:,59)+ALGEBRAIC(:,65)+ALGEBRAIC(:,64)+ALGEBRAIC(:,57)+ALGEBRAIC(:,1))./CONSTANTS(:,4);
    ALGEBRAIC(:,66) =  CONSTANTS(:,32).*power(STATES(:,18), 2.00000).*STATES(:,19).*STATES(:,20).*(STATES(:,17) - STATES(:,13));
    ALGEBRAIC(:,68) = (STATES(:,21) - STATES(:,17))./CONSTANTS(:,33);
    RATES(:,17) =  (ALGEBRAIC(:,68) - ALGEBRAIC(:,66)).*power(1.00000+( CONSTANTS(:,39).*CONSTANTS(:,42))./power(STATES(:,17)+CONSTANTS(:,42), 2.00000),  - 1.00000);
    ALGEBRAIC(:,67) =  1000.00.*( 1.00000e-15.*CONSTANTS(:,48).*ALGEBRAIC(:,66) -  (1.00000e-15./( 2.00000.*CONSTANTS(:,3))).*( 0.500000.*ALGEBRAIC(:,57) -  0.200000.*ALGEBRAIC(:,64)));
    ALGEBRAIC(:,69) = power(1.00000+exp( - (ALGEBRAIC(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);
    RATES(:,18) = (ALGEBRAIC(:,69) - STATES(:,18))./CONSTANTS(:,47);
    ALGEBRAIC(:,70) = 1.91000+ 2.09000.*power(1.00000+exp( - (ALGEBRAIC(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);
    ALGEBRAIC(:,72) = 1.00000 - power(1.00000+exp( - (ALGEBRAIC(:,67) - 6.83500e-14)./1.36700e-15),  - 1.00000);
    RATES(:,19) = (ALGEBRAIC(:,72) - STATES(:,19))./ALGEBRAIC(:,70);
    ALGEBRAIC(:,71) = CONSTANTS(:,34)./(1.00000+CONSTANTS(:,35)./STATES(:,13));
    ALGEBRAIC(:,73) = ( CONSTANTS(:,34).*STATES(:,21))./CONSTANTS(:,36);
    RATES(:,21) = ALGEBRAIC(:,71) - (ALGEBRAIC(:,73)+( ALGEBRAIC(:,68).*CONSTANTS(:,48))./CONSTANTS(:,49));
    ALGEBRAIC(:,74) = ( 2.00000.*ALGEBRAIC(:,64) - (ALGEBRAIC(:,65)+ALGEBRAIC(:,57)+ALGEBRAIC(:,63)))./( 2.00000.*CONSTANTS(:,44).*CONSTANTS(:,3))+( CONSTANTS(:,49).*(ALGEBRAIC(:,73) - ALGEBRAIC(:,71))+ ALGEBRAIC(:,66).*CONSTANTS(:,48))./CONSTANTS(:,44);
    ALGEBRAIC(:,75) = 1.00000+( CONSTANTS(:,38).*CONSTANTS(:,41))./power(STATES(:,13)+CONSTANTS(:,41), 2.00000)+( CONSTANTS(:,37).*CONSTANTS(:,40))./power(STATES(:,13)+CONSTANTS(:,40), 2.00000);
    RATES(:,13) = ALGEBRAIC(:,74)./ALGEBRAIC(:,75);
   RATES = RATES';
end

% Calculate algebraic variables
function ALGEBRAIC = computeAlgebraic(ALGEBRAIC, CONSTANTS, STATES, VOI)
    statesSize = size(STATES);
    statesColumnCount = statesSize(2);
    if ( statesColumnCount == 1)
        STATES = STATES';
        utilOnes = 1;
    else
        statesRowCount = statesSize(1);
        utilOnes = ones(statesRowCount, 1);
    end
    ALGEBRAIC(:,13) = power(1.00000+STATES(:,13)./0.000350000,  - 1.00000);
    ALGEBRAIC(:,11) = power(1.00000+exp((STATES(:,1)+10.0000)./ - 8.00000),  - 1.00000);
    ALGEBRAIC(:,28) = piecewise({abs(STATES(:,1)+10.0000)<1.00000e-10, 4.57900./(1.00000+exp((STATES(:,1)+10.0000)./ - 6.24000)) }, (1.00000 - exp((STATES(:,1)+10.0000)./ - 6.24000))./( 0.0350000.*(STATES(:,1)+10.0000).*(1.00000+exp((STATES(:,1)+10.0000)./ - 6.24000))));
    ALGEBRAIC(:,12) = exp( - (STATES(:,1)+28.0000)./6.90000)./(1.00000+exp( - (STATES(:,1)+28.0000)./6.90000));
    ALGEBRAIC(:,29) =  9.00000.*power( 0.0197000.*exp(  - power(0.0337000, 2.00000).*power(STATES(:,1)+10.0000, 2.00000))+0.0200000,  - 1.00000);
    ALGEBRAIC(:,14) = piecewise({abs(STATES(:,1) - 7.90000)<1.00000e-10, ( 6.00000.*0.200000)./1.30000 }, ( 6.00000.*(1.00000 - exp( - (STATES(:,1) - 7.90000)./5.00000)))./( (1.00000+ 0.300000.*exp( - (STATES(:,1) - 7.90000)./5.00000)).*1.00000.*(STATES(:,1) - 7.90000)));
    ALGEBRAIC(:,30) = 1.00000 - power(1.00000+exp( - (STATES(:,1) - 40.0000)./17.0000),  - 1.00000);
    ALGEBRAIC(:,2) = piecewise({STATES(:,1)== - 47.1300, 3.20000 }, ( 0.320000.*(STATES(:,1)+47.1300))./(1.00000 - exp(  - 0.100000.*(STATES(:,1)+47.1300))));
    ALGEBRAIC(:,19) =  0.0800000.*exp( - STATES(:,1)./11.0000);
    ALGEBRAIC(:,32) = ALGEBRAIC(:,2)./(ALGEBRAIC(:,2)+ALGEBRAIC(:,19));
    ALGEBRAIC(:,42) = 1.00000./(ALGEBRAIC(:,2)+ALGEBRAIC(:,19));
    ALGEBRAIC(:,3) = piecewise({STATES(:,1)< - 40.0000,  0.135000.*exp((STATES(:,1)+80.0000)./ - 6.80000) }, 0.00000);
    ALGEBRAIC(:,20) = piecewise({STATES(:,1)< - 40.0000,  3.56000.*exp( 0.0790000.*STATES(:,1))+ 310000..*exp( 0.350000.*STATES(:,1)) }, 1.00000./( 0.130000.*(1.00000+exp((STATES(:,1)+10.6600)./ - 11.1000))));
    ALGEBRAIC(:,33) = ALGEBRAIC(:,3)./(ALGEBRAIC(:,3)+ALGEBRAIC(:,20));
    ALGEBRAIC(:,43) = 1.00000./(ALGEBRAIC(:,3)+ALGEBRAIC(:,20));
    ALGEBRAIC(:,4) = piecewise({STATES(:,1)< - 40.0000, ( (  - 127140..*exp( 0.244400.*STATES(:,1)) -  3.47400e-05.*exp(  - 0.0439100.*STATES(:,1))).*(STATES(:,1)+37.7800))./(1.00000+exp( 0.311000.*(STATES(:,1)+79.2300))) }, 0.00000);
    ALGEBRAIC(:,21) = piecewise({STATES(:,1)< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*STATES(:,1)))./(1.00000+exp(  - 0.137800.*(STATES(:,1)+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*STATES(:,1)))./(1.00000+exp(  - 0.100000.*(STATES(:,1)+32.0000))));
    ALGEBRAIC(:,34) = ALGEBRAIC(:,4)./(ALGEBRAIC(:,4)+ALGEBRAIC(:,21));
    ALGEBRAIC(:,44) = 1.00000./(ALGEBRAIC(:,4)+ALGEBRAIC(:,21));
    ALGEBRAIC(:,5) =  0.650000.*power(exp((STATES(:,1) -  - 10.0000)./ - 8.50000)+exp(((STATES(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);
    ALGEBRAIC(:,22) =  0.650000.*power(2.50000+exp(((STATES(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);
    ALGEBRAIC(:,35) = power(ALGEBRAIC(:,5)+ALGEBRAIC(:,22),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,45) = power(1.00000+exp(((STATES(:,1) -  - 10.0000)+10.4700)./ - 17.5400),  - 1.00000);
    ALGEBRAIC(:,6) = power(18.5300+ 1.00000.*exp(((STATES(:,1) -  - 10.0000)+103.700)./10.9500),  - 1.00000);
    ALGEBRAIC(:,23) = power(35.5600+ 1.00000.*exp(((STATES(:,1) -  - 10.0000) - 8.74000)./ - 7.44000),  - 1.00000);
    ALGEBRAIC(:,36) = power(ALGEBRAIC(:,6)+ALGEBRAIC(:,23),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,46) = power(1.00000+exp(((STATES(:,1) -  - 10.0000)+33.1000)./5.30000),  - 1.00000);
    ALGEBRAIC(:,7) =  0.650000.*power(exp((STATES(:,1) -  - 10.0000)./ - 8.50000)+exp(((STATES(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);
    ALGEBRAIC(:,24) =  0.650000.*power(2.50000+exp(((STATES(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);
    ALGEBRAIC(:,37) = power(ALGEBRAIC(:,7)+ALGEBRAIC(:,24),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,47) = power(1.00000+exp(((STATES(:,1) -  - 10.0000)+20.3000)./ - 9.60000),  - 1.00000);
    ALGEBRAIC(:,8) = power(21.0000+ 1.00000.*exp(((STATES(:,1) -  - 10.0000) - 195.000)./ - 28.0000),  - 1.00000);
    ALGEBRAIC(:,25) = 1.00000./exp(((STATES(:,1) -  - 10.0000) - 168.000)./ - 16.0000);
    ALGEBRAIC(:,38) = power(ALGEBRAIC(:,8)+ALGEBRAIC(:,25),  - 1.00000)./CONSTANTS(:,14);
    ALGEBRAIC(:,48) = power(1.00000+exp(((STATES(:,1) -  - 10.0000) - 109.450)./27.4800),  - 1.00000);
    ALGEBRAIC(:,9) = piecewise({abs(STATES(:,1)+14.1000)<1.00000e-10, 0.00150000 }, ( 0.000300000.*(STATES(:,1)+14.1000))./(1.00000 - exp((STATES(:,1)+14.1000)./ - 5.00000)));
    ALGEBRAIC(:,26) = piecewise({abs(STATES(:,1) - 3.33280)<1.00000e-10, 0.000378361 }, ( 7.38980e-05.*(STATES(:,1) - 3.33280))./(exp((STATES(:,1) - 3.33280)./5.12370) - 1.00000));
    ALGEBRAIC(:,39) = power(ALGEBRAIC(:,9)+ALGEBRAIC(:,26),  - 1.00000);
    ALGEBRAIC(:,49) = power(1.00000+exp((STATES(:,1)+14.1000)./ - 6.50000),  - 1.00000);
    ALGEBRAIC(:,10) = piecewise({abs(STATES(:,1) - 19.9000)<1.00000e-10, 0.000680000 }, ( 4.00000e-05.*(STATES(:,1) - 19.9000))./(1.00000 - exp((STATES(:,1) - 19.9000)./ - 17.0000)));
    ALGEBRAIC(:,27) = piecewise({abs(STATES(:,1) - 19.9000)<1.00000e-10, 0.000315000 }, ( 3.50000e-05.*(STATES(:,1) - 19.9000))./(exp((STATES(:,1) - 19.9000)./9.00000) - 1.00000));
    ALGEBRAIC(:,40) =  0.500000.*power(ALGEBRAIC(:,10)+ALGEBRAIC(:,27),  - 1.00000);
    ALGEBRAIC(:,50) = power(1.00000+exp((STATES(:,1) - 19.9000)./ - 12.7000),  - 0.500000);
    ALGEBRAIC(:,41) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log(CONSTANTS(:,13)./STATES(:,6));
    ALGEBRAIC(:,51) = ( CONSTANTS(:,4).*CONSTANTS(:,12).*(STATES(:,1) - ALGEBRAIC(:,41)))./(1.00000+exp( 0.0700000.*(STATES(:,1)+80.0000)));
    ALGEBRAIC(:,52) =  CONSTANTS(:,4).*CONSTANTS(:,15).*power(STATES(:,7), 3.00000).*STATES(:,8).*(STATES(:,1) - ALGEBRAIC(:,41));
    ALGEBRAIC(:,53) = 0.00500000+0.0500000./(1.00000+exp((STATES(:,1) - 15.0000)./ - 13.0000));
    ALGEBRAIC(:,54) =  CONSTANTS(:,4).*ALGEBRAIC(:,53).*power(STATES(:,9), 3.00000).*STATES(:,10).*(STATES(:,1) - ALGEBRAIC(:,41));
    ALGEBRAIC(:,55) = ( CONSTANTS(:,4).*CONSTANTS(:,16).*STATES(:,11).*(STATES(:,1) - ALGEBRAIC(:,41)))./(1.00000+exp((STATES(:,1)+15.0000)./22.4000));
    ALGEBRAIC(:,56) =  CONSTANTS(:,4).*CONSTANTS(:,17).*power(STATES(:,12), 2.00000).*(STATES(:,1) - ALGEBRAIC(:,41));
    ALGEBRAIC(:,58) = power(1.00000+ 0.124500.*exp((  - 0.100000.*CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2)))+ 0.0365000.*CONSTANTS(:,46).*exp((  - CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2))),  - 1.00000);
    ALGEBRAIC(:,59) = ( (( CONSTANTS(:,4).*CONSTANTS(:,21).*ALGEBRAIC(:,58).*1.00000)./(1.00000+power(CONSTANTS(:,19)./STATES(:,2), 1.50000))).*CONSTANTS(:,13))./(CONSTANTS(:,13)+CONSTANTS(:,20));
    ALGEBRAIC(:,61) =  CONSTANTS(:,4).*CONSTANTS(:,24).*(STATES(:,1) - ALGEBRAIC(:,41));
    ALGEBRAIC(:,18) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./CONSTANTS(:,3)).*log(CONSTANTS(:,11)./STATES(:,2));
    ALGEBRAIC(:,31) =  CONSTANTS(:,4).*CONSTANTS(:,10).*power(STATES(:,3), 3.00000).*STATES(:,4).*STATES(:,5).*(STATES(:,1) - ALGEBRAIC(:,18));
    ALGEBRAIC(:,64) = ( CONSTANTS(:,4).*CONSTANTS(:,26).*( exp(( CONSTANTS(:,30).*CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2))).*power(STATES(:,2), 3.00000).*CONSTANTS(:,25) -  exp(( (CONSTANTS(:,30) - 1.00000).*CONSTANTS(:,3).*STATES(:,1))./( CONSTANTS(:,1).*CONSTANTS(:,2))).*power(CONSTANTS(:,11), 3.00000).*STATES(:,13)))./( (power(CONSTANTS(:,27), 3.00000)+power(CONSTANTS(:,11), 3.00000)).*(CONSTANTS(:,28)+CONSTANTS(:,25)).*(1.00000+ CONSTANTS(:,29).*exp(( (CONSTANTS(:,30) - 1.00000).*STATES(:,1).*CONSTANTS(:,3))./( CONSTANTS(:,1).*CONSTANTS(:,2)))));
    ALGEBRAIC(:,62) =  CONSTANTS(:,4).*CONSTANTS(:,22).*(STATES(:,1) - ALGEBRAIC(:,18));
    ALGEBRAIC(:,1) = piecewise({VOI>=CONSTANTS(:,5)&VOI<=CONSTANTS(:,6)&(VOI - CONSTANTS(:,5)) -  floor((VOI - CONSTANTS(:,5))./CONSTANTS(:,7)).*CONSTANTS(:,7)<=CONSTANTS(:,8), CONSTANTS(:,9) }, 0.00000);
    ALGEBRAIC(:,57) =  CONSTANTS(:,4).*CONSTANTS(:,18).*STATES(:,14).*STATES(:,15).*STATES(:,16).*(STATES(:,1) - 65.0000);
    ALGEBRAIC(:,65) = ( CONSTANTS(:,4).*CONSTANTS(:,31).*STATES(:,13))./(0.000500000+STATES(:,13));
    ALGEBRAIC(:,60) =  (( CONSTANTS(:,1).*CONSTANTS(:,2))./( 2.00000.*CONSTANTS(:,3))).*log(CONSTANTS(:,25)./STATES(:,13));
    ALGEBRAIC(:,63) =  CONSTANTS(:,4).*CONSTANTS(:,23).*(STATES(:,1) - ALGEBRAIC(:,60));
    ALGEBRAIC(:,66) =  CONSTANTS(:,32).*power(STATES(:,18), 2.00000).*STATES(:,19).*STATES(:,20).*(STATES(:,17) - STATES(:,13));
    ALGEBRAIC(:,68) = (STATES(:,21) - STATES(:,17))./CONSTANTS(:,33);
    ALGEBRAIC(:,67) =  1000.00.*( 1.00000e-15.*CONSTANTS(:,48).*ALGEBRAIC(:,66) -  (1.00000e-15./( 2.00000.*CONSTANTS(:,3))).*( 0.500000.*ALGEBRAIC(:,57) -  0.200000.*ALGEBRAIC(:,64)));
    ALGEBRAIC(:,69) = power(1.00000+exp( - (ALGEBRAIC(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);
    ALGEBRAIC(:,70) = 1.91000+ 2.09000.*power(1.00000+exp( - (ALGEBRAIC(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);
    ALGEBRAIC(:,72) = 1.00000 - power(1.00000+exp( - (ALGEBRAIC(:,67) - 6.83500e-14)./1.36700e-15),  - 1.00000);
    ALGEBRAIC(:,71) = CONSTANTS(:,34)./(1.00000+CONSTANTS(:,35)./STATES(:,13));
    ALGEBRAIC(:,73) = ( CONSTANTS(:,34).*STATES(:,21))./CONSTANTS(:,36);
    ALGEBRAIC(:,74) = ( 2.00000.*ALGEBRAIC(:,64) - (ALGEBRAIC(:,65)+ALGEBRAIC(:,57)+ALGEBRAIC(:,63)))./( 2.00000.*CONSTANTS(:,44).*CONSTANTS(:,3))+( CONSTANTS(:,49).*(ALGEBRAIC(:,73) - ALGEBRAIC(:,71))+ ALGEBRAIC(:,66).*CONSTANTS(:,48))./CONSTANTS(:,44);
    ALGEBRAIC(:,75) = 1.00000+( CONSTANTS(:,38).*CONSTANTS(:,41))./power(STATES(:,13)+CONSTANTS(:,41), 2.00000)+( CONSTANTS(:,37).*CONSTANTS(:,40))./power(STATES(:,13)+CONSTANTS(:,40), 2.00000);
    ALGEBRAIC(:,15) = ( CONSTANTS(:,37).*STATES(:,13))./(STATES(:,13)+CONSTANTS(:,40));
    ALGEBRAIC(:,16) = ( CONSTANTS(:,38).*STATES(:,13))./(STATES(:,13)+CONSTANTS(:,41));
    ALGEBRAIC(:,17) = ( CONSTANTS(:,39).*STATES(:,17))./(STATES(:,17)+CONSTANTS(:,42));
end

% Compute result of a piecewise function
function x = piecewise(cases, default)
    set = [0];
    for i = 1:2:length(cases)
        if (length(cases{i+1}) == 1)
            x(cases{i} & ~set,:) = cases{i+1};
        else
            x(cases{i} & ~set,:) = cases{i+1}(cases{i} & ~set);
        end
        set = set | cases{i};
        if(set), break, end
    end
    if (length(default) == 1)
        x(~set,:) = default;
    else
        x(~set,:) = default(~set);
    end
end

% Pad out or shorten strings to a set length
function strout = strpad(strin)
    req_length = 160;
    insize = size(strin,2);
    if insize > req_length
        strout = strin(1:req_length);
    else
        strout = [strin, blanks(req_length - insize)];
    end
end

