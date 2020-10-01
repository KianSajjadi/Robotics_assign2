clc
clf
robot = xArm7;
q = [0, 0, 0, 0, 0, 0, pi/2];
blockOffset = 0.05;
robot.model.animate(q);
testBlock = Prop(transl(0.4, 0, 0.2 + blockOffset), 'testBlock');
currentTransform = robot.model.fkine(robot.model.getpos());
numSteps = 50;
goalTransform = currentTransform * transl(0, 0, -0.3);
qMatrix = robot.getCartesianQMatrix(currentTransform, goalTransform, numSteps);
robot.animateRobot(qMatrix);


currentTransform = goalTransform;
goalTransform = testBlock.positionTransform * trotx(pi) * trotz(pi/2);
jointQMatrix = robot.getJointQMatrix(robot.model.getpos(), goalTransform, numSteps);
robot.animateRobot(jointQMatrix);
robot.heldProp = testBlock;
robot.isHolding = 1;

currentTransform = goalTransform;
goalTransform = transl(0, 0, 0.2) * currentTransform;
qMatrix = robot.getCartesianQMatrix(currentTransform, goalTransform, numSteps);
    for i = 1:numSteps
        drawnow();
            animate(robot.model, qMatrix(i, :));
            newPos = robot.model.fkine(qMatrix(i, :)) * trotx(pi);
            testBlock.updatePosition(newPos);
    end