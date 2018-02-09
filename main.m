%% Clean env
clear; clc; close all;
% Execute one of Step 1 or Step 6 using run selection option
%% Step 1 - Initial dataset (Step 1-4 are plot at the end)
data = [load('dataset1_inputs.txt') load('dataset1_outputs.txt')];
% For Visualisation
Ws = [1, 5, 10, 12, 20]; % Extra degree choice : 12
interval = [-1.05, 1.05]; % interval : xmin, xmax
%% Step 6 - Bonus dataset
data = [load('dataset2_inputs.txt') load('dataset2_outputs.txt')];
Ws = [1, 5, 7, 10, 20]; % Extra degree choice : 7
interval = [-.95, 1.25]; % interval : xmin, xmax
%% Init
% Ensuring size coherence
if (length(data(:,1)) ~= length(data(:,2))); error('inputs/outputs should be same size'); end
% Utils
SI = size(data,1);
lambda = 0.001;
% shuffle lambda fct
shuffle = @(v)v(randperm(size(v,1)),:);
%% Step 2 - ERM
% Vector that is storing empirical losses
El_erm = zeros(20,1);
for w = 1:20
    % our fitting polynomial function (WR : without regularisation)
    fe = fitpolyWR(w, data);
    % our least square loss function
    el = slf(fe, data);
    El_erm(w) = el;
end
El_erm = El_erm/max(El_erm); % normalizing
%% Step 3 - RLM
El_rlm = zeros(20,1);
for w = 1:20
    % our fitting polynomial function (Reg : with regularisation)
    fr = fitpolyReg(w, data, lambda);
    el = slf(fr, data);
    El_rlm(w) = el;
end
El_rlm = El_rlm/max(El_rlm);
%% Step 4 - xValidation
El_xv = zeros(20,1);
rdata = shuffle(data);
for w = 1:20
    % sum of all loss functions
    itlf = 0;
    for i = 1:10
       div = i * 10;
       % select specific indexes
       testd = rdata(div-9:div,:);
       % train
       % select other indexes
       traindx = rdata(~ismember(rdata(:,1),testd),1);
       traindy = rdata(~ismember(rdata(:,2),testd),2);
       traind = [traindx traindy];
       % Build function and quadratic loss test
       sfr = fitpolyReg(w, traind, lambda);
       itlf = itlf + slf(sfr, testd);
    end
    El_xv(w) = 1/10*itlf;
end
El_xv = El_xv / max(El_xv);
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