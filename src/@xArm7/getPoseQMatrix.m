%% poseQMatrix = getPoseQMatrix(currentJoints, goalJionts, numSteps)
%Args:
%   currentJoints: the current joints of the robot
%   goalJoints: the goal joints of the robot
%   numSteps: the number of steps between movements
%Output:
%   poseQMatrix: matrix of goalJoints MxN where M = numSteps and N = robot
%       joints
%Description:
%   This function takes, a robot's currentjoints, a robot's goal joints, and a
%   number of steps to calculate the qMatrix using the trapezoidal velocity
%   profile

function poseQMatrix = getPoseQMatrix(currentJoints, goalJoints, numSteps)
    s = lspb(0, 1, numSteps);
    poseQMatrix = nan(numSteps, 7);
    for i = 1 : numSteps
        poseQMatrix(i, :) = currentJoints + s(i) * (goalJoints - currentJoints);
    end 
    
end

