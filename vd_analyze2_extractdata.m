% script to get data, use base location from 1 frame (avg of the clicked frames)
% 8/20/2021


% load variables:
% click from vd_click1.m
% detectpara from vd_analyze1_mousexy.m

% output parameters are:
% dist_ctr, dist_out, dist_total for center area distance, outter area
% distance and total distance. The unit is pixel.
% bound_cross for the number of times crossing the boundary between the
% center and outter area.
% time_ctr, time_out for time spent in the center area and the outter area.
% The unit is second.

disp(click.vid)

%% distance

% calculate the frame to frame distance
dist_f2f = sqrt(diff(detectpara.mousexy(:,1)).^2 + diff(detectpara.mousexy(:,2)).^2);

% find locations inside or outside of the ctr area
ctr_x_avg = mean(squeeze(click.base_ctr(:,1,:)),2);  % avg locations
ctr_y_avg = mean(squeeze(click.base_ctr(:,2,:)),2);

xv = [ctr_x_avg; ctr_x_avg(1)];
yv = [ctr_y_avg; ctr_y_avg(1)];
xq = detectpara.mousexy(:,1);
yq = detectpara.mousexy(:,2);

in = inpolygon(xq,yq,xv,yv);

% check the points
figure(332),plot(xv,yv)
hold on
plot(xq(~in),yq(~in),'bo')
plot(xq(in),yq(in),'r+')
hold off

% separate ctr and outer distance
a = double(in);
in_m = [0 in' 0];
in_df = diff(in_m);
inx_start = find(in_df == 1);
inx_end = find(in_df == -1)-1;

% plot the trajectories of the mouse
figure(332), hold on
plot(xq(inx_start),yq(inx_start),'ko')
plot(xq(inx_end),yq(inx_end),'k^')
hold off


% exclude 1 point peaks
sel = (inx_end - inx_start) > 0;
inx_start_1 = inx_start(sel);
inx_end_1 = inx_end(sel);

sel_dist_in = zeros(length(dist_f2f),1);
for ru = 1:sum(sel)
    sel_dist_in(inx_start_1(ru):inx_end_1(ru)-1) = 1;
    
    % check
    figure(332), hold on
    plot(xq(inx_start_1(ru):inx_end_1(ru)),yq(inx_start_1(ru):inx_end_1(ru)))
    hold off
end
axis equal
sel_dist_in = logical(sel_dist_in);

dist_ctr = sum(dist_f2f(sel_dist_in));   % need to change unit
dist_out = sum(dist_f2f(~sel_dist_in));
dist_total = sum(dist_f2f);


%prototyping code

% e1 = [1 1 0 0 1 0 0 1 1 1 0 0 1 0 1];
% e1_m = [0 e1 0];
% e_df = diff(e1_m);
% inx_start = find(e_df == 1);
% inx_end = find(e_df == -1)-1;
% 
% % exclude 1 point peaks
% sel = (inx_end - inx_start) > 0;
% inx_start_1 = inx_start(sel);
% inx_end_1 = inx_end(sel);
% 
% sel_distance = zeros(length(e1),1);
% for ru = 1:sum(sel)
%     sel_distance(inx_start_1(ru):inx_end_1(ru)-1) = 1;
%     
% end

%% n crossing

% use InterX function

% base_ctr locations 
x1 = xv';
y1 = yv';

% mouse locations
x2 = xq';
y2 = yq';

P = InterX([x1;y1],[x2;y2]);

% check
base_x_avg = mean(squeeze(click.base(:,1,:)),2);  % avg locations
base_y_avg = mean(squeeze(click.base(:,2,:)),2);

bx = [base_x_avg; base_x_avg(1)];
by = [base_y_avg; base_y_avg(1)];

% plot the trajectories of the mouse
figure(33)
plot(bx',by',x1,y1,x2,y2)
%plot(bx',by',x1,y1,x2,y2,P(1,:),P(2,:),'ko')
saveas(gcf,[click.vid(end-22:end-4) '.fig'])
axis equal

% figure,plot(bx',by',x1,y1,x2,y2)
% hold on
% for uq = 1:size(P,2)
%    plot(P(1,uq),P(2,uq),'ko') 
%    uq
%    pause
% end
% hold off

% size(P,2) is the number of crossing
bound_cross = size(P,2);

%% time

% calculate the n of locations in or out of the box, use variable 'in' from
% the section above
time_ctr = sum(in)*(1/click.frame_rate);  % need to change unit later
time_out = sum(~in)*(1/click.frame_rate);

