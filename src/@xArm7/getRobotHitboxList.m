function robotHitboxList = getRobotHitboxList(robot)
    %% Robot hitboxes
    initialJoints = robot.model.getpos();
    fkineJoints = robot.getFkineJoints(initialJoints);
    %Create base hitboxes for each joint: H, W, L, initTransform
        %joint 0
    displacement1 = [0, 0, 0]';
    hitboxList{1, 1} = Hitbox(0.150, 0.095, 0.095, displacement1, fkineJoints{1, 1});
        %joint 1
    displacement2 = [0, 0, -0.11]';
    hitboxList{2, 1} = Hitbox(0.160, 0.095, 0.125, displacement2, fkineJoints{2, 1});
        %joint 2
    displacement3 = [0, 0.04, -0.05]';
    hitboxList{3, 1} = Hitbox(0.240, 0.095, 0.160, displacement3, fkineJoints{3, 1});
        %joint 3
    displacement4 = [-0.02, 0, -0.1]';
    hitboxList{4, 1} = Hitbox(0.135, 0.13, 0.135, displacement4, fkineJoints{4, 1});
        %joint 4
    displacement5 = [-0.02, -0.03, -0.17]';
    hitboxList{5, 1} = Hitbox(0.215, 0.150, 0.140, displacement5, fkineJoints{5, 1});
        %joint 5
    displacement6 = [0, -0.02, -0.04]';
    hitboxList{6, 1} = Hitbox(0.210, 0.095, 0.130, displacement6, fkineJoints{6, 1});
        %joint 6
    displacement7 = [0.115, 0, -0.07]';
    hitboxList{7, 1} = Hitbox(0.095, 0.155, 0.080, displacement7, fkineJoints{7, 1});
        %joint 7
    displacement8 = [0.15, 0, 0]';
    hitboxList{8, 1} = Hitbox(0.165, 0.175, 0.085, displacement8, fkineJoints{8, 1});
    robotNumHitboxes = 8;
end