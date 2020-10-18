clc
clf
robot = xArm7;
table = Prop(transl(0, 0, 0), "table");
table.initProp;
%workbench = Workbench(robot);
%fkineJoints = robot.getFkineJoints(robot.model.getpos());
%currentJoints = robot.model.getpos();
%hitboxList = workbench.robotHitboxList;
