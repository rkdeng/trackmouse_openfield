% Get the coordinates for cropping the openfield arena and for calculating 
% center area and surround area.


clear
% change video file path
vid_path = 'C:\Users\ASUS\Desktop\db_11302021\VID_20211130_150844.mp4';

click.start_time = 27;  % in seconds
click.end_time = 600+click.start_time;  % in seconds, assuming total video is 10 mins long

click.n_check = 4; % number of frames (at different time point) to check. I was afraid of image drifting.
% But it should not be a problem, if you pay attention to securing and stablizing the camera.

%%

% store clicked locations
click.vid = vid_path;
click.crop = [];
click.base = [];
click.base_ctr = [];
click.maskbox = [];

vidObj = VideoReader(vid_path);

% calculat frame number
frame_start = click.start_time*vidObj.FrameRate;
frame_end = click.end_time*vidObj.FrameRate;

click.frame_rate = vidObj.FrameRate;
click.frames = round(frame_start:(frame_end-frame_start)/(click.n_check-1):frame_end);

% click each frame

for u = 1:length(click.frames)
    disp(sprintf('Working on frame %d of %d',u,length(click.frames)))
    
    frame_tmp = read(vidObj,[click.frames(u)]);
    
    % select roi
    figure(1),clf
    imshow(frame_tmp)
    title('Select the box:')
    disp('Select the box in Figure 1...')
    
    roi_tmp = drawpolygon;
    click.maskbox(:,:,u) = createMask(roi_tmp);
    
    mask3(:,:,1) = click.maskbox(:,:,u);
    mask3(:,:,2) = click.maskbox(:,:,u);
    mask3(:,:,3) = click.maskbox(:,:,u);
    bc = frame_tmp;
    bc(mask3 == 0) = 255;
    figure(2),clf,imshow(bc)
    title('check the selection:')
    
    % click
    figure(3),clf
    imshow(frame_tmp)
    title('click 4 corners:')
    disp('click 4 corners in Figure 3...')
    [xi, yi] = getpts;
    click.base(:,:,u) = [xi yi];
    
    % calculate inner area
    [x_1, y_1] = inner_square(xi,yi);
    click.base_ctr(:,:,u) = [x_1, y_1];
    
    
    % check clicked points and the inner area
    figure(3)
    hold on
    xf1 = click.base(:,1,u);
    yf1 = click.base(:,2,u);
    
    xf2 = click.base_ctr(:,1,u);
    yf2 = click.base_ctr(:,2,u);
    
    text(xf1,yf1,{'A' 'B' 'C' 'D'})
    line([xf1; xf1(1)],[yf1; yf1(1)])

    text(xf2,yf2,{'A1' 'B1' 'C1' 'D1'})
    line([xf2; xf2(1)],[yf2; yf2(1)])

    hold off
    title('check the center box')
    disp('check the center box...')

end

disp('Finished.')

% save the data into mat file
sname = vid_path(end-22:end-4);
save([sname '.mat'],'click')




