classdef Workbench < handle
    %% Properties
    properties
        robot;
        renderData;
    end
    
    %% Methods
    methods
        %this function populates the pre calculated data for the robot in
        %form: preCalcData = {transform, cartesianOrJoint, isHolding, heldProp, renderProp,
        %                     newProp}
        function renderData = getRenderData(self)
            self.robot = xArm7;
            %create all props
            blockOffset = 0.05;
            testBlockTransform = transl(0.4, 0, 0.15 + blockOffset);
            testBlock1 = Prop(testBlockTransform, 'testBlock');
            testBlock2 = Prop(testBlockTransform, 'testBlock');
            testBlock1.initProp;
            preCalcData{1, :} = robot.model.fkine(robot.model.getpos()), nan, nan, nan, nan, nan};
            %First Step, move robot arm to near the block1
            step1Transform = transl(0.4, 0, 0.3);
            preCalcData{2, :} = {step1Transform, 'cartesian', nan, nan, nan, nan};
            %SecondStep move robot arm to block
            
            %process the pre calculated data
            renderData = processData(preCalcData);
        end
        
        function renderData = processData(preCalcData)
           numSteps = 50;
           sizeMtx = size(preCalcData);
           n = sizeMtx(1);
           renderData = cell(n, 5);
           for i = 2:n
              switch preCalcData(i, 2)
                  case 'cartesian'
                      currentTransform = preCalcData{i - 1, 1};
                      goalTransform = preCalcData{i, 1};
                      qMatrix = self.robot.getCartesianQMatrix(currentTransform, goalTransform, numSteps);
                      renderData{i - 1, :} = {qMatrix, preCalcData{i, 3:6}};
                  
                  case 'joint'
                      currentJoints = self.robot.model.getpos();
                      goalTransform = preCalcData{i, 1};
                      qMatrix = self.robot.getJointQMatrix(currentJoints, goalTransform, numSteps);
                      renderData{i - 1, :} = {qMatrix, preCalcData{i, 3:6}};
              end
           end
        end

    end
    
end