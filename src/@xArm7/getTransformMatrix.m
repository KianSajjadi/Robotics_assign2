%% getTransformMatrix(currentTransform, goalTransform, numSteps)
%Args:
%   currentTransform: the current 4x4 transform matrix of the end effector
%   goalTransform: the goal 4x4 transform matrix of the end effector
%   numSteps: the number of steps between movements
%Output:
%   transformMatrix: a matrix of transforms between two points
%Description:
%   This function takes the currentTransform and goalTransform of the end
%   effector and uses the trapezoidal velocity profile to plot a number N of
%   waypoints between the current and goal transform. N is equal to
%   numSteps
function transformMatrix = getTransformMatrix(currentTransform, goalTransform, numSteps)
    s = lspb(0, 1, numSteps);
    for i = 1:numSteps
        transformMatrix = currentTransform + s(i) * (goalTransform - currentTransform);
    end
end