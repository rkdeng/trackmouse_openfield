% script to analyze video, get mouse location for each frame
% 8/21/2021

% load mat file from vd_click1.m

% change video file path
vid_path = ['C:\Users\ASUS\Desktop\db_11302021\' click.vid(end-22:end-4) '.mp4'];

% May need to optimize rgblim and medfilt_size.
% BIG ASSUMPTIONS IN HERE!!! Right now the code only detects
% dark pixels in the image as the mouse. Median filter is used to filter
% out detected dark pixels that are not on the mouse. Because they are
% usually small. Increase rgblim if the color of the mouse is bright. But
% that will increase the false positive dark spots from the background. One
% could try to increase the size of the median filter (medfilt_size) to
% compensate for that. But this should be veryfied.

detectpara.rgblim = [25 25 25]; % black color threshold
detectpara.medfilt_size = [10 10]; % median filter size
detectpara.mousexy_c = [];
detectpara.mousexy = [];
detectpara.crop = [];
detectpara.xy_detect = {};

% load click data
% lname = [vid_path(end-22:end-4) '.mat'];
% load(lname)

vidObj = VideoReader(vid_path);

% set how to crop the video
exp1 = read(vidObj,[click.frames(1)]);
figure(1),clf
imshow(exp1)
[xc, yc] = getpts;

sel1 = xc <= 0;
xc(sel1) = 1;
sel1 = xc > vidObj.Width;
xc(sel1) = vidObj.Width;

sel1 = yc <= 0;
yc(sel1) = 1;
sel1 = yc > vidObj.Height;
yc(sel1) = vidObj.Height;

detectpara.crop = round([xc yc]);

% prep variables for parfor
mousexy_c = zeros(length(click.frames(1):click.frames(end)),2);
medfilt_size = detectpara.medfilt_size;
rgblim_r = detectpara.rgblim(1);
rgblim_g = detectpara.rgblim(2);
rgblim_b = detectpara.rgblim(3);

crop_r1 = int16(min(yc));
crop_r2 = int16(max(yc));
crop_c1 = int16(min(xc));
crop_c2 = int16(max(xc));

% % this is how to crop each frame
% fig_crop = exp1(crop_r1:crop_r2,crop_c1:crop_c2,:);
% figure,imshow(fig_crop)

datestr(now, 'dd/mm/yy-HH:MM')
tic

checkpoint = 1:(length(click.frames(1):click.frames(end))-1)/10:length(click.frames(1):click.frames(end));
n_tic = 1;

for u = 1:length(click.frames(1):click.frames(end))
% for u = 1:40:length(click.frames(1):click.frames(end))    

% for u = 1:500
% parfor u = 1:500
% for u = randsample(1:length(click.frames(1):click.frames(end)),50)
% parfor u = 1:length(click.frames(1):click.frames(end))
    
    frame_now = click.frames(1) + u - 1;
    
    % read mask
    frame_section = frame_now - click.frames;
    maskbox_inx = sum(frame_section>=0);
    maskbox = click.maskbox(:,:,maskbox_inx);
    maskbox_crop = maskbox(crop_r1:crop_r2,crop_c1:crop_c2);
    
    % read frame
    frame_tmp = read(vidObj,[frame_now]);
    frame_crop = frame_tmp(crop_r1:crop_r2,crop_c1:crop_c2,:);
    
%     mask_mouse = (frame_tmp(:,:,1) < rgblim_r)&(frame_tmp(:,:,2)...
%         < rgblim_g)&(frame_tmp(:,:,3) < rgblim_b);
%     mask_f = medfilt2(double(mask_mouse),medfilt_size);
    
    mask_mouse = (frame_crop(:,:,1) < rgblim_r)&(frame_crop(:,:,2)...
        < rgblim_g)&(frame_crop(:,:,3) < rgblim_b);
    mask_f = medfilt2(double(mask_mouse),medfilt_size);

    % crop the box to analyze
    mask_crop = mask_f;
    mask_crop(maskbox_crop == 0) = 0;
    
    % get mouse position
    [r, c] = find(mask_crop > 0);
    
    p_x = mean(c);
    p_y = mean(r);
    
    mousexy_c(u,:) = [p_x, p_y];
    detectpara.xy_detect{1,u} = [c r];
    
    
    
    % check
%     figure(1),clf
%     imshow(frame_crop)
%     hold on
%     plot(p_x,p_y,'c+')
%     plot(detectpara.xy_detect{1,u}(:,1),detectpara.xy_detect{1,u}(:,2),'r^')
%     hold off
%     title(num2str(u))
%     
%     figure(2),clf
%     imshow(mask_crop)
%     hold on
%     plot(p_x,p_y,'c+')
%     %plot(detectpara.xy_detect{1,u}(:,1),detectpara.xy_detect{1,u}(:,2),'r^')
%     hold off
    
    if isnan(p_x)  % if no dark pixel is detected, need to trouble shot
        % check
        figure(1),clf
        imshow(frame_crop)
        hold on
        plot(p_x,p_y,'c+')
        plot(detectpara.xy_detect{1,u}(:,1),detectpara.xy_detect{1,u}(:,2),'r^')
        hold off
        title(num2str(u))
        
        figure(2),clf
        imshow(mask_crop)
        hold on
        plot(p_x,p_y,'c+')
        %plot(detectpara.xy_detect{1,u}(:,1),detectpara.xy_detect{1,u}(:,2),'r^')
        hold off
        
        
        a = 1;
        
%         mask_mouse = (frame_crop(:,:,1) < rgblim_r)&(frame_crop(:,:,2)...
%             < rgblim_g)&(frame_crop(:,:,3) < rgblim_b);
%         figure,imshow(mask_mouse)
%         mask_f = medfilt2(double(mask_mouse),medfilt_size);
%         figure,imshow(mask_f)
        
         pause
    end
    

    if u > checkpoint((n_tic+1))
        fprintf('.')
        n_tic = n_tic + 1;
    elseif u == checkpoint(end)
        fprintf('.')
    end
    
    
end
toc

detectpara.mousexy_c = mousexy_c;
% translate mousexy to uncropped image
detectpara.mousexy = [mousexy_c(:,1)+double(crop_c1-1) mousexy_c(:,2)+double(crop_r1-1)];


% visualize the path
figure,imshow(exp1)
hold on
plot(detectpara.mousexy(:,1),detectpara.mousexy(:,2),'-')
% plot(detectpara.mousexy(1:1,1),detectpara.mousexy(1:1,2),'+r')
hold off

% save 
sname = [vid_path(end-22:end-4) '_para'];
save([sname '.mat'],'detectpara')

% plot trace over time
% figure,imshow(exp1)
% hold on
% for uu = 1:size(detectpara.mousexy_c,1)
%     plot(detectpara.mousexy(uu,1),detectpara.mousexy(uu,2),'.')
%     pause(0.01)
% end
% hold off




