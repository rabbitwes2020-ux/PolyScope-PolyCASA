clc
close all
clear all
load gong
%%
i = 1150;
str = string(i);
filename = ('0816_vid_1.avi');
% filename = ('test_2.mp4');
v_read = VideoReader(filename);
%nf = 300;
nf =  get(v_read,'numberOfFrames');
width = get(v_read,'width');
height = get(v_read,'height');
%np = width*height;
I = read(v_read,i);
% I_crop=I(round(1/3*height):round(2/3*height),round(1/3*width):round(2/3*width));
I_crop=I(1:400,1:400);
imshow(I_crop)
%%

% Create & open video writer
v_write_1 = VideoWriter('V1_crop.avi','Motion JPEG AVI');
% v_write = VideoWriter('BW1.avi','Grayscale AVI'); % Uncompressed grayscale video: size too large
v_write_1.Quality = 100;
v_write_1.FrameRate = get(v_read,'FrameRate');

open(v_write_1);

tic
% for i = 1:8
clear v_read nf j I_in I_out
% str = string(i);
% filename = ('V4-'+ str +'.mp4');
filename = '0816_vid_1.avi';
v_read = VideoReader(filename);
%nf = 300;
nf =  get(v_read,'numberOfFrames');
width = get(v_read,'width');
height = get(v_read,'height');
    for j = 1000:1150
%   for j = 1:nf
        I_in = read(v_read,j);
        I_out = I_in(1:400,1:400);
%         I_out = I_in(round(1/3*height):round(2/3*height),round(1/3*width):round(2/3*width));
        writeVideo(v_write_1, I_out);
        if mod(j,1000)==0
            j
            toc
        end
    end
% end
close(v_write_1);
sound(y,Fs)