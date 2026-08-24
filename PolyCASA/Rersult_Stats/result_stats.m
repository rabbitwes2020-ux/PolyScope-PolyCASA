clc
close all
clear all
%% Create list of file names
file_names = [];
clear i new_name
for i = [2,7,8]
    new_name = ['CASA_0815_vid_'+ string(i)];
    file_names = [file_names,new_name];
end

clear i new_name
for i = [1,5,6,7,8,9,10,12,15,16]
    new_name = ['CASA_0816_vid_'+ string(i)];
    file_names = [file_names,new_name];
end

clear i new_name
for i = [5,6,8,11,13,14,15,16]
    new_name = ['CASA_0822_vid_'+ string(i)];
    file_names = [file_names,new_name];
end

clear i new_name
for i = [1,2,4,5,6,9,10,15,16,22]
    new_name = ['CASA_0823_vid_'+ string(i)];
    file_names = [file_names,new_name];
end
%% Load measurements
clear casa casa_idx
casa.file_names = file_names;

casa.count = [];
casa.area = [];
casa.ecc = [];

casa_idx.v_idx = {}; % index for velocity stats - same trajs; for thesis: >100 points

casa.VCL = [];
casa.VAP = [];
casa.VSL = [];

casa.STR = [];
casa.LIN = [];
casa.WOB = [];

casa.ALH = [];
casa.BCF = [];
casa.MAD = [];

casa.traj_l = [];

casa_idx.curv_idx = {};
casa.curv = [];
casa.abs_curv = [];
%%
fileFolder = 'C:\Users\od19522\OneDrive - University of Bristol\PolyScope CASA\CASA space\CASA analysis\Videos & Results';

