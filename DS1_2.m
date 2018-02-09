%% Step 5 - Visualisation
close all;
% We chosed to split ERM ans RLM for redability
% Loops are separated because of matlab's funny acts with hold on/off
% ERM
curvesERM = zeros(length(Ws),1);
legends = string(zeros(length(Ws),1));

c = 1; % index counter
figure;
hold on
for w = Ws % Ws defined at Step 1, depends on dataset
    fctERM = fitpolyWR(w, data);
    curvesERM(c,1) = fplot(fctERM, interval);    
    legends(c,1) = ("W = " +num2str(w));
    c = c+1;
end
legend(curvesERM,legends);
plot(data(:,1), data(:,2), 'x'); % plot datapoints
title('Visualisation ERM');
hold off
% RLM
c = 1;
curvesRLM = zeros(length(Ws),1);
figure;
hold on
for w = Ws
    fctRLM = fitpolyReg(w, data, lambda);
    curvesRLM(c,1) = fplot(fctRLM, interval);  
    c = c+1;
end
legend(curvesRLM,legends);
plot(data(:,1), data(:,2), 'x');
title('Visualisation RLM');
hold off
%% Plots
% Step 1-4
figure;
subplot(2,2,1);
plot(data(:,1), data(:,2), 'x'); title('inputs : f(xi) = ti');
subplot(2,2,2);
plot(El_erm); title('ERM - empirical loss / degree');
subplot(2,2,3);
plot(El_rlm); title('RLM - empirical loss / degree');
subplot(2,2,4);
plot(El_xv); title('xValidation - empirical loss / degree');