%% Courtemanche_ramirez_nattel variazione costanti
%Cambiano solo G_Na e K1, esegue il codice 100 volte e crea 100 vettori di 
%lunghezze diverse corrispondenti agli output V_m ottenuti variando i
%parametri appena citati, poi plotta il grafico

clear all
clc
close all

V ={};
W = {};
valoriInput = xlsread('prova_input256.xls','B2:G257');

for i=1:256
    
    parameters = valoriInput(i,:);
    [VOI, STATES, ALGEBRAIC, CONSTANTS, RATES] = courtemanche_ramirez_nattel_1998_EDIT(parameters);
    V(i)={VOI};
    W(i)={STATES(:,1)};
    
    % calcolo dei biomarkers:
    vv = STATES(:,1);
    V_max(i) = max(vv);  % massimo voltaggio
    dVdt(i) = max(RATES(1)) % max slope of the action potential upstroke
    RestV(i) = min(vv);  
    
    for j = 1: length(STATES)
        if vv(j) >= (RestV(i) + V_max(i))*0.50
            APD50(i) = j;
        end
        if vv(j) >= (RestV(i) + V_max(i))*0.90
            APD90(i) = j;
        end
    end
    
    V_20(i) = vv(int8(APD90(i) * 0.20));
    V_40(i) = vv(int8(APD90(i) * 0.40));
    V_60(i) = vv(int8(APD90(i) * 0.60));
    V_80(i) = vv(int8(APD90(i) * 0.80));
    
    G_K1(i) = CONSTANTS(:,12);
    G_to(i) = CONSTANTS(:,15);
    G_Kr(i) = CONSTANTS(:,16);
    G_CaL(i) = CONSTANTS(:,18);
    i_NaKmax(i) = CONSTANTS(:,21);
    Gb_Ca(i) =  CONSTANTS(:,23);
    
    
end

valoriOutput = [dVdt', V_max', V_20', V_40', V_60', V_80', APD50', APD90', RestV'];
xlswrite('BIOMARKER_VALUES_256iteration.xls', valoriOutput);


    
% 
% for i=1:100
%     plot(cell2mat(V(i)), cell2mat(W(i)));
%     legend('time','')
%     hold on;
% end

% %% Biomarkers used to characyerized each simulation
