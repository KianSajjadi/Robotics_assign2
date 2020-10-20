%% animateScene(robot, renderData)
%Args: renderData is a cell array where each row contains a step and
%   columns are: {qMatrix, isHoldingBool, heldProp, renderPropBool, newProp} where:
%       qMatrix is the matrix of q values to animate the robot, 
%       isHoldingBool is a 1 or 0 value where 1 = true 0 = false,
%       heldProp is the prop object being held by the robot,
%       spawnProp is a 1 or 0 value where 1 = true 0 = false,
%       newProp is a prop object to be spawned
%Output: Null
%Description:
%   this function takes the renderData list and uses the informationW within
%   to animate the robot and props. 

function animateScene(~, robot, renderDataList)
    %q = [0, 0, 0, 0, 0, 0, pi/2];
    %robot.model.animate(q);
    renderDataSizeMatrix = size(renderDataList);
    renderDataSize = renderDataSizeMatrix(1);
    for i = 1 : renderDataSize
        animatePropAndRobot(robot, renderDataList(i, 1:6));
    end
    
end


function animatePropAndRobot(robot, renderData)
    linePoint1 = [0.1, 0.3, 0.5];
    linePoint2 = [0.4, -0.3, 0.5];
    hold on
    plottedArm = plot3([linePoint1(1, 1) linePoint2(1, 1)], [linePoint1(1, 2), linePoint2(1, 2)], [linePoint1(1, 3) linePoint2(1, 3)]);
    hold off
    [qMatrix, isHoldingBool, heldProp, renderPropBool, newProp, robotHitboxQMatrixPositionList] = renderData{1, :};
    qMatrixSizeMatrix = size(qMatrix);
    qMatrixSize = qMatrixSizeMatrix(1);
        for i = 1 : qMatrixSize
            drawnow();
            robotHitboxList = robotHitboxQMatrixPositionList(i, :);
            for iterator = 1 : 8
                try delete(robotEdgePlots{iterator});
                end
            end

            %robotEdgePlots = animateRobotHitboxes(robotHitboxList);
            currentJointValues = qMatrix(i, :);
            robot.model.animate(currentJointValues);
            if isHoldingBool == 1
                newPosition = robot.model.fkine(currentJointValues) * heldProp.endEffectorToPropTransform;
                heldProp.updatePosition(newPosition);
            end

            if renderPropBool == 1
                newProp.initProp;
            end
            
            display("step" + i)
            for j = 1 : 8
                hitbox = robotHitboxList{1, j};
                stopState = lineHitboxIntersection(hitbox, robot, linePoint1, linePoint2, currentJointValues);  
            end
    end
    
end

function robotEdgePlots = animateRobotHitboxes(robotHitboxList)
    for i = 1 : 8
        robotHitbox = robotHitboxList{1, i};
        robotEdgePlots{i} = robotHitbox.plotEdges();
    end

end