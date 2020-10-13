clc
clf
robot = xArm7;
workBench = Workbench(robot);
fkineJoints = robot.getFkineJoints(robot.model.getpos());