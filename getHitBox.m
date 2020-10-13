%% hitBox = getHitBox(firstPointTransform, secondPointTransform, width, 
%Arguments:
%   firstPointTransform: a 4x4 homogenous transform of the first point
%   secondPointTransform: a 4x4 homogenous transform of the second point
%   width:  the width of the box (x axis)
%   length: the length of the box (y axis)
%   xDisplacement: the x translation 
%   yDisplacement: the y translation
%   zDisplacement: the z displacement
%Output:
%   hitBox: a rectangular prism hitbox 
%Description:
%   Utilising that the height(z-axis length) of the hitbox is between the
%   first and second point transforms, the width is the x-axis length, and
%   the length is the y-axis length we can create a hitbox with a size that
%   can be a somewhat accurate approximation for the polygon we want to
%   use. We also have x y and z displacements so we can match the polygon's
%   position on robotic arms.

function hitBox = getHixBox(firstPointTransform, secondPointTransform, width, length, xDisplacement, yDisplacement, zDisplacement)
    height = norm(transl(firstPointTransform) - transl(secondPointTransform));
    rectangularPrism = 
end 