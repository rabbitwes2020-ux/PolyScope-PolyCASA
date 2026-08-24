% k = 4283;
% k=1969;
k = 2699;



% Sample trajectory (replace with your data)
% x = linspace(0, 20, 1000);
% y = sin(x);

% Parameters
window_size = 6;  % Size of the moving window
order = 2;  % Order of polynomial fit

% Calculate curvature
x = avg_trajs{k}(1:2:end-1);
y = avg_trajs{k}(2:2:end);
% x = traj_pos{k}(1:2:end-1);
% y = traj_pos{k}(2:2:end);

% Calculate curvature
curvature = zeros(size(x));
fitted_x= [];
fitted_y= [];
t = [1:numel(x)];

fit_v = [];

clear i
        for i = 1:numel(x)
            clear idx_start idx_end x_window y_window t_window p_x p_y xi_fit yi_fit
            clear dX_t dX_tt dY_t dY_tt fit_traj_input
            % Indices for the moving window
            idx_start = max(1, i - window_size/2);
            idx_end = min(numel(x), i + window_size/2);

            % Points in the window
            x_window = x(idx_start:idx_end);
            y_window = y(idx_start:idx_end);
            t_window = [idx_start:idx_end];

            % Fit a polynomial to the window
            p_x = polyfit(t_window, x_window, order);
            p_y = polyfit(t_window, y_window, order);
            % yi_fit = p(1).*(x(i))^2 + p(2).*(x(i)) + p(3);
            xi_fit = polyval(p_x,t(i));
            yi_fit = polyval(p_y,t(i));
            fitted_x = [fitted_x,xi_fit];
            fitted_y = [fitted_y,yi_fit];
            % Calculate curvature from the fitted polynomial
            % Order 2
            dX_t = 2*p_x(1).*t(i) + p_x(2);
            dX_tt = 2*p_x(1);
            dY_t = 2*p_y(1).*t(i) + p_y(2);
            dY_tt = 2*p_y(1);

            curvature(i) = (dX_t.*dY_tt - dY_t.*dX_tt)./(dX_t.^2+dY_t.^2).^(3/2);

            fit_traj_input = [fitted_x,fitted_y];

            fit_v = [fit_v,sqrt(dX_t.^2 + dY_t.^2)];
       
        end
curv_mean = mean(curvature)
curv_std = std(curvature)
% Plot curvature
figure,
hold on
plot(curvature./mu);

% plot(x, curvature_1);
xlabel('Position');
ylabel('Curvature');
title('Local Curvature of the Trajectory');

%% 

figure,

% plot(x,y,'.')
scatter(x*mu,y*mu,15, 'filled')
hold on
plot(fitted_x*mu,fitted_y*mu,'red')
% scatter(fitted_x(57),fitted_y(57),'r')
xlabel('X (um)', 'FontSize', 14); % Increase font size for the X-axis label
ylabel('Y (um)', 'FontSize', 14);
set(gca, 'FontSize', 15)
axis equal
hold off
