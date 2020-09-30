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