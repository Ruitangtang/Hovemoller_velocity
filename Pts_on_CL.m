function [A]=Pts_on_CL(A_CL,distho_s)
% A_CL address of centerlines (shape file, polyline)
% dist_s the distance from the start point (glacier snot)
AA=shaperead(A_CL);
X_1 = AA.X(1:end-1);
Y_1 = AA.Y(1:end-1);
x=fliplr(X_1);
y=fliplr(Y_1);


% Number_of_divisions = 5;
dist_from_start = cumsum( [0, sqrt((x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2)] );
%      a = dist_from_start(end)/Number_of_divisions;
% The seperate distance
marker_dist = dist_s;
%
marker_locs = marker_dist : marker_dist : dist_from_start(end);   %replace with specific distances if desired
marker_indices = interp1( dist_from_start, 1 : length(dist_from_start), marker_locs);
marker_base_pos = floor(marker_indices);
weight_second = marker_indices - marker_base_pos;
mask = marker_base_pos < length(dist_from_start);
final_x = x(end); final_y = y(end);
final_marker = any(~mask) & (x(1) ~= final_x | y(1) ~= final_y);
marker_x = [x(1), x(marker_base_pos(mask)) .* (1-weight_second(mask)) + x(marker_base_pos(mask)+1) .* weight_second(mask), final_x(final_marker)];
marker_y = [y(1), y(marker_base_pos(mask)) .* (1-weight_second(mask)) + y(marker_base_pos(mask)+1) .* weight_second(mask), final_y(final_marker)];
Marker_locs=[0,marker_locs];
% output the corrdinate system information of points on centerlines
A=[marker_x', marker_y',Marker_locs'];
%%%%%%%%%% the plot of original centerline and new marker point line 
% % plot(x, y, marker_x, marker_y, 'r+');


% % figure
% the plot of the new marker line along the centerline, x-axis is the
% distance from the snot
% % plot (Marker_locs, marker_y)


end




