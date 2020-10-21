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

function animateScene(workbench, robot, renderDataList)
    %q = [0, 0, 0, 0, 0, 0, pi/2];
    %robot.model.animate(q);
    renderDataSizeMatrix = size(renderDataList);
    renderDataSize = renderDataSizeMatrix(1);
    workbench.linePoint1 = [0.1, 0.3, 0.5];
    workbench.linePoint2 = [0.4, -0.3, 0.5];
    linePoint1 = workbench.linePoint1;
    linePoint2 = workbench.linePoint2;
    hold on
    %plottedArm = plot3([linePoint1(1, 1) linePoint2(1, 1)], [linePoint1(1, 2), linePoint2(1, 2)], [linePoint1(1, 3) linePoint2(1, 3)]);
    hold off
    workbench.step = 1;
    while workbench.runRobot == 1
        for i = workbench.step : renderDataSize
            if workbench.continueState == 1
                animatePropAndRobot(workbench, robot, renderDataList(i, 1:6));
                workbench.continueState = 1;
            end

            if workbench.stopState == 1
                workbench.step = i ;
                stepat = workbench.step;
                break;
            end

            if i > 8
                runRobot = 0;
            end
            workbench.qMatrixStoppedPosition = 1;
        end

    end

end


function animatePropAndRobot(workbench, robot, renderData)
    [qMatrix, isHoldingBool, heldProp, renderPropBool, newProp, robotHitboxQMatrixPositionList] = renderData{1, :};
    qMatrixSizeMatrix = size(qMatrix);
    qMatrixSize = qMatrixSizeMatrix(1);
    for i = workbench.qMatrixStoppedPosition : qMatrixSize
        currentJointValues = qMatrix(i, :);
        workbench.qMatrixStoppedPosition = i;
        if workbench.stopState == 1
            stopAnimation(robot, currentJointValues, isHoldingBool, heldProp);
            break;
        end
            
        drawnow();
        robotHitboxList = robotHitboxQMatrixPositionList(i, :);
        for iterator = 1 : 8
            try delete(robotEdgePlots{iterator});
            end
        end
        
        %robotEdgePlots = animateRobotHitboxes(robotHitboxList);
        robot.model.animate(currentJointValues);
        if isHoldingBool == 1
            newPosition = robot.model.fkine(currentJointValues) * heldProp.endEffectorToPropTransform;
            heldProp.updatePosition(newPosition);
        end

        if renderPropBool == 1
            newProp.initProp;
        end
        
        %display("step" + i)
        for j = 1 : 8
            %hitbox = robotHitboxList{1, j};
            %stopState = lineHitboxIntersection(hitbox, robot, linePoint1, linePoint2, currentJointValues);  
        end
    end
    
end

function robotEdgePlots = animateRobotHitboxes(robotHitboxList)
    for i = 1 : 8
        robotHitbox = robotHitboxList{1, i};
        robotEdgePlots{i} = robotHitbox.plotEdges();
    end

end