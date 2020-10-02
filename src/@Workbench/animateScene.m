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
    for i = 1:renderDataSize
        animatePropAndRobot(robot, renderDataList(i, :));        
    end
    
end


function animatePropAndRobot(robot, renderData)
    [qMatrix, isHoldingBool, heldProp, renderPropBool, newProp] = renderData{1, :};
    qMatrixSizeMatrix = size(qMatrix);
    qMatrixSize = qMatrixSizeMatrix(1);
    for j = 1:qMatrixSize
        drawnow();
        currentJointValues = qMatrix(j, :);
        robot.model.animate(currentJointValues);
        if isHoldingBool == 1
            newPosition = robot.model.fkine(currentJointValues);
            heldProp.updatePosition(newPosition);
        end

        if renderPropBool == 1
            newProp.initProp;
        end
        
    end
    
end
