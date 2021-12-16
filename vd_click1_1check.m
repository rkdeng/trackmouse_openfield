% check clicked locations

% load mat file from vd_click1.m

% define video file locaiton
vidname = ['C:\Users\ASUS\Desktop\db_11302021\' click.vid(end-22:end-4) '.mp4'];

% load click variable
vidObj = [];
frame_tmp = [];
mask3 = [];
xf1 = [];
yf1 = [];
xf2 = [];
yf2 = [];

vidObj = VideoReader(vidname);

for u = 1:length(click.frames)  
    frame_tmp = read(vidObj,[click.frames(u)]);
    
    % select roi
    figure(1),clf
    imshow(frame_tmp)
    title(click.vid(end-22:end-4))
    
    mask3(:,:,1) = click.maskbox(:,:,u);
    mask3(:,:,2) = click.maskbox(:,:,u);
    mask3(:,:,3) = click.maskbox(:,:,u);
    bc = frame_tmp;
    bc(mask3 == 0) = 255;
    figure(2),clf,imshow(bc)
    title(sprintf('Frame %d of %d',u,length(click.frames)))
    
    figure(3),clf
    imshow(frame_tmp)
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
    
    pause
end



