classdef Environment 
    
    properties
        concreteWalls;
        workshopFloor;
        cautionPoster;
        table;
        tray;
        cr10;
        redLaserXList;
        redLaserYList;
        
    end
    
    methods
        function self = Environment()
            self.concreteWalls{1, 1} = self.getConcreteWall(-2, 2, -2, 2, -2, -2, -2, -2, 2, 2, -0.8, -0.8);
            self.concreteWalls{2, 1} = self.getConcreteWall(-2, -2, -2, -2, -2, 2, -2, 2, 2, 2, -0.8, -0.8);
            self.workshopFloor = self.getWorkshopFloor(2, -2, 2, -2, 2, 2, -2, -2, -0.8, -0.8, -0.8, -0.8);
            self.cautionPoster = self.getCautionPoster(-2, -2, -2, -2, 1, 2, 1, 2, 1, 1, 0.5, 0.5);           
            self.redLaserXList{1, 1} = self.getRedLaserX(-1.6, 0.1, 1.6, 1, 1, 1.7, -0.8);
            self.redLaserXList{2, 1} = self.getRedLaserX(-1.6, 0.1, 1.6, -1, -1, 1.7, -0.8);           
            self.redLaserYList{1, 1} = self.getRedLaserY(-1, 0.1, 1, 1.6, 1.6, 1.7, -0.8);
            self.redLaserYList{2, 1} = self.getRedLaserY(-1, 0.1, 1, -1.6, -1.6, 1.7, -0.8);
            self.table = Prop(transl(0, 0, 0), 'table');
            table.prop_h.FaceColor = [198 137 88]/255;
            self.table.initProp;
            self.tray = Prop(transl(0.5, -0.25, 0), 'tray');
            self.tray.initProp;
            self.cr10 = Prop(transl(0.6, 0, 0) * trotz(-pi/2), 'cr-10');
            self.cr10.initProp;
          
        end
        
        % Concrete Wall
        function concreteWall = getConcreteWall(~, x1, x2, x3, x4, y1, y2, y3, y4, z1, z2, z3, z4)
            image = imread('Concrete Wall.jpg');

            xImage = [x1 x2; x3 x4];
            yImage = [y1 y2; y3 y4];
            zImage = [z1 z2; z3 z4];
            
            hold on
            concreteWall = surf(xImage, yImage, zImage, 'CData', image, 'FaceColor', 'texturemap');
            hold off
        end
        
        % Workshop Floor
        function workshopFloor = getWorkshopFloor(~, x1, x2, x3, x4, y1, y2, y3, y4, z1, z2, z3, z4)
            image = imread('Workshop Floor.jpg');

            xImage = [x1 x2; x3 x4];
            yImage = [y1 y2; y3 y4];
            zImage = [z1 z2; z3 z4];
            
            hold on
            workshopFloor = surf(xImage, yImage, zImage, 'CData', image, 'FaceColor', 'texturemap');
            hold off
        end
        
        % Caution Poster
        function cautionPoster = getCautionPoster(~, x1, x2, x3, x4, y1, y2, y3, y4, z1, z2, z3, z4)
            image = imread('Caution Poster.jpg');

            xImage = [x1 x2; x3 x4];
            yImage = [y1 y2; y3 y4];
            zImage = [z1 z2; z3 z4];
            
            hold on
            cautionPoster = surf(xImage, yImage, zImage, 'CData', image, 'FaceColor', 'texturemap');
            hold off
        end
        
        % Red Laser X-Axis
        function redLaserX = getRedLaserX(~, r1, i1, r2, y1, y2, z1, z2)
            iterator = 1;
            for x = r1:i1:r2
                redLaserX{iterator}= line('XData', [x x], 'YData', [y1 y2], 'ZData', [z1 z2], 'Color', [1 0 0]);
                iterator = iterator + 1;
            end
            
        end
        
        % Red Laser Y-Axis
        function redLaserY = getRedLaserY(~, r1, i1, r2, x1, x2, z1, z2)
            iterator = 1;
            for y = r1:i1:r2
                redLaserY{iterator} = line('XData', [x1 x2], 'YData', [y y], 'ZData', [z1 z2], 'Color', [1 0 0]);
                iterator = iterator + 1;
            end
            
        end
        
    end
    
end