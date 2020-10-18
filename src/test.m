clc
clf
robot = xArm7;
workbench = Workbench(robot);
fkineJoints = robot.getFkineJoints(robot.model.getpos());
currentJoints = robot.model.getpos();
hitboxList = workbench.robotHitboxList;
