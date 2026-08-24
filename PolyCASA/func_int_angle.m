function angle = func_int_angle(point,endpoint1,endpoint2)
% input: 3 points
%1st point is the initial; 2,3 are 2 ends of vcectors. This function
%calculates the angle between the  2 vectors.

vector1 = endpoint1 - point;
vector2 = endpoint2 - point;

if norm(vector1) * norm(vector2) == 0
    angle = 0;
else

    % Calculate the angle between the vectors using the dot product
    cosine_angle = dot(vector1, vector2) / (norm(vector1) * norm(vector2));
    angle = acosd(cosine_angle); % Convert from radians to degrees
end
end