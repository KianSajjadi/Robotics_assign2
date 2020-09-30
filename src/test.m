clc
clf
robot = xArm7;
q = [0, 0, 0, 0, 0, 0, pi/2];
robot.model.animate(q);
currentTransform = robot.model.fkine(robot.model.getpos);
numSteps = 50;
goalTransform = currentTransform * transl(0, 0, -0.1);
cartesianQMatrix = robot.getCartesianQMatrix(currentTransform, goalTransform, numSteps);

robot.animateRobot(cartesianQMatrix);

currentTransform = goalTransform;
goalTransform = currentTransform * transl(0.2, 0.5, 0);
cartesianQMatrix = robot.getCartesianQMatrix(currentTransform, goalTransform, numSteps);
robot.animateRobot(cartesianQMatrix);


while 1 == 1
    currentTransform = goalTransform;
    goalTransform = currentTransform * trotz(pi);
    currentJoints = robot.model.getpos();
    goalJoints = robot.model.ikcon(goalTransform, currentJoints);
    poseQMatrix = robot.getPoseQMatrix(currentJoints, goalJoints, numSteps);
    robot.animateRobot(poseQMatrix);
end