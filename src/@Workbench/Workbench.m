classdef Workbench < handle
    %% Properties
    properties
        robot;
        renderDataList;
    end
    
    %% Methods
    methods
        function self = Workbench(robot)
            self.renderDataList = self.getRenderDataList(robot);
            self.animateScene(robot, self.renderDataList);
        end
        %this function populates the pre calculated data for the robot in
        %form: preCalcData = {transform, cartesianOrJoint, isHolding, heldProp, renderProp,
        %                     newProp}
        function renderDataList = getRenderDataList(self, robot)
            %create all props
            blockOffset = 0.05;
            testBlockTransform = transl(0.4, 0, 0.15 + blockOffset);
            testBlock1 = Prop(testBlockTransform, 'testBlock');
            testBlock2 = Prop(testBlockTransform, 'testBlock');
            testBlock1.initProp;
            initJointAngles = [0, 0, 0, 0, 0, 0, pi/2];
            robot.model.animate(initJointAngles);
            robot.model.getpos();
            initTransform = robot.model.fkine(robot.model.getpos());
            preCalcData(1, :) = {initTransform, nan, nan, nan, nan, nan};
            %First Step, move robot arm to near the block1
            step1Transform = initTransform * transl(0, 0, -0.3);
            preCalcData(2, :) = {step1Transform, 'cartesian', nan, nan, nan, nan};
            %SecondStep move robot arm to block
            step2Transform =  step1Transform * transl(0, 0.2, -0.3);
            preCalcData(3, :) = {step2Transform, 'cartesian', nan, nan, nan, nan};
            %process the pre calculated data
            renderDataList = self.processData(robot, preCalcData);
        end
        
        function renderDataList = processData(~, robot, preCalcData)
           numSteps = 50;
           sizeMtx = size(preCalcData);
           n = sizeMtx(1);
           renderDataList = cell(n - 1, 5);
           for i = 2:n
              switch preCalcData{i, 2}
                  case 'cartesian'
                      currentTransform = preCalcData{i - 1, 1};
                      goalTransform = preCalcData{i, 1};
                      qMatrix = robot.getCartesianQMatrix(currentTransform, goalTransform, numSteps);
                      renderDataList(i - 1, :) = {qMatrix, preCalcData{i, 3:6}};
                  
                  case 'joint'
                      currentJoints = robot.model.getpos();
                      goalTransform = preCalcData{i, 1};
                      qMatrix = robot.getJointQMatrix(currentJoints, goalTransform, numSteps);
                      renderDataList(i - 1, :) = {qMatrix, preCalcData{i, 3:6}};
              end
           end
        end

    end
    
end