for k = 1:numel(file_names)
    fileName = char(file_names(k));
    readName = [fileFolder , '\', fileName , '.mat'];

    load(readName)

    casa.count = [casa.count, CASA_count]; % count/um^2
    casa.area = [casa.area, area_mean]; % um^2
    casa.ecc = [casa.ecc, ecc_mean];

    v_idx = find(~isnan(VCL_list));
    casa_idx.v_idx{k} = v_idx;

    casa.VCL = [casa.VCL,nanmean(VCL_list(v_idx))]; % mu/s
    casa.VAP = [casa.VAP,nanmean(VAP_list(v_idx))];
    casa.VSL = [casa.VSL,nanmean(VSL_list(v_idx))];

    casa.STR = [casa.STR,nanmean(STR_list(v_idx))];
    casa.LIN = [casa.LIN,nanmean(LIN_list(v_idx))];
    casa.WOB = [casa.WOB,nanmean(WOB_list(v_idx))];

    casa.ALH = [casa.ALH,nanmean(ALH_list)];
    casa.BCF = [casa.BCF,nanmean(BCF_list)];
    casa.MAD = [casa.MAD,nanmean(MAD_list)];

    casa.traj_l = [casa.traj_l,mean(traj_length_list)];

    casa_idx.curv_idx{k} =  CURV_valid(1,:);
    casa.curv = [casa.curv, mean(CURV_valid(2,:))./mu]; % renew -> /um
    casa.abs_curv = [casa.abs_curv, mean(CURV_valid(3,:))./mu]; % renew -> /um

    clear v_idx

    k
   
end

%% Load variations
clear casa_err
casa_err.file_names = file_names;

casa_err.count = [];
casa_err.area = [];
casa_err.ecc = [];

% casa_err.v_idx = {};

casa_err.VCL = [];
casa_err.VAP = [];
casa_err.VSL = [];

casa_err.STR = [];
casa_err.LIN = [];
casa_err.WOB = [];

casa_err.ALH = [];
casa_err.BCF = [];
casa_err.MAD = [];

casa_err.traj_l = [];

% casa_err.curv_idx = {};
casa_err.curv = [];
casa_err.abs_curv = [];

%% Calculate variations
for k = 1:numel(file_names)
    fileName = char(file_names(k));
    readName = [fileFolder , '\', fileName , '.mat'];

    load(readName)

    %get CASA_count uncertainty
    allLabels = [traj_frame_no{:}];
    uniqueLabels = unique(allLabels);
    frame_freq = histc(allLabels, uniqueLabels);
    casa_err.count = [casa_err.count, (std(frame_freq)./mean(frame_freq))*CASA_count];
    
    casa_err.area = [casa_err.area, std(areas_all)];
    casa_err.ecc = [casa_err.ecc, std(eccs_all)];

    v_idx = find(~isnan(VCL_list));
    % casa_err_idx.v_idx{k} = v_idx;

    casa_err.VCL = [casa_err.VCL,nanstd(VCL_list(v_idx))];
    casa_err.VAP = [casa_err.VAP,nanstd(VAP_list(v_idx))];
    casa_err.VSL = [casa_err.VSL,nanstd(VSL_list(v_idx))];

    casa_err.STR = [casa_err.STR,nanstd(STR_list(v_idx))];
    casa_err.LIN = [casa_err.LIN,nanstd(LIN_list(v_idx))];
    casa_err.WOB = [casa_err.WOB,nanstd(WOB_list(v_idx))];

    casa_err.ALH = [casa_err.ALH,nanstd(ALH_list)];
    casa_err.BCF = [casa_err.BCF,nanstd(BCF_list)];
    casa_err.MAD = [casa_err.MAD,nanstd(MAD_list)];

    casa_err.traj_l = [casa_err.traj_l,std(traj_length_list)];

    % casa_err.curv_idx{k} =  CURV_valid(1,:);
    casa_err.curv = [casa_err.curv, nanstd(CURV_valid(2,:))./mu];
    casa_err.abs_curv = [casa_err.abs_curv, nanstd(CURV_valid(3,:))./mu];

    clear v_idx

    k
end
%%
 clearvars('-except','fileFolder','casa','casa_err', 'casa_idx','file_names')
%% Unique tests list
idx_uniq = [1,2,4,5,6,9,11,12,14,22,24,27,31];
idx_non_same = [1,4,5,11,27,31];
% idx_uniq = [2,6,9,12,14,18,22,24];

idx_0815_t4 = [2,3];
idx_0816_t3 = [6,7,8];
idx_0816_t4 = [9,10];
idx_0816_t7 = [12,13];
idx_0822_t2 = [14,15,16,17];
idx_0823_t1 = [22,23];
idx_0823_t2 = [24,25,26];

idx_0822_t3 = [18,19,20,21]; %swim-up of 0822_t2
idx_0823_t4 = [28,29]; %swim-up of idx_0823_t1
%%
clear idx_same_t
idx_same_t = {idx_0815_t4, idx_0816_t3, idx_0816_t4, idx_0816_t7, idx_0822_t2,idx_0823_t1, idx_0823_t2};

%% Compare mean variation of same tests vs. different tests: all raw samples
fieldNames = fieldnames(casa);

clear var_uniq
var_uniq.file_names = casa.file_names;

% Iterate over the field names
for i = 2:numel(fieldNames)
    % Get the current field name
    currentField = fieldNames{i};

    % if currentField == string'v_idx'
    %     skip
    % else    
    % Access the data in the current field
    data = casa.(currentField);

    var_uniq.(currentField) = abs(std(data(idx_uniq))./mean(data(idx_uniq)));
    % end
end
%% 
clear var_same
% Iterate over the field names
for i = 2:numel(fieldNames)
    % Get the current field name
    currentField = fieldNames{i};
    
    % Access the data in the current field
    data = casa.(currentField);

    data_means = [];
    data_vars = [];
    for k = 1: numel(idx_same_t)
        current_idx = idx_same_t{k};
        data_means = [data_means,mean(data(current_idx))];
        data_vars = [data_vars,std(data(current_idx))];
    end
    var_same.(currentField) = abs(mean(data_vars./data_means));
end

%% Plot 1.1 - clustering
colors = {
    'r',       % Red
    'g',       % Green
    'b',       % Blue
    'c',       % Cyan
    'm',       % Magenta
    'k',       % Black
    [1, 0.5, 0] % Orange
};
figure,
% scatter3(casa.count([1,2,3]),casa.VCL([1,2,3]),casa.WOB([1,2,3]));
 % scatter3(casa.count(idx_non_same),casa.VCL(idx_non_same),casa.MAD(idx_non_same),'k','o');
 % errorbar3(casa.count(idx_non_same),casa.VCL(idx_non_same),casa.MAD(idx_non_same), casa_err.count(idx_non_same),casa_err.VCL(idx_non_same),casa_err.MAD(idx_non_same),'k');
% hold on
for k = 1%: numel(idx_same_t)
    current_idx = idx_same_t{k};
    scatter3(casa.count(current_idx),casa.VAP(current_idx),casa.BCF(current_idx),36, colors{k},'filled','o');
    % errorbar3(casa.count(current_idx),casa.VAP(current_idx),casa.STR(current_idx),casa_err.count(current_idx),casa_err.VAP(current_idx),casa_err.STR(current_idx), colors{k})
end
hold on
for k = 2: numel(idx_same_t)
    current_idx = idx_same_t{k};
    scatter3(casa.count(current_idx),casa.VAP(current_idx),casa.BCF(current_idx),36, colors{k},'filled','o');
    % errorbar3(casa.count(current_idx),casa.VAP(current_idx),casa.STR(current_idx),casa_err.count(current_idx),casa_err.VAP(current_idx),casa_err.STR(current_idx), colors{k})
end
% Customize the plot
xlabel('cell count (count/um2)','Interpreter', 'latex');
ylabel('VAP (um/s)','Interpreter', 'latex');
zlabel('BCF (Hz)','Interpreter', 'latex');
title('Repeated Measurements of Same Samples','Interpreter', 'latex', 'FontSize', 16, 'FontWeight', 'Bold');

hold off
%% Plot 1.1 - check uncorrelation

% VAP = casa.VAP(idx_uniq)'; % VAP data
% STR = casa.STR(idx_uniq)'; % STR data
% count = casa.count(idx_uniq)'; % Count data
% 
% corr_data = [VAP, STR, count];
% % Calculate the correlation coefficients
% R = corrcoef(corr_data);
% 
% % Display the correlation matrix
% disp('Correlation matrix:');
% disp(R);
% 
% 
% % Perform Pearson correlation tests
% [r_VAP_STR, p_VAP_STR] = corr(VAP, STR, 'Type', 'Pearson');
% [r_VAP_count, p_VAP_count] = corr(VAP, count, 'Type', 'Pearson');
% [r_STR_count, p_STR_count] = corr(STR, count, 'Type', 'Pearson');
% 
% % Display the correlation coefficients and p-values
% fprintf('VAP vs STR: r = %.3f, p = %.3f\n', r_VAP_STR, p_VAP_STR);
% fprintf('VAP vs Count: r = %.3f, p = %.3f\n', r_VAP_count, p_VAP_count);
% fprintf('STR vs Count: r = %.3f, p = %.3f\n', r_STR_count, p_STR_count);
% 
% % Visualize the data
% figure;
% subplot(1,3,1);
% scatter(VAP, STR);
% xlabel('VAP');
% ylabel('STR');
% title('VAP vs STR');
% grid on;
% 
% subplot(1,3,2);
% scatter(VAP, count);
% xlabel('VAP');
% ylabel('Count');
% title('VAP vs Count');
% grid on;
% 
% subplot(1,3,3);
% scatter(STR, count);
% xlabel('STR');
% ylabel('Count');
% title('STR vs Count');
% grid on;

%% Plot 1.2 - Compare same vs. unique tests 
% Data for variations from the same tests
var_same_data = [];
for i = 2:numel(fieldNames)
    currentField = fieldNames{i};
    var_same_data = [var_same_data, var_same.(currentField)];
end

% Data for variations from the uniq tests
var_uniq_data = [];
for i = 2:numel(fieldNames)
    currentField = fieldNames{i};
    var_uniq_data = [var_uniq_data, var_uniq.(currentField)];
end

% Measurements labels
measurements = {'cell count', 'cell size', 'cell eccentricity', 'VCL', 'VAP', 'VSL', 'STR', 'LIN', 'WOB', 'ALH', 'BCF','MAD', 'CURV', 'Abs CURV'};
% Create a bar chart
figure;
hold on;

% Bar width
bar_width = 0.4;

% Plotting bars
bar(1:length(var_same_data)-1, var_same_data([1:12,14,15]).*100, bar_width, 'FaceColor', [0.2 0.2 0.8], 'DisplayName', 'var\_same');

bar(double(1:length(var_uniq_data)-1) + bar_width, var_uniq_data([1:12,14,15]).*100, bar_width, 'FaceColor', [0.8 0.2 0.2], 'DisplayName', 'var\_uniq');

% Setting x-axis labels
set(gca, 'XTick', 1:length(measurements) + bar_width/2, 'XTickLabel', measurements);

% Labels and title
xlabel('Measurements');
ylabel('Variation  (%)');
title('Comparison of Measurement Variations of Same and Unique Tests');
legend('Location', 'best');
grid on;
hold off;

% Rotate x-axis labels for better visibility
xtickangle(45);
%% Plot 2: Check all correlations 

% Based on sample results: sample size too small!

% Based on trajs:
fileFolder = 'C:\Users\od19522\OneDrive - University of Bristol\PolyScope CASA\CASA space\CASA analysis\Videos & Results';

VCL = []; % VCL data
VAP = []; % VAP data
VSL = []; % VSL data
STR = []; % STR data
LIN = []; % LIN data
WOB = []; % WOB data
ALH = []; % ALH data
BCF = []; % BCF data
MAD = []; % MAD data
abs_CURV = [];
traj_l = []; % Trajectory length data


for k = [1:29,31]%
    fileName = char(file_names(k));
    readName = [fileFolder , '\', fileName , '.mat'];

    load(readName)

    idx = intersect(find(~isnan(ALH_list)),find(~isnan(VCL_list)));
    idx = intersect(idx,CURV_valid(1,:));

    VCL = [VCL;VCL_list(idx)']; % VCL data
    VAP = [VAP;VAP_list(idx)']; % VAP data
    VSL = [VSL;VSL_list(idx)']; % VSL data
    STR = [STR;STR_list(idx)']; % STR data
    LIN = [LIN;LIN_list(idx)']; % LIN data
    WOB = [WOB;WOB_list(idx)']; % WOB data
    ALH = [ALH;ALH_list(idx)']; % ALH data
    BCF = [BCF;BCF_list(idx)']; % BCF data
    MAD = [MAD;MAD_list(idx)']; % MAD data
    abs_CURV = [abs_CURV;CURV_abs_list(idx)'];
    traj_l = [traj_l;traj_length_list(idx)']; % Trajectory length data

    clear idx
    
    k

    length(VCL)
end

% count = casa.count(idx_uniq)'; % Count data
% area = casa.area(idx_uniq)'; % Area data
% ecc = casa.ecc(idx_uniq)'; % Eccentricity data
% VCL = casa.VCL(idx_uniq)'; % VCL data
% VAP = casa.VAP(idx_uniq)'; % VAP data
% VSL = casa.VSL(idx_uniq)'; % VSL data
% STR = casa.STR(idx_uniq)'; % STR data
% LIN = casa.LIN(idx_uniq)'; % LIN data
% WOB = casa.WOB(idx_uniq)'; % WOB data
% ALH = casa.ALH(idx_uniq)'; % ALH data
% BCF = casa.BCF(idx_uniq)'; % BCF data
% MAD = casa.MAD(idx_uniq)'; % MAD data
% traj_l = casa.traj_l(idx_uniq)'; % Trajectory length data
%%
% Combine all variables into a matrix
% corr_data = [count, area, ecc, VCL, VAP, VSL, STR, LIN, WOB, ALH, BCF, MAD, traj_l];

corr_data = [VCL, VAP, VSL, STR, LIN, WOB, ALH, BCF, MAD,abs_CURV, traj_l];

% Calculate the correlation matrix
R = corrcoef(corr_data);

% Display the correlation matrix
disp('Correlation matrix:');
disp(R);

% Variable names
% var_names = {'count', 'area', 'ecc', 'VCL', 'VAP', 'VSL', 'STR', 'LIN', 'WOB', 'ALH', 'BCF', 'MAD', 'traj_l'};
var_names = {'VCL', 'VAP', 'VSL', 'STR', 'LIN', 'WOB', 'ALH', 'BCF', 'MAD','abs CURV', 'traj_l'};

% Perform Pearson correlation tests and display the results
fprintf('Pearson correlation coefficients and p-values:\n');
for i = 1:length(var_names)
    for j = i+1:length(var_names)
        [r, p] = corr(corr_data(:, i), corr_data(:, j), 'Type', 'Pearson');
        fprintf('%s vs %s: r = %.3f, p = %.3f\n', var_names{i}, var_names{j}, r, p);
    end
end

% Visualize the correlation matrix using a heatmap
figure;
h = heatmap(var_names, var_names, R, 'Colormap', jet, 'ColorLimits', [-1 1]);
title('General Correlation of Sperm Parameters Matrix Heatmap');
% xlabel('Variables');
% ylabel('Variables');
colorbar;
% Visualize the data
% figure;
% scatter(VAP, STR);
% xlabel('VAP');
% ylabel('STR');
% title('VAP vs STR');
% grid on;

%% Table. Compare results: swim up vs. normal
normal_means = [];
normal_vars = [];
swup_means = [];
swup_vars = [];
clear currentField data data_means data_vars
for i = 2:numel(fieldNames)

    % Get the current field name
    currentField = fieldNames{i};
    
    % Access the data in the current field
    data = casa.(currentField);

    normal_means = [normal_means,mean(data(idx_0822_t2))];
    normal_vars = [normal_vars,std(data(idx_0822_t2))];

    swup_means = [swup_means,mean(data(idx_0822_t3))];
    swup_vars = [swup_vars,std(data(idx_0822_t3))];

    % normal_means = [normal_means,mean(data(idx_0823_t1))];
    % normal_vars = [normal_vars,std(data(idx_0823_t1))];
    % 
    % swup_means = [swup_means,mean(data(idx_0823_t4))];
    % swup_vars = [swup_vars,std(data(idx_0823_t4))];
end

% Use table to present


%% Plot

% Measurements labels
measurements = {'cell count', 'cell size', 'cell eccentricity', 'VCL', 'VAP', 'VSL', 'STR', 'LIN', 'WOB', 'ALH', 'BCF','MAD', 'Traj length'};

% Create a bar chart
figure;
hold on;

% Bar width
bar_width = 0.4;

% Plotting bars
b1 = bar(1:length(normal_means), normal_means.*100, bar_width, 'FaceColor', [0.2 0.2 0.8], 'DisplayName', 'var\_same');
b2 = bar(double(1:length(swup_means)) + bar_width, swup_means.*100, bar_width, 'FaceColor', [0.8 0.2 0.2], 'DisplayName', 'var\_uniq');

% Adding error bars
errorbar(1:length(normal_means), normal_means.*100, normal_vars.*100, 'k', 'LineStyle', 'none', 'CapSize', 10, 'LineWidth', 1);
errorbar(double(1:length(swup_means)) + bar_width, swup_means.*100, swup_vars.*100, 'k', 'LineStyle', 'none', 'CapSize', 10, 'LineWidth', 1);

% Setting x-axis labels
set(gca, 'XTick', 1:length(measurements) + bar_width/2, 'XTickLabel', measurements);

% Labels and title
xlabel('Measurements');
ylabel('Variation  (%)');
title('Comparison of Variations from Same and Different Tests');
legend('Location', 'best');
grid on;
hold off;

% Rotate x-axis labels for better visibility
xtickangle(45);
%% Fitting histogram
% clear all
% 
% fileFolder = 'C:\Users\od19522\OneDrive - University of Bristol\PolyScope CASA\CASA space\CASA analysis\Videos & Results';
% fileName = '0823_vid_10';
% saveName = [fileFolder,'\','CASA_',fileName,'.mat'];
% 
% load(saveName)
% %%
% % figure,hist(areas_all,50);
% % figure,hist(eccs_all,50);
% figure,hist(VCL_list,50);
% % figure,hist(VSL_list,50);
% % figure, hist(VAP_list(find(VAP_list)),50);
% % figure,hist(LIN_list,50)
% % figure,hist(STR_list,50)
% % figure,hist(WOB_list,50)
% % figure,hist(ALH_list,50)
% % figure,hist(BCF_list,50)
% % figure,hist(MAD_list,50)
% % figure,hist(CURV_list,50)
% % figure,hist(CURV_abs_list,50)
% % figure,hist(CURV_valid,50)
% % figure,hist(BCF_list,50)
% % VAP_valid = VAP_list(~isnan(VAP_list));
% % VCL_valid = VCL_list(~isnan(VCL_list));
% 
% 
