classdef Workbench < handle
    %% Properties
    properties
        robot;
        renderDataList;
        robotHitboxList;
        environment;
        propList;
        ooeyGUI;
        linePoint1;
        linePoint2;
        step;
        qMatrixStoppedPosition;
        runRobot;
        continueState;
        stopState;
    end
    
    %% Methods
    methods
        function self = Workbench(robot)
            self.stopState = 0;
            self.continueState = 1;
            self.robot = robot;
            self.runRobot = 1;
            self.environment = Environment;
            self.robotHitboxList = robot.getRobotHitboxList();  
            self.renderDataList = self.getRenderDataList(robot);
            self.getOoeyGUI;

        end

        function runAnimation(self)
           self.animateScene(self.robot, self.renderDataList); 
        end
        %% getRenderDataList
        function renderDataList = getRenderDataList(self, robot)
            %% create all props and initialise project
            blockOffset = 0.05;
            legoBrickTransform = transl(0.5, 0, 0.045 + blockOffset);
            legoBrick1 = Prop(legoBrickTransform, 'legoBrick');
            legoBrick2 = Prop(legoBrickTransform, 'legoBrick');
            legoBrick1.endEffectorToPropTransform = transl(0, 0, 0) * trotx(pi) * trotz(pi/2);
            legoBrick2.endEffectorToPropTransform = transl(0, 0, 0) * trotx(pi) * trotz(pi/2);
            legoBrick1.initProp;
            initJointAngles = [0, 0, 0, 0, 0, 0.523599, pi/2];
            robot.model.animate(initJointAngles);
            robot.model.getpos();
            initTransform = robot.model.fkine(robot.model.getpos());
            preCalcData(1, :) = {initTransform, nan, nan, nan, nan, nan};
            %% Step: 1 move robot away from bricks
            step1Transform = initTransform * transl(0, 0, -0.3);
            preCalcData(2, :) = {step1Transform, 'cartesian', nan, nan, nan, nan};
            %% Step: 2 move robot to first lego brick
            step2Transform = legoBrick1.positionTransform * trotx(pi) * trotz(-pi/2);
            preCalcData(3, :) = {step2Transform, 'joint', nan, nan, nan, nan};
            %% Step: 3 move robot to a clearance
            step3Transform = step2Transform * transl(0, 0, -0.1);
            preCalcData(4, :) = {step3Transform, 'cartesian', 1, legoBrick1, nan, nan};
            %% Step: 4 move robot to a point between where it is and endposition of legobrick
            step4Transform = transl(0, -0.4, 0.3) * trotx(pi);
            preCalcData(5, :) = {step4Transform, 'cartesian', 1, legoBrick1, nan, nan};
            %% Step: 5 place first legobrick in its end position
            step5Transform = transl(-0.45, 0.03125, 0.06) * trotx(pi) * trotz(pi/2);
            preCalcData(6, :) = {step5Transform, 'cartesian', 1, legoBrick1, nan, nan};
            %% Step: 6 go back to halfway point
            step6Transform = transl(0, -0.4, 0.3) * trotx(pi);
            preCalcData(7, :) = {step6Transform, 'cartesian', 0, nan, 1, legoBrick2};
            %% Step: 7 go to second brick
            step7Transform = legoBrick1.positionTransform * trotx(pi) * trotz(-pi/2);
            preCalcData(8, :) = {step7Transform, 'joint', nan, nan, nan, nan};
            %% Step: 8 go to halfway point
            step8Transform = transl(0, -0.4, 0.3) * trotx(pi);
            preCalcData(9, :) = {step8Transform, 'cartesian', 1, legoBrick2, nan, nan};
            %% Step: 9 stack brick 2 onto brick 1
            step9Transform = transl(-0.445, 0.03125, 0.09) * trotx(pi) * trotz(pi/2);
            preCalcData(10, :) = {step9Transform, 'cartesian', 1, legoBrick2, nan, nan};
            %% process the pre calculated data
            renderDataList = self.processData(robot, preCalcData, self.robotHitboxList);
            
        end
        %% processData
        function renderDataList = processData(self, robot, preCalcData, robotHitboxList)
            numSteps = 25;
            sizeMtx = size(preCalcData);
            n = sizeMtx(1);
            renderDataList = cell(n - 1, 6);
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
                        renderDataList(i - 1, :) = {qMatrix, preCalcData{i, 3:6}, NaN};
                        
                    case 'joint'
                        if i == 2
                            currentJoints = robot.model.getpos();
                        else
                            qMatrix = renderDataList{i - 2, 1};
                            currentJoints = qMatrix(numSteps, :);
                        end
                        goalTransform = preCalcData{i, 1};
                        qMatrix = robot.getJointQMatrix(currentJoints, goalTransform, numSteps);
                        renderDataList(i - 1, :) = {qMatrix, preCalcData{i, 3:6}, NaN};
                end
                
                robotHitboxQMatrixPositionList = cell(numSteps, 1); 
                for j = 1 : numSteps
                    fkineJoints = robot.getFkineJoints(qMatrix(j, :));
                    for k = 1 : 8
                        hitbox = robotHitboxList{k, 1};
                        hitbox.vertices = hitbox.updatePosition(fkineJoints{k, 1});
                        robotHitboxQMatrixPositionList{j, k} = hitbox;
                    end
                end
                renderDataList{i - 1 , 6} = robotHitboxQMatrixPositionList;  
            end

        end
        
    end
    
end


