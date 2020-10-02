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
        %% getRenderDataList
        function renderDataList = getRenderDataList(self, robot)
            %% create all props and initialise project
            blockOffset = 0.05;
            testBlockTransform = transl(0.4, 0, 0.15 + blockOffset);
            testBlock1 = Prop(testBlockTransform, 'testBlock');
            testBlock2 = Prop(testBlockTransform, 'testBlock');
            testBlock1.endEffectorToPropTransform = transl(0, 0, 0.05);
            testBlock1.initProp;
            initJointAngles = [0, 0, 0, 0, 0, 0, pi/2];
            robot.model.animate(initJointAngles);
            robot.model.getpos();
            initTransform = robot.model.fkine(robot.model.getpos());
            preCalcData(1, :) = {initTransform, nan, nan, nan, nan, nan};
            %% Step: 1
            step1Transform = initTransform * transl(0, 0, -0.3);
            preCalcData(2, :) = {step1Transform, 'cartesian', nan, nan, nan, nan};
            %% Step: 2
            step2Transform =  step1Transform * transl(0, 0.2, -0.3);
            preCalcData(3, :) = {step2Transform, 'cartesian', nan, nan, nan, nan};
            %% Step: 3
            step3Transform = step2Transform * transl(0, -0.2, 0.3);
            preCalcData(4, :) = {step3Transform, 'cartesian', nan, nan, nan, nan};
            %% Step: 4
            step4Transform = testBlock1.positionTransform * trotx(pi) * trotz(-pi/2);
            preCalcData(5, :) = {step4Transform, 'joint', nan, nan, nan, nan};
            %% Step: 5
            step5Transform = step4Transform * transl(0, 0, -0.4);
            preCalcData(6, :) = {step5Transform, 'cartesian', 1, testBlock1, nan, nan};
            %% process the pre calculated data
            renderDataList = self.processData(robot, preCalcData);
            
        end
        %% processData
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
                      if i == 2
                         currentJoints = robot.model.getpos(); 
                      else
                         qMatrix = renderDataList{i - 2, 1};
                         currentJoints = qMatrix(numSteps, :);
                      end
                      qMatrix = robot.getCartesianQMatrix(currentTransform, currentJoints, goalTransform, numSteps);
                      renderDataList(i - 1, :) = {qMatrix, preCalcData{i, 3:6}};
                  
                  case 'joint'
                      if i == 2
                        currentJoints = robot.model.getpos();
                      else
                          qMatrix = renderDataList{i - 2, 1};
                          currentJoints = qMatrix(numSteps, :);
                      end
                      goalTransform = preCalcData{i, 1};
                      qMatrix = robot.getJointQMatrix(currentJoints, goalTransform, numSteps);
                      renderDataList(i - 1, :) = {qMatrix, preCalcData{i, 3:6}};
              end
           end
        end

    end
    
end