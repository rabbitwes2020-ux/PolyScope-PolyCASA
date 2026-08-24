clc
close all
clear all
%% 
fileFolder = 'C:\Users\od19522\OneDrive - University of Bristol\PolyScope CASA\CASA space\CASA analysis\Videos & Results';
% fileName = '0823_vid_22';
fileName = '0823_vid_4';

readName = [fileName,'.avi'];
saveName = [fileFolder,'\','CASA_',fileName,'.mat'];

% v_read = VideoReader('0816_vid_5.avi');
v_read = VideoReader([fileFolder,'\',readName]);
%% Saving handle
rec = 0;
%% Parameters
frt = 40; %frames per second
mu = 0.42; %um per pixel

nf =  get(v_read,'numberOfFrames');
% nf = 5000

width = get(v_read,'width');
height = get(v_read,'height');
%np = width*height;
%% Select wanted reagion manually
clear I I_crop
I = read(v_read,800);
gray_frame = rgb2gray(I);
%adjust the size of crop
I_crop=gray_frame(1:height,1:width);
% I_crop=gray_frame(1:400,1:400);


[crop_height,crop_width] = size(I_crop);
np = crop_height*crop_width;
imshow(I_crop)

% plot on the image frame
crop_x = [1:crop_width];
crop_y = [1:crop_height];
imshow(I)

hold on
plot(ones(1,length(crop_y))*crop_x(1),crop_y,'--r','linewidth',3)
plot(ones(1,length(crop_y))*crop_x(end),crop_y,'--r','linewidth',3)
plot(crop_x,ones(1,length(crop_x))*(crop_y(1)+3),'--r','linewidth',3)
plot(crop_x,ones(1,length(crop_x))*crop_y(end),'--r','linewidth',3)
%% single frame test - convert to grayscale
I = read(v_read,800);
gray_frame = rgb2gray(I);
%adjust the size of crop
I_crop=gray_frame(1:height,1:width);

s =size(I_crop);

minIntensity = 50;
maxIntensity = 180;

% Perform contrast stretching
I_stretch = imadjust(I_crop, [minIntensity/255, maxIntensity/255], []);

% Apply Gaussian smoothing
I_crop1 = double(I_crop);
I_smooth1 = imgaussfilt(I_crop1, 50); % Adjust the standard deviation (2 in this case) for desired smoothing strength

I_crop2 = double(I_stretch);
I_smooth2 = imgaussfilt(I_crop2, 50);

[X,Y] = meshgrid(1:width,1:height);

%streched image
I_sub2 = uint8(abs(I_crop2-I_smooth2));
I_bw2=imbinarize(255-I_sub2,0.93);
% figure,
% imshow(I_sub2)
figure,
imshow(I_bw2)
% figure,
% imshow(I_crop2)
%%
bw = I_bw2;

disk_1 = strel('disk',2);
disk_2 = strel('disk',1);

bw1 = bwareaopen(imcomplement(imdilate(imerode(bw,disk_1),disk_2)), 50, 4);
% figure,imshow(bw1);
figure,imshow(bw1);

L =bwlabel(bw1);
s = regionprops(L, 'centroid','Orientation','Area');
c = [s.Centroid];
% o = [s.Orientation];  % Orientaion: angles in degrees
% a = [s.Area];
n_particles = max(L(:));
figure,
% imshow(L)
imshow(I_crop)
hold on
scatter(c(1:2:end),c(2:2:end),'.','red')

%% Looping - get all cell positions
show_on = 0;

clear positions orietations areas particles  i

positions = {}; %[pos_x,pos_y]
eccentricities = {}; 
areas = {};
particles = {}; % label of all particles in each frame [frame_no, particle_no]



minIntensity = 50;
maxIntensity = 180;
disk_1 = strel('disk',2);
disk_2 = strel('disk',1);
fps = v_read.FrameRate;     
for i = 1:nf
    clear I I_gray I_stretch I_gray2 I_smooth I_sub bw bw1 L s c e a
    v_read.CurrentTime = (i - 1) / fps;   % Set time to frame `i`
    I = readFrame(v_read); 
    I_gray = rgb2gray(I);
    I_stretch = imadjust(I_gray, [minIntensity/255, maxIntensity/255], []);

    I_gray2 = double(I_stretch);
    I_smooth = imgaussfilt(I_gray2, 50);

    I_sub = uint8(abs(I_gray2-I_smooth));
    bw=imbinarize(255-I_sub,0.93);
    bw1 = bwareaopen(imcomplement(imdilate(imerode(bw,disk_1),disk_2)), 50, 4);

    L =bwlabel(bw1);
    s = regionprops(L, 'centroid','Eccentricity','Area');
    c = [s.Centroid];
    e = [s.Eccentricity];  % Orientaion: angles in degrees
    a = [s.Area];

    positions{end+1} = c;
    eccentricities{end+1} = e;
    areas{end+1} = a;
    particles{end+1} = [1:length(a)];

    if show_on == 1
        imshow(I_gray)
        hold on
        scatter(c(1:2:end),c(2:2:end),'.','red')
        pause(0.1)
    end

    if mod(i,1000) == 0
        i
    end
end
disp('Positions Done') % Position in piexls
%% Loop - Link positional labels

show_on = 0;
cont_trajs = {};
end_trajs = {};

for k = 1:length(particles{1})
    cont_trajs{end+1} = [1,k];
end

clear i k j prev_frame_pos new_frame_pos delete_idx new_trajs_idx used_idx

for i = 2:nf   % Looping at frames
    prev_frame_pos = positions{i-1};
    new_frame_pos = positions{i};
    delete_idx = [];
    new_trajs_idx = [1:length(particles{i})]; % counting on new particles that can't link to previous frame
    used_idx = [];

    if numel(new_frame_pos) == 0
        for k = 1:length(cont_trajs)
            end_trajs{end+1} =  cont_trajs{k};
            delete_idx = [delete_idx,k];% delete the path from continuing list and add to ended list
        end
    else
        for k = 1:length(cont_trajs)   % Looping for existing trajectories
            clear idx_prev pos_prev pos_new dist idx
            idx_prev = cont_trajs{k}(end);

            pos_prev(1) = prev_frame_pos(2.*idx_prev-1);
            pos_prev(2) = prev_frame_pos(2.*idx_prev);
            pos_new(:,1) = new_frame_pos(1,1:2:end);
            pos_new(:,2) = new_frame_pos(1,2:2:end);

            dist = sqrt((pos_new(:,1)-pos_prev(1)).^2+(pos_new(:,2)-pos_prev(2)).^2);
            idx = find(dist==min(dist));

            if min(dist)<20 && ~ismember(idx, used_idx)
                cont_trajs{k} = [cont_trajs{k},i,idx];
                new_trajs_idx(find(new_trajs_idx==idx)) = [];
                used_idx = [used_idx,idx];
            else
                end_trajs{end+1} =  cont_trajs{k};
                delete_idx = [delete_idx,k];% delete the path from continuing list and add to ended list
            end
        end

        for j = 1:length(new_trajs_idx)
            cont_trajs{end+1} = [i,new_trajs_idx(j)];
            %         i,j
        end

    end

    if isempty(delete_idx) == 0
        cont_trajs(delete_idx) = [];
    end

    if mod(i,1000) == 0
        i
    end
end

end_trajs = [end_trajs, cont_trajs]; %end_trajs: frame_no + particle id
% cont_trajs = [];
disp('Labels Done')
%% Loop - Link position coordinates
traj_pos = {};
traj_frame_no = {};
traj_length_list = [];
clear k i pos_input pos_x pos_y frame_no_input
for k = 1:length(end_trajs) % k: Trajectory
    traj = end_trajs{k};
    pos_input = [];
    frame_no_input = [];
    for i = 1:length(traj)./2       % length(traj)./2: number of frames of the traj
        frame_no = traj(2*i-1);
        obj_no = traj(2*i);
        pos_x = positions{frame_no}(2*obj_no-1);
        pos_y = positions{frame_no}(2*obj_no);
        pos_input = [pos_input,pos_x,pos_y];
        frame_no_input = [frame_no_input,frame_no];
    end
    traj_pos{end+1} = pos_input;
    traj_frame_no{end+1} = frame_no_input;

    if mod(k,1000) == 0
        k
    end

end

n_traj = length(traj_pos)

clear k
for k = 1:n_traj
    traj_length_list = [traj_length_list,length(traj_pos{k})./2];
end

disp('Coords Done')                     % Coords in piexls
%% plot trajecotries
clear p_traj
figure,
imshow(I_stretch)
hold on
for k = 1:1000%n_traj
    p_traj = traj_pos{k};
    if  length(p_traj)./2 > 100 %limiting traj length
        scatter(p_traj(1:2:end-1),p_traj(2:2:end),'.')
    end
end
%% 3D plot trajectory
figure,
% imshow(I_stretch)
hold on
for k = 1:1000%n_traj
    p_traj = traj_pos{k};
    t_traj = traj_frame_no{k};
    if  length(p_traj)./2 > 100 %limiting traj length
        scatter3(p_traj(1:2:end-1),p_traj(2:2:end),t_traj(:),'.')
    end
end

set(gca, 'ZDir', 'reverse');
view(50,50)
grid on
axis equal
%% Morphology & Counting
clear j areas_all
areas_all = [];
eccs_all = [];
count = [];
for j = 1: nf
    areas_all = [areas_all,areas{j}];
    eccs_all = [eccs_all,eccentricities{j}];
    count = [count,numel(areas{j})];
end
areas_all = areas_all*mu.^2; % Area size in mu^2
area_mean = mean(areas_all);
ecc_mean = mean(eccs_all);
CASA_count = mean(count)./(crop_height*crop_width*mu^2); % unit: counts per um^2 - further transfer to counts per ml

%% VCL & VSL
VCL_all = {};
VCL_list = [];

VSL_list = [];

% dt = (1/frt)*ones(1,frame_no);
dt = 1./frt; % time step

clear k i pos_x pos_y VCL_input
for k = 1:n_traj % k: Trajectory
    VCL_input = [];
    if length(traj_pos{k}) < 100 % Filter path length: 50 steps
        VCL_input = [];
        VSL_input = NaN;
    else
        pos_x = traj_pos{k}(1:2:end-1);
        pos_y = traj_pos{k}(2:2:end);

        VCL_input = sqrt(diff(pos_x).^2 + diff(pos_y).^2) *mu ./ dt; % VCL in um/s
        VSL_input = sqrt((pos_x(end)-pos_x(1)).^2 + (pos_y(end)-pos_y(1)).^2) *mu ./ (((length(traj_pos{k})./2)-1).*dt); % VSL in um/s
    end

    VCL_all{end+1} = VCL_input;
    VCL_list = [VCL_list,mean(VCL_input)];
    VSL_list = [VSL_list,VSL_input];

    if mod(k,1000) == 0
        k
    end
end
disp('VCL VSL Done')
%% Averaged path
window_size = 20; % Must < min traj length; otherwise leaves no averaged path

avg_trajs = {};

for k = 1:n_traj % k: Trajectory
    clear pos_x pos_y num_windows avg_x avg_y input_length avg_input
    pos_x = traj_pos{k}(1:2:end-1);
    pos_y = traj_pos{k}(2:2:end);

    for i = 1:numel(pos_x)
        idx_start = max(1, i - window_size/2);
        idx_end = min(numel(pos_x), i + window_size/2);
   
        x_window = pos_x(idx_start:idx_end);
        y_window = pos_y(idx_start:idx_end);
        avg_x(i) = mean(x_window);
        avg_y(i) = mean(y_window);
    end

    input_length = numel(traj_pos{k});
    avg_input = zeros(1,input_length);
    avg_input(1:2:end-1) = avg_x;
    avg_input(2:2:end) = avg_y;

    avg_trajs{end+1} = avg_input; %AVG positions in pixel

    if mod(k,1000) == 0
        k
    end

end
disp('Avg Paths Done')
%% Plot averaged path
clear p_traj t_traj
figure,
hold on
for k = 1:length(avg_trajs)
    p_traj = avg_trajs{k};
       if  length(p_traj)./2 > 50 %limiting traj length
    scatter(p_traj(1:2:end-1).*mu,p_traj(2:2:end).*mu,'.');
       end
end
axis equal
%% 3D plot averaged path
clear p_traj t_traj
figure,
hold on
for k = 1:1000%n_traj
    p_traj = avg_trajs{k};
    t_traj = traj_frame_no{k};
    if  length(p_traj)./2 > 100 %limiting traj length
        scatter3(p_traj(1:2:end-1).*mu,p_traj(2:2:end).*mu,t_traj./frt,'.')
    end
end

set(gca, 'ZDir', 'reverse');
view(50,50)
grid on
% axis equal
%% VAP
VAP_all = {}; % VAP of all steps in all trajectories
VAP_list = []; % mean VAP for all trajectories
VSL_A_list = [];

% dt = (1/frt)*ones(1,frame_no);
dt = 1./frt;

clear k i pos_x pos_y VAP_input
for k = 1:length(avg_trajs) % k: Trajectory

    VAP_input = [];
    pos_x = avg_trajs{k}(1:2:end-1);
    pos_y = avg_trajs{k}(2:2:end);

    if length(pos_x)>5  % Control the length of averaged path
        VAP_input = sqrt(diff(pos_x).^2 + diff(pos_y).^2) *mu ./ dt;
        VSL_A_input = sqrt((pos_x(end)-pos_x(1)).^2 + (pos_y(end)-pos_y(1)).^2) *mu ./ (((length(avg_trajs{k})./2)-1).*dt);
    else
        VAP_input = [];
        VSL_A_input = NaN;
    end
    VAP_all{end+1} = VAP_input;
    VAP_list = [VAP_list,mean(VAP_input)];    
    VSL_A_list = [VSL_A_list,VSL_A_input];

    if mod(k,1000) == 0
        k
    end

end
disp('VAP Done') % VAP in um/s
%% Loop: ALH & BCF
ALH_all = {};
BC_count_all = [];
BCF_list = [];
ALH_list = [];

for k = 1:n_traj

    clear p_traj_x p_traj_y a_traj_x a_traj_y a_traj a_traj_dist

    % p_traj_x = traj_pos{k}(1+window_size:2:end-window_size-1);
    % p_traj_y = traj_pos{k}(2+window_size:2:end-window_size);
    p_traj_x = traj_pos{k}(1:2:end-1);
    p_traj_y = traj_pos{k}(2:2:end);

    a_traj_x = avg_trajs{k}(1:2:end-1);
    a_traj_y = avg_trajs{k}(2:2:end);

    % Find the trajectory point and the nearest pair of averaged points
    a_traj = [a_traj_x;a_traj_y];
    % Define the coordinates of the common point
    a_traj_dist = sqrt(diff(a_traj_x).^2+diff(a_traj_y).^2);
    a_point_nearest = [];
    ALH_input = [];


    if length(a_traj_x) < 20 % Thresholding length of path: 20
        ALH_input = [];
        % ALH_list = [ALH_list,NaN];
        BCF_input = NaN;
        BC_count = 0;

    else

        for j = 1:length(a_traj_x)

            clear point indices index p_a_dists endpoints endpoint0 endpoint1 endpoint2
            clear angle1 angle2 tri_area normal_dist

            point = [p_traj_x(j),p_traj_y(j)];

            indices = [j-5:1:j+5];
            indices = indices(indices > 0 & indices < length(a_traj_x)+1);
            endpoints = a_traj(:,indices(1:end));
            p_a_dists = sqrt((endpoints(1,:)-point(1)).^2+(endpoints(2,:)-point(2)).^2);

            index = min(indices(find(p_a_dists == min(p_a_dists)))); % In case ther are more than 1 min dist
            a_point_nearest(j) = [index]; 
            endpoint0 = [a_traj_x(index),a_traj_y(index)];


            if index == 1
                angle1 =  func_int_angle(endpoint0,point,[a_traj_x(index+1),a_traj_y(index+1)]);
                angle2 = 90.1;
                endpoint1 = [a_traj_x(index+1),a_traj_y(index+1)];
            elseif index == length(a_traj_x)
                angle1 = 90.1;
                angle2 = func_int_angle(endpoint0,point,[a_traj_x(index-1),a_traj_y(index-1)]);
                endpoint2 = [a_traj_x(index-1),a_traj_y(index-1)];
            else
                endpoint1 = [a_traj_x(index+1),a_traj_y(index+1)];
                endpoint2 = [a_traj_x(index-1),a_traj_y(index-1)];
                angle1 = func_int_angle(endpoint0,point,endpoint1);
                angle2 = func_int_angle(endpoint0,point,endpoint2);
            end

            if angle1 > 90 & angle2 > 90 % if both obtuse, use the nearest avg point for distance
                normal_dist = min(p_a_dists); %normal_dist: distance from point to curve
            elseif angle1 < angle2  % else, check smaller angle to find the nearst segment
                tri_area = func_triangle_area(endpoint0,point,endpoint1);
                normal_dist = 2.*tri_area./a_traj_dist(index).*mu;
            else
                tri_area = func_triangle_area(endpoint0,point,endpoint2);
                normal_dist = 2.*tri_area./a_traj_dist(index-1).*mu; % ALH in um
            end

            ALH_input = [ALH_input, normal_dist];

        end

        % BCF
        clear dir_vec dist_vec cross_product BC_count

        dir_vec = [diff(a_traj_x);diff(a_traj_y)];
        dist_vec = [p_traj_x - a_traj_x(a_point_nearest);p_traj_y - a_traj_y(a_point_nearest)];
        BC_count = 0;

        if isempty(dir_vec) ||  isempty(dist_vec)
            BCF_input = 0;
        else
            cross_product = [dir_vec(1,:).*dist_vec(2,1:end-1) - dir_vec(2,:).*dist_vec(1,1:end-1)];
            clear i
            for i = 1:length(cross_product) - 1
                if cross_product(i).*cross_product(i+1)<0
                    BC_count = BC_count+1;
                end
            end
            BCF_input = frt*BC_count./(length(cross_product) - 1); % BCF beats per second
        end

    end

    ALH_all{end+1} = ALH_input;
    ALH_list = [ALH_list,mean(ALH_input)];

    BC_count_all = [BC_count_all,BC_count];
    %BCF count per second
    BCF_list = [BCF_list,BCF_input];

    if mod(k,1000) == 0
        k
    end
end
disp('ALH BCF Done')
%% MAD
MAD_all = {};
MAD_list = [];

clear k
for k = 1:n_traj % k: Trajectory

    clear MAD_input pos_x pos_y dx dy angles

    MAD_input = [];
    if length(traj_pos{k}) < 20 % Filter path length: 10 steps
        MAD_input = [];
    else
        pos_x = traj_pos{k}(1:2:end-1);
        pos_y = traj_pos{k}(2:2:end);
        dx = diff(pos_x);
        dy = diff(pos_y);

        angles = atan2(dx, dy); % Calculate step movement angles in radians


        % Fix angle disontinuity
        % 1.Difference of 2pi is due to the presence of arctan: +/- 2pi to fix

        clear i
        for i = 2: length(angles)    % expand arctan values
            if angles(i)-angles(i-1) > 1*pi
                angles(i:end) = angles(i:end)-2*pi;

            end
            if angles(i)-angles(i-1) < -1*pi
                angles(i:end) = angles(i:end)+2*pi;
            end
        end

        MAD_input = diff(angles);

    end

    MAD_all{end+1} = MAD_input;
    MAD_list = [MAD_list,mean(MAD_input)];


    % figure,plot(MAD_input)
    % figure, scatter(pos_x(:),pos_y(:))

    if mod(k,1000) == 0
        k
    end

end

figure,
polarhistogram(MAD_list,'Normalization', 'probability', 'BinWidth', 0.05);
disp('MAD Done')
%% LIN, STR, WOB
LIN_list = VSL_list./VCL_list;
STR_list = VSL_A_list./VAP_list;   
WOB_list = VAP_list./VCL_list;
% How come LIN & STR > 1?
disp('LIN STR WOB Done')
%% Test - Plot results
% figure,plot(LIN_list)
% figure,plot(STR_list)
% figure,plot(WOB_list)
% figure,hist(LIN_list,50)
% figure,hist(STR_list,50)
% figure,hist(WOB_list,50)
% VAP_valid = VAP_list(~isnan(VAP_list));
% VCL_valid = VCL_list(~isnan(VCL_list));
%% Test- plot trajs

clear p_traj t_traj
figure,
hold on
for k =[1558,4304] % idx(1:500)
    if ~isempty(avg_trajs{k})
        p_traj_x = traj_pos{k}(1:2:end-1);
        p_traj_y = traj_pos{k}(2:2:end);
        a_traj_x = avg_trajs{k}(1:2:end-1);
        a_traj_y = avg_trajs{k}(2:2:end);
        scatter(p_traj_x,p_traj_y,'.')
        % scatter(p_traj_x(1),p_traj_y(1),'o')
        % scatter(a_traj_x(53),a_traj_y(53),'o')
        scatter(p_traj_x(end),p_traj_y(end),'o')
        scatter(a_traj_x,a_traj_y,'.')
    end
end

axis equal

%% Loop Curvature of path
fit_traj = {};
CURV_all = {};
CURV_list = [];
CURV_abs_list = [];

% Parameters
window_size = 6;  % Size of the moving window
order = 2;  % Order of polynomial fit

clear k x y 
for k = 1:n_traj;
    clear curvature fitted_y

    if length(avg_trajs{k})./2 < 3.*window_size
        curvature = [];
        fitted_y = [];
        CURV_all{end+1} = [];
        CURV_list = [CURV_list,NaN];
        CURV_abs_list = [CURV_abs_list,NaN];
    else
        x = avg_trajs{k}(1:2:end-1);
        y = avg_trajs{k}(2:2:end);

        % Calculate curvature
        curvature = zeros(size(x));
        fitted_x= [];
        fitted_y= [];
        t = [1:numel(x)];

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
       
        end
        fit_traj{end+1} = fit_traj_input;

        CURV_all{end+1} = curvature;

        CURV_list = [CURV_list,mean(curvature)];
        CURV_abs_list = [CURV_abs_list,mean(abs(curvature))];
    end

    if mod(k,1000) == 0
        k
    end
end
%% Curve in the unit of 1/pixel
%%
clear CURV non_nan_indices CURV_valid
CURV(1,:) = CURV_list;
CURV(2,:) = CURV_abs_list;
non_nan_indices = find(~isnan(CURV(1,:)));
CURV_valid(1,:) = non_nan_indices;
CURV_valid(2:3,:) = CURV(:,non_nan_indices);

disp('CURV Done')
%% Save variables
if rec == 1
    save(saveName, 'fileFolder','fileName','frt','mu', 'nf','traj_frame_no',...
        'traj_pos','avg_trajs','n_traj','traj_length_list',...
        'ecc_mean','eccs_all','area_mean','areas_all','CASA_count', ...
        'VCL_all','VCL_list','VAP_all','VAP_list','VSL_list','VSL_A_list', ...
        'ALH_all','ALH_list','BCF_list','MAD_all','MAD_list', ...
        'LIN_list', 'STR_list', 'WOB_list', ...
        'CURV_all', 'CURV_list','CURV_abs_list','CURV_valid');
end
disp('ALL DONE')
%%
clearvars('-except','saveName')
load(saveName)

