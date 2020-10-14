clc
clf
robot = xArm7;
%workBench = Workbench(robot);
fkineJoints = robot.getFkineJoints(robot.model.getpos());
currentJoints = robot.model.getpos();
hitboxList = getHitboxList(robot, currentJoints);
for i = 1:8
    hitboxList{i, 1}.plotEdges()
end