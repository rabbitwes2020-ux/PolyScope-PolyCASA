clc; clear; close all;

%% 1. 文件路径与基础参数设置
fiji_csv_path  = 'FIJI_manual.csv'; % 替换为你实际的 FIJI CSV 路径
casa_csv_path  = 'PolyCASA_tracks_0823_vid_1.csv'; % 替换为 PolyCASA CSV 路径

match_threshold_px = 20; % 匹配半径阈值 (像素)，在 5 像素范围内的视为检测成功
mu = 0.42; % 空间分辨率 (um per pixel)

%% 2. 读取 CSV 数据
% 读取 FIJI (Id, X, Y, Slice)
opts_fiji = detectImportOptions(fiji_csv_path);
fiji_data = readtable(fiji_csv_path, opts_fiji);

% 读取 PolyCASA (track_id, frame, x_pixel, y_pixel, x_um, y_um, time_sec)
opts_casa = detectImportOptions(casa_csv_path);
casa_data = readtable(casa_csv_path, opts_casa);

%% 3. 数据预处理 (确保列名对齐)
fiji_frames = fiji_data.Slice;
fiji_x      = fiji_data.X;
fiji_y      = fiji_data.Y;

casa_frames = casa_data.frame;
casa_x      = casa_data.x_pixel;
casa_y      = casa_data.y_pixel;

unique_frames = unique(fiji_frames);

%% 4. 逐帧评估与匹配 (Hungarian / Nearest-Neighbor)
total_gt_count  = 0; % 人工标注总数
total_det_count = 0; % 算法检测总数
tp_count        = 0; % 匹配成功的 True Positives
all_pos_errors_px = []; % 存储所有匹配成功的像素偏差

for k = 1:length(unique_frames)
    f = unique_frames(k);
    
    % 提取当前帧的 GT 点与 CASA 检测点
    gt_idx   = (fiji_frames == f);
    casa_idx = (casa_frames == f);
    
    gt_pts   = [fiji_x(gt_idx), fiji_y(gt_idx)];
    casa_pts = [casa_x(casa_idx), casa_y(casa_idx)];
    
    n_gt  = size(gt_pts, 1);
    n_det = size(casa_pts, 1);
    
    total_gt_count  = total_gt_count + n_gt;
    total_det_count = total_det_count + n_det;
    
    if n_gt > 0 && n_det > 0
        % 计算当前帧中 GT 与 Detection 之间的距离矩阵
        dist_matrix = zeros(n_gt, n_det);
        for i = 1:n_gt
            for j = 1:n_det
                dist_matrix(i, j) = norm(gt_pts(i, :) - casa_pts(j, :));
            end
        end
        
        % 贪心最近邻匹配
        gt_matched  = false(n_gt, 1);
        det_matched = false(n_det, 1);
        
        while true
            [min_val, min_idx] = min(dist_matrix(:));
            if isempty(min_val) || min_val > match_threshold_px
                break; % 超过容忍半径，停止匹配
            end
            
            [r, c] = ind2sub(size(dist_matrix), min_idx);
            
            % 记录一次成功的 TP 匹配
            tp_count = tp_count + 1;
            all_pos_errors_px = [all_pos_errors_px; min_val];
            
            gt_matched(r)  = true;
            det_matched(c) = true;
            
            % 将已匹配的行和列设为无穷大
            dist_matrix(r, :) = inf;
            dist_matrix(:, c) = inf;
        end
    end
end

%% 5. 计算指标 (Precision, Recall, Mean Errors)
precision = (tp_count / total_det_count) * 100;
recall    = (tp_count / total_gt_count) * 100;
mean_err_px = mean(all_pos_errors_px);
std_err_px  = std(all_pos_errors_px);
mean_err_um = mean_err_px * mu;
std_err_um  = std_err_px * mu;

%% 6. 打印输出结果 (直接用于论文正文表格)
fprintf('\n================== Ground Truth Evaluation Results ==================\n');
fprintf('Evaluated Frames           : %d frames\n', length(unique_frames));
fprintf('Total Manual GT Points     : %d\n', total_gt_count);
fprintf('Total PolyCASA Detected    : %d\n', total_det_count);
fprintf('Detect Threshold Radius    : %d pixels\n', match_threshold_px);
fprintf('True Positives (TP)        : %d\n', tp_count);
fprintf('--------------------------------------------------------------------\n');
fprintf('Precision                  : %.2f %%\n', precision);
fprintf('Recall                     : %.2f %%\n', recall);
fprintf('Mean Euclidean Error (px)  : %.2f +/- %.2f pixels\n', mean_err_px, std_err_px);
fprintf('Mean Euclidean Error (um)  : %.2f +/- %.2f um\n', mean_err_um, std_err_um);
fprintf('====================================================================\n');