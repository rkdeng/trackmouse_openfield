% function to calculate coordinates for the center area
function [x_1, y_1] = inner_square(xi,yi)

x_1 = [(4*xi(1)+xi(3))/5; (4*xi(2)+xi(4))/5;  (xi(1)+4*xi(3))/5; (xi(2)+4*xi(4))/5;];
y_1 = [(4*yi(1)+yi(3))/5; (4*yi(2)+yi(4))/5;  (yi(1)+4*yi(3))/5; (yi(2)+4*yi(4))/5;];



