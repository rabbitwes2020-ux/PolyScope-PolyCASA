clc
close all
clear all
%% Load result
clear all
fileFolder = 'C:\Users\od19522\OneDrive - University of Bristol\PolyScope CASA\CASA space\CASA analysis\Videos & Results';

% fileName = '0822_vid_6';
% fileName = '0822_vid_14';
% fileName = '0823_vid_15';
fileName = '0816_vid_12';
titleName = fileName;
titleName(5) = ' ';
titleName(9) = ' ';
titleName = [titleName ' '];
saveName = [fileFolder,'\','CASA_',fileName,'.mat'];

% load(saveName,'VCL_all')
load(saveName)
% load(saveName,'VAP_all')
%% All parameter measurements


%% Fit VCL - Gaussian + Maxwell
% 
% allVCL = [VCL_all{:}];
% 
% % Generate random sample data
% data = allVCL(find(allVCL>0));
% % data = log10(allVCL(find(allVCL>0)));
% % data = allVCL;
% % data = VCL_list;
% 
% % Create histogram with frequency on y-axis
% num_bins = 200; % Number of bins
% [counts, edges] = histcounts(data, num_bins, 'Normalization', 'probability');
% 
% % Calculate bin centers
% bin_centers = (edges(1:end-1) + edges(2:end)) / 2;
% 
% % Define custom Gaussian function for fitting
% % gaussEqn = 'a*exp(-((x-b)/c)^2)';
% % gaussEqn = ['R_1*(sqrt(2/pi) * (x.^2) .* exp(-x.^2 / (2 * sigma_1^2)) / sigma_1^3)' ...
% % '+R_2*(sqrt(2/pi) * (x.^2) .* exp(-x.^2 / (2 * sigma_2^2)) / sigma_2^3)']
% 
% fitFunc = ['R_1 * exp(-((x-mu_1) ./ sigma_1).^2) + R_2 * (x * exp(-x.^2 / (2 * sigma_2^2)) / sigma_2^2)'];
% 
% % fitFunc = ['R_1*exp(-((x-mu_1)/sigma_1)^2) + R_2*exp(-((x-mu_2)/sigma_2)^2)'];
% 
% % Set up the fit options
% % fitOptions = fitoptions('Method', 'NonlinearLeastSquares', ...
% %                         'StartPoint', [max(counts), mean(data), std(data)]);
% 
% % startPoints = [0.1, 10, 0, 2, 30];
% % lowerBounds = [0, 0.1, 0, 0, 1];
% % upperBounds = [Inf, Inf, Inf, Inf, Inf];
% 
% % Normal + MBD
% startPoints = [0.1, 2, 10, 10, 50];
% lowerBounds = [0, 0, 0.01, 0.1, 1];
% upperBounds = [Inf, Inf, Inf, Inf, Inf];
% % [R1, R2, Mu1, sigma1, sigma2]
% 
% % Lon-norm + log-norm
%     % startPoints = [ 0.01,   0.01,  0.5, 2,  0.1,   0.1];
%     % lowerBounds = [0.0001,  0.0001,  -Inf, -Inf,   0, 0];
%     % upperBounds = [     Inf,       Inf,   Inf,  Inf,     Inf,   Inf];
%     % [R1, R2, mu1, mu2, sigma1, sigma2]
% 
% fitOptions = fitoptions('Method', 'NonlinearLeastSquares', ...
%     'StartPoint', startPoints, ...
%     'Lower', lowerBounds, ...
%     'Upper', upperBounds);
% 
% % Perform the fit
% fitResult = fit(bin_centers', counts', fitFunc, fitOptions);
% 
% % Extract the fitting parameters
% R_1 = fitResult.R_1;
% sigma_1 = fitResult.sigma_1;
% mu_1 = fitResult.mu_1;
% R_2 = fitResult.R_2;
% sigma_2 = fitResult.sigma_2;
% 
% % Display the fitting parameters
% disp(['Fitted parameter R_1: ', num2str(R_1)]);
% disp(['Fitted parameter sigma_1: ', num2str(sigma_1)]);
% disp(['Fitted parameter mu_1: ', num2str(mu_1)]);
% disp(['Fitted parameter R_2: ', num2str(R_2)]);
% disp(['Fitted parameter sigma_2: ', num2str(sigma_2)]);
% 
% % Generate values for the fitted distribution curve
% % x_values = linspace(min(data), max(data), 500);
% x_values = bin_centers;
% % x_values = linspace(min(data), 100, 200);
% fitted_values = feval(fitResult, x_values);
% 
% % Calculating ratios
% F_1 = R_1 * exp(-((x_values-mu_1) ./sigma_1).^2);
% F_2 = R_2 * (x_values .* exp(-x_values.^2 / (2 * sigma_2^2)) / sigma_2^2);
% 
% % F_1 = R_1*exp(-((x_values-mu_1)./sigma_1).^2);
% % F_2 = R_2*exp(-((x_values-mu_2)./sigma_2).^2);
% 
% disp(['Proportion of type I cells: ', num2str(sum(F_1))]);
% disp(['Proportion of type II cells: ', num2str(sum(F_2))]);
% 
% figure,
% bar(bin_centers, counts, 'hist');
% title([titleName 'Histogram with Custom Fit']);
% xlabel('Data Value');
% ylabel('Frequency (Probability Density)');
% grid on;
% hold on;
% plot(x_values, F_1, 'g', 'LineWidth', 2);
% plot(x_values, F_2, 'k', 'LineWidth', 2);
% plot(x_values, fitted_values, 'r', 'LineWidth', 2);
% legend('Histogram','F1','F2', 'Fitted Function');
% hold off;

%% Fit VCL - Log normal + Maxwell

% allVCL = [VCL_all{:}];
% 
% data = allVCL(find(allVCL>0));
% % data = log10(allVCL(find(allVCL>0)));
% % data = allVCL;
% % data = VCL_list;
% 
% % Create histogram with frequency on y-axis
% num_bins = 200; % Number of bins
% [counts, edges] = histcounts(data, num_bins, 'Normalization', 'probability');
% 
% % Calculate bin centers
% bin_centers = (edges(1:end-1) + edges(2:end)) / 2;
% 
% % Define custom function for fitting
% % gaussEqn = 'a*exp(-((x-b)/c)^2)';
% % gaussEqn = ['R_1*(sqrt(2/pi) * (x.^2) .* exp(-x.^2 / (2 * sigma_1^2)) / sigma_1^3)' ...
% % '+R_2*(sqrt(2/pi) * (x.^2) .* exp(-x.^2 / (2 * sigma_2^2)) / sigma_2^3)']
% 
% fitFunc = ['R_1*(1/(x*sigma_1*sqrt(2*pi)))*exp(-(log(x)-mu_1)^2/(2*sigma_1^2)) + R_2 * (x * exp(-x.^2 / (2 * sigma_2^2)) / sigma_2^2)'];
% 
% % fitFunc = ['R_1*exp(-((x-mu_1)/sigma_1)^2) + R_2*exp(-((x-mu_2)/sigma_2)^2)'];
% 
% % Set up the fit options
% 
% % log Normal + MBD
% startPoints = [0.01, 2, 0.5, 0.1, 50];
% lowerBounds = [0.0001, 0, -2, 0.1, 1];
% upperBounds = [Inf, Inf, Inf, Inf, Inf];
% % [R1, R2, Mu1, sigma1, sigma2]
% 
% fitOptions = fitoptions('Method', 'NonlinearLeastSquares', ...
%     'StartPoint', startPoints, ...
%     'Lower', lowerBounds, ...
%     'Upper', upperBounds);
% 
% % Perform the fit
% fitResult = fit(bin_centers', counts', fitFunc, fitOptions);
% 
% % Extract the fitting parameters
% R_1 = fitResult.R_1;
% sigma_1 = fitResult.sigma_1;
% mu_1 = fitResult.mu_1;
% R_2 = fitResult.R_2;
% sigma_2 = fitResult.sigma_2;
% 
% % Display the fitting parameters
% disp(['Fitted parameter R_1: ', num2str(R_1)]);
% disp(['Fitted parameter sigma_1: ', num2str(sigma_1)]);
% disp(['Fitted parameter mu_1: ', num2str(mu_1)]);
% disp(['Fitted parameter R_2: ', num2str(R_2)]);
% disp(['Fitted parameter sigma_2: ', num2str(sigma_2)]);
% 
% % Generate values for the fitted distribution curve
% % x_values = linspace(min(data), max(data), 500);
% x_values = bin_centers;
% % x_values = linspace(min(data), 100, 200);
% fitted_values = feval(fitResult, x_values);
% 
% % Calculate expected frequencies for each bin
% expected_counts = fitted_values * sum(counts);
% 
% % Calculate the chi-square statistic
% chi2_stat = sum((counts - expected_counts) .^ 2 ./ expected_counts);
% 
% % Compute degrees of freedom
% num_parameters = 5; % [R1, R2, Mu1, sigma1, sigma2]
% df = num_bins - num_parameters - 1;
% 
% % Determine the p-value
% p_value = 1 - chi2cdf(chi2_stat, df);
% 
% % Display the results
% disp(['Chi2 Statistic: ', num2str(chi2_stat)]);
% disp(['Degrees of Freedom: ', num2str(df)]);
% disp(['p-value: ', num2str(p_value)]);
% 
% 
% % Calculating ratios
% F_1 = R_1.*(1./(x_values.*sigma_1.*sqrt(2.*pi))).*exp(-(log(x_values)-mu_1).^2./(2.*sigma_1.^2));
% F_2 = R_2 * (x_values .* exp(-x_values.^2 / (2 * sigma_2^2)) / sigma_2^2);
% 
% disp(['Proportion of type I cells: ', num2str(sum(F_1))]);
% disp(['Proportion of type II cells: ', num2str(sum(F_2))]);
% 
% figure,
% bar(bin_centers, counts, 'hist');
% title([titleName 'Histogram with Custom Fit']);
% xlabel('Data Value');
% ylabel('Frequency (Probability Density)');
% grid on;
% hold on;
% plot(x_values, F_1, 'g', 'LineWidth', 2);
% plot(x_values, F_2, 'k', 'LineWidth', 2);
% plot(x_values, fitted_values, 'r', 'LineWidth', 2);
% legend('Histogram','F1','F2', 'Fitted Function');
% hold off;
%% Fit VCL - 2 log normals

allVCL = [VCL_all{:}];

data = allVCL(find(allVCL>0));
% data = log10(allVCL(find(allVCL>0)));
% data = allVCL;
% data = VCL_list;

% Create histogram with frequency on y-axis
num_bins = 200; % Number of bins
[counts, edges] = histcounts(data, num_bins, 'Normalization', 'probability');

% Calculate bin centers
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;

% Define custom function for fitting

% gaussEqn = 'a*exp(-((x-b)/c)^2)';
% gaussEqn = ['R_1*(sqrt(2/pi) * (x.^2) .* exp(-x.^2 / (2 * sigma_1^2)) / sigma_1^3)' ...
% '+R_2*(sqrt(2/pi) * (x.^2) .* exp(-x.^2 / (2 * sigma_2^2)) / sigma_2^3)']

% fitFunc = ['R_1 * exp(-((x-mu_1) ./ sigma_1).^2) + R_2 * (x * exp(-x.^2 / (2 * sigma_2^2)) / sigma_2^2)'];

fitFunc = ['R_1*(1/(x*sigma_1*sqrt(2*pi)))*exp(-(log(x)-mu_1)^2/(2*sigma_1^2)) + R_2*(1/(x*sigma_2*sqrt(2*pi)))*exp(-(log(x)-mu_2)^2/(2*sigma_2^2))'];

% Set up the fit options
% fitOptions = fitoptions('Method', 'NonlinearLeastSquares', ...
%                         'StartPoint', [max(counts), mean(data), std(data)]);

% Lon-norm + log-norm
    startPoints = [ 0.01,   0.02,  0.5, 2,  0.1,   0.1];
    lowerBounds = [0.0001,  0.0001,  -2, -2,   0, 0];
    upperBounds = [     1,       1,   5,  5,     5,   5];
    % [R1, R2, mu1, mu2, sigma1, sigma2]

fitOptions = fitoptions('Method', 'NonlinearLeastSquares', ...
    'StartPoint', startPoints, ...
    'Lower', lowerBounds, ...
    'Upper', upperBounds);

% Perform the fit
fitResult = fit(bin_centers', counts', fitFunc, fitOptions);

% Extract the fitting parameters
R_1 = fitResult.R_1;
R_2 = fitResult.R_2;
mu_1 = fitResult.mu_1;
mu_2 = fitResult.mu_2;
sigma_1 = fitResult.sigma_1;
sigma_2 = fitResult.sigma_2;

% Display the fitting parameters
disp(['Fitted parameter R_1: ', num2str(R_1)]);
disp(['Fitted parameter R_2: ', num2str(R_2)]);
disp(['Fitted parameter sigma_1: ', num2str(sigma_1)]);
disp(['Fitted parameter sigma_2: ', num2str(sigma_2)]);
disp(['Fitted parameter mu_1: ', num2str(mu_1)]);
disp(['Fitted parameter mu_2: ', num2str(mu_2)]);

% x_values = linspace(min(data), max(data), 500);
x_values = bin_centers;
% x_values = linspace(min(data), 100, 200);
fitted_values = feval(fitResult, x_values);

% Calculate expected frequencies for each bin
expected_counts = fitted_values * sum(counts);

% Calculate the chi-square statistic
chi2_stat = sum((counts - expected_counts) .^ 2 ./ expected_counts);

% Compute degrees of freedom
num_parameters = 6; % [R1, R2, Mu1, sigma1, sigma2]
df = num_bins - num_parameters - 1;

% Determine the p-value
p_value = 1 - chi2cdf(chi2_stat, df);

% Display the results
disp(['Chi2 Statistic: ', num2str(chi2_stat)]);
disp(['Degrees of Freedom: ', num2str(df)]);
disp(['p-value: ', num2str(p_value)]);

% Calculating ratios
% F_1 = R_1 * exp(-((x_values-mu_1) ./sigma_1).^2);
% F_2 = R_2 * (x_values .* exp(-x_values.^2 / (2 * sigma_2^2)) / sigma_2^2);

F_1 = R_1.*(1./(x_values.*sigma_1.*sqrt(2.*pi))).*exp(-(log(x_values)-mu_1).^2./(2.*sigma_1.^2));
F_2 = R_2.*(1./(x_values.*sigma_2.*sqrt(2.*pi))).*exp(-(log(x_values)-mu_2).^2./(2.*sigma_2.^2));

disp(['Proportion of type I cells: ', num2str(sum(F_1))]);
disp(['Proportion of type II cells: ', num2str(sum(F_2))]);

figure,
bar(bin_centers, counts, 'hist');
title([titleName 'Histogram with Custom Fit']);
xlabel('Data Value');
ylabel('Frequency (Probability Density)');
grid on;
hold on;
plot(x_values, F_1, 'g', 'LineWidth', 2);
plot(x_values, F_2, 'k', 'LineWidth', 2);
plot(x_values, fitted_values, 'r', 'LineWidth', 2);
legend('Histogram','F1','F2', 'Fitted Function');
hold off;

%% Fit log VCL - 2 Gaussians

% Generate random sample data
allVCL = [VCL_all{:}];

allVCL = allVCL(find(allVCL>0));

log_VCL = log10(allVCL);
data = log_VCL;

    % Create histogram with frequency on y-axis
    num_bins = 200; % Number of bins
    [counts, edges] = histcounts(data, num_bins, 'Normalization', 'probability');
    % [counts, edges] = histcounts(data, num_bins);

    % Calculate bin centers
    bin_centers = (edges(1:end-1) + edges(2:end)) / 2;

    % Define custom Gaussian function for fitting

    fitFunc = ['R_1*exp(-((x-mu_1)/sigma_1)^2) + R_2*exp(-((x-mu_2)/sigma_2)^2)'];
    % fitFunc = ['R_1*exp(-((x-mu_1)/sigma_1)^2)'] ;


    % startPoints = [ 0.07,   0.018,  1 , 2,  1,   1];
    % startPoints = [ 0.1,   0.1,  1 , 2,  1,   1];
    startPoints = [ 0.1,   0.1,  1 , 1,  1,   2];
    lowerBounds = [0.0001,  0.0001,  -Inf, -Inf,   0, 0];
    upperBounds = [     Inf,       Inf,   Inf,  Inf,     Inf,   Inf];
    % [R1, R2, mu1, mu2, sigma1, sigma2]


    fitOptions = fitoptions('Method', 'NonlinearLeastSquares', ...
        'StartPoint', startPoints, ...
        'Lower', lowerBounds, ...
        'Upper', upperBounds);

    

    % Perform the fit
    fitResult = fit(bin_centers', counts', fitFunc, fitOptions);

    % Extract the fitting parameters
    R_1 = fitResult.R_1;
    R_2 = fitResult.R_2;
    mu_1 = fitResult.mu_1;
    mu_2 = fitResult.mu_2;
    sigma_1 = fitResult.sigma_1;
    mu_2 = fitResult.mu_2;
    sigma_2 = fitResult.sigma_2;

    % Display the fitting parameters
    disp(['Fitted parameter R_1: ', num2str(R_1)]);
    disp(['Fitted parameter R_2: ', num2str(R_2)]);
    disp(['Fitted parameter mu_1: ', num2str(mu_1)]);
    disp(['Fitted parameter mu_2: ', num2str(mu_2)]);
    disp(['Fitted parameter sigma_1: ', num2str(sigma_1)]);
    disp(['Fitted parameter sigma_2: ', num2str(sigma_2)]);
    % disp(['Fitted parameter mu_2: ', num2str(mu_2)]);

    % Generate values for the fitted distribution curve
    % x_values = linspace(min(data), max(data), );
    x_values = bin_centers;
    % x_values = linspace(min(data), 100, 200);
    fitted_values = feval(fitResult, x_values);
    % Calculate expected frequencies for each bin
    expected_counts = fitted_values * sum(counts);

% Calculate the chi-square statistic
% chi2_stat = sum((counts - expected_counts) .^ 2 ./ expected_counts);
chi2_stat = sum((counts - fitted_values) .^ 2 ./ expected_counts);

% Compute degrees of freedom
num_parameters = 6; % [R1, R2, Mu1, sigma1, sigma2]
df = num_bins - num_parameters - 1;

% Determine the p-value
p_value = 1 - chi2cdf(chi2_stat, df);

% Display the results
disp(['Chi2 Statistic: ', num2str(chi2_stat)]);
disp(['Degrees of Freedom: ', num2str(df)]);
disp(['p-value: ', num2str(p_value)]);


    % Calculating ratios
    F_1 = R_1 * exp(-((x_values-mu_1) ./sigma_1).^2);
    F_2 = R_2 * exp(-((x_values-mu_2) ./sigma_2).^2);

    disp(['Proportion of type I cells: ', num2str(sum(F_1))]);
    disp(['Proportion of type II cells: ', num2str(sum(F_2))]);

    figure,
    bar(bin_centers, counts, 'hist');
    title([titleName 'Histogram with Custom Fit']);
    xlabel('Data Value');
    ylabel('Frequency (Probability Density)');
    grid on;
    hold on;
    plot(x_values, F_1, 'g', 'LineWidth', 2);
    plot(x_values, F_2, 'k', 'LineWidth', 2);
    plot(x_values, fitted_values, 'r', 'LineWidth', 2);
    legend('log VCL','F1','F2', 'Fitted Function');
    hold off;

%% Fit log CURV - 2 Gaussians

% Generate random sample data
% log_CURV = log10(abs(CURV_list));
% log_CURV = log10(CURV_abs_list);
allCURV = [CURV_all{:}];
curv_data = abs(allCURV);
log_CURV = log10(curv_data);
data = log_CURV;

if sum(~isnan(data)) < 2000;
    
    disp(['Not enough datapoints: ', num2str(sum(~isnan(data)))]);
    return; 
end

    % Create histogram with frequency on y-axis
    num_bins = 200; % Number of bins
    [counts, edges] = histcounts(data, num_bins, 'Normalization', 'probability');
    % [counts, edges] = histcounts(data, num_bins);

    % Calculate bin centers
    bin_centers = (edges(1:end-1) + edges(2:end)) / 2;

    % Define custom Gaussian function for fitting

    fitFunc = ['R_1*exp(-((x-mu_1)/sigma_1)^2) + R_2*exp(-((x-mu_2)/sigma_2)^2)'];
    % fitFunc = ['R_1*exp(-((x-mu_1)/sigma_1)^2)'] ;


    startPoints = [ 0.07,   0.018,  -2, 0,  1,   1];
    lowerBounds = [0.0001,  0.0001,  -Inf, -Inf,   0, 0];
    upperBounds = [     Inf,       Inf,   Inf,  Inf,     Inf,   Inf];
    % [R1, R2, mu1, mu2, sigma1, sigma2]


    fitOptions = fitoptions('Method', 'NonlinearLeastSquares', ...
        'StartPoint', startPoints, ...
        'Lower', lowerBounds, ...
        'Upper', upperBounds);

    

    % Perform the fit
    fitResult = fit(bin_centers', counts', fitFunc, fitOptions);

    % Extract the fitting parameters
    R_1 = fitResult.R_1;
    R_2 = fitResult.R_2;
    mu_1 = fitResult.mu_1;
    mu_2 = fitResult.mu_2;
    sigma_1 = fitResult.sigma_1;
    mu_2 = fitResult.mu_2;
    sigma_2 = fitResult.sigma_2;

    % Display the fitting parameters
    disp(['Fitted parameter R_1: ', num2str(R_1)]);
    disp(['Fitted parameter R_2: ', num2str(R_2)]);
    disp(['Fitted parameter mu_1: ', num2str(mu_1)]);
    disp(['Fitted parameter mu_2: ', num2str(mu_2)]);
    disp(['Fitted parameter sigma_1: ', num2str(sigma_1)]);
    disp(['Fitted parameter sigma_2: ', num2str(sigma_2)]);
    % disp(['Fitted parameter mu_2: ', num2str(mu_2)]);

    % Generate values for the fitted distribution curve
    % x_values = linspace(min(data), max(data), );
    x_values = bin_centers;
    % x_values = linspace(min(data), 100, 200);
    fitted_values = feval(fitResult, x_values);
    % Calculate expected frequencies for each bin
    expected_counts = fitted_values * sum(counts);

% Calculate the chi-square statistic
% chi2_stat = sum((counts - expected_counts) .^ 2 ./ expected_counts);
chi2_stat = sum((counts - fitted_values) .^ 2 ./ expected_counts);

% Compute degrees of freedom
num_parameters = 6; % [R1, R2, Mu1, sigma1, sigma2]
df = num_bins - num_parameters - 1;

% Determine the p-value
p_value = 1 - chi2cdf(chi2_stat, df);

% Display the results
disp(['Chi2 Statistic: ', num2str(chi2_stat)]);
disp(['Degrees of Freedom: ', num2str(df)]);
disp(['p-value: ', num2str(p_value)]);


    % Calculating ratios
    F_1 = R_1 * exp(-((x_values-mu_1) ./sigma_1).^2);
    F_2 = R_2 * exp(-((x_values-mu_2) ./sigma_2).^2);

    disp(['Proportion of type I cells: ', num2str(sum(F_1))]);
    disp(['Proportion of type II cells: ', num2str(sum(F_2))]);

    figure,
    bar(bin_centers, counts, 'hist');
    title([titleName 'Histogram with Custom Fit']);
    xlabel('Data Value');
    ylabel('Frequency (Probability Density)');
    grid on;
    hold on;
    plot(x_values, F_1, 'g', 'LineWidth', 2);
    plot(x_values, F_2, 'k', 'LineWidth', 2);
    plot(x_values, fitted_values, 'r', 'LineWidth', 2);
    legend('Histogram','F1','F2', 'Fitted Function');
    hold off;
%% Manual fit finding the starting point
% R1 = 0.07;
% R2 = 0.018;
% mu1 = -2.35;
% mu2 = -0.3;
% sig1 = 0.72;
% sig2 = 1.6;
% 
% % x_values = linspace(min(data), max(data), 200);
% % x_values = linspace(min(data), 100, 200);
% x_values = bin_centers;
% F1 =  R1 * exp(-((x_values-mu1) ./sig1).^2);
% F2 =  R2 * exp(-((x_values-mu2) ./sig2).^2);
% % F2 = R2 * (x_values .* exp(-x_values.^2 / (2 * sig2^2)) / sig2^2);
% fitF = F1 + F2;
% figure;
% bar(bin_centers, counts, 'hist');
% titleName = fileName;
% titleName(5) = ' ';
% titleName(9) = ' ';
% titleName = [titleName ' '];
% title([titleName 'Histogram with Custom Fit']);
% xlabel('Data Value');
% ylabel('Frequency (Probability Density)');
% grid on;
% hold on;
% plot(x_values, F1, 'g', 'LineWidth', 2);
% plot(x_values, F2, 'k', 'LineWidth', 2);
% plot(x_values, fitF, 'r', 'LineWidth', 2);
% hold off

%% Trajectory Curvature - correlations

% idx = find(~isnan(ALH_list));
% idx = find(traj_length_list >= 50);
% idx = CURV_valid(1,:);
idx = intersect(find(~isnan(ALH_list)),CURV_valid(1,:));

% log_CURV = log10(CURV_abs_list);
log_CURV = log10(abs(CURV_list));

% Combine all variables into a matrix
corr_data = [VCL_list(idx)', VAP_list(idx)', VSL_list(idx)', STR_list(idx)', LIN_list(idx)', WOB_list(idx)', ALH_list(idx)', BCF_list(idx)', MAD_list(idx)', traj_length_list(idx)', log_CURV(idx)'];

% Calculate the correlation matrix
R = corrcoef(corr_data);

% Display the correlation matrix
disp('Correlation matrix:');
disp(R);

% Variable names
var_names = {'VCL', 'VAP', 'VSL', 'STR', 'LIN', 'WOB', 'ALH', 'BCF', 'MAD', 'traj length', 'abs CURV'};

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
title('Correlation Matrix Heatmap');
xlabel('Variables');
ylabel('Variables');
colorbar;
%% Normalization of variables

var_list = {'VCL', 'VAP', 'VSL', 'STR', 'LIN', 'WOB', 'ALH', 'BCF', 'MAD', 'traj_l', 'curv'};
clear i normData
for i = 1:numel(var_list)
    data_min = min(corr_data(:,i));
    data_max = max(corr_data(:,i));
    % var_name = norm_list(i);
    normData.(var_list{i}) = (corr_data(:,i) - data_min) ./ (data_max - data_min);
end
%% k-means method for clustering
% % Sample data points
% % Combine the data into a single matrix
% clear data_cluster C
% data_cluster = [normData.curv,normData.VCL];
% 
% % Perform k-means clustering to divide the data into 2 clusters
% k = 2;
% [c_idx, C] = kmeans(data_cluster, k);
% 
% % Calculate the number of points in each cluster
% num_points_cluster1 = sum(c_idx == 1);
% num_points_cluster2 = sum(c_idx == 2);
% 
% % Display the number of points in each cluster
% disp(['Number of points in Cluster 1: ', num2str(num_points_cluster1)]);
% disp(['Number of points in Cluster 2: ', num2str(num_points_cluster2)]);
% 
% % Visualize the clusters
% figure;
% hold on;
% scatter(data_cluster(c_idx == 1, 1), data_cluster(c_idx == 1, 2), 'r', 'filled');
% scatter(data_cluster(c_idx == 2, 1), data_cluster(c_idx == 2, 2), 'b', 'filled');
% plot(C(:,1), C(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3); % Plot the cluster centroids
% xlabel('x');
% ylabel('y');
% legend('Cluster 1', 'Cluster 2', 'Centroids');
% title('2D Scatter Plot with Clustered Data Points');
% hold off;

%% linkage method for clustering
% data_cluster = corr_data;
% data_cluster = [log_CURV',VCL_list'];
% data_cluster = [log_CURV(idx)',VCL_list(idx)'];
% log_CURV = log10(CURV_abs_list);
% log_CURV = log10(abs(CURV_list));

clear data_cluster C

% data_cluster = [log10(normData.curv),log10(normData.VCL)];
data_cluster = [normData.curv,normData.VCL];
% data_cluster = [normData.curv,normData.WOB];

% Perform hierarchical clustering

% Z = linkage(data_cluster, 'average');
Z = linkage(data_cluster, 'ward');
% Z = linkage(corr_data(:,1:2), 'average'); % ??? Why 'average' ???

figure,dendrogram(Z)

% Determine clusters from dendrogram
c_idx = cluster(Z, 'maxclust', 2);
% c_idx = cluster(Z,'cutoff',2,'Depth',4);

% Calculate the number of points in each cluster
num_points_cluster1 = sum(c_idx == 1);
num_points_cluster2 = sum(c_idx == 2);

% Display the number of points in each cluster
disp(['Number of points in Cluster 1: ', num2str(num_points_cluster1)]);
disp(['Number of points in Cluster 2: ', num2str(num_points_cluster2)]);

% Visualize the clusters
figure;
hold on;
gscatter(data_cluster(:,1), data_cluster(:,2), c_idx);
xlabel('x');
ylabel('y');
legend('Cluster 1', 'Cluster 2');
title('2D Scatter Plot with Hierarchical Clustering');
grid on
axis equal
hold off;

