function area = func_triangle_area(point,endpoint1,endpoint2)
x1 = point(1);
y1 = point(2);
x2 = endpoint1(1);
y2 = endpoint1(2);
x3 = endpoint2(1);
y3 = endpoint2(2);
% Calculate the area of the triangle
area = 0.5 * abs(x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2));
end