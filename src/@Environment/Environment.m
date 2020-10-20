
classdef Environment 
    
    properties
        concreteWalls;
        workshopFloor;
        cautionPoster;
        table;
        
    end
    
    methods
        function self = Environment(self)
           self.concreteWalls{1, 1} = self.getConcreteWall(-2, 2, -2, 2, -2, -2, -2, -2, 2, 2, -0.3, -0.3);
           self.concreteWalls{2, 1} = self.getConcreteWall(-2, -2, -2, -2, -2, 2, -2, 2, 2, 2, -0.3, -0.3);
           self.workshopFloor = self.getWorkshopFloor(2, -2, 2, -2, 2, 2, -2, -2, -0.3, -0.3, -0.3, -0.3);
           self.cautionPoster = self.getCautionPoster(-2, -2, -2, -2, 1, 2, 1, 2, 1, 1, 0.5, 0.5);
           self.table = Prop(transl(0, 0, 0.8), "table");
           self.table.initProp;
        end
        
        % Concrete Wall
        function concreteWall = getConcreteWall(~, x1, x2, x3, x4, y1, y2, y3, y4, z1, z2, z3, z4)

            image = imread('Concrete Wall.jpg');

            xImage = [x1 x2; x3 x4];
            yImage = [y1 y2; y3 y4];
            zImage = [z1 z2; z3 z4];
            
            hold on
            surf(xImage, yImage, zImage, 'CData', image, 'FaceColor', 'texturemap');
            hold off
            
        end
        
        % Workshop Floor
        function workshopFloor = getWorkshopFloor(~, x1, x2, x3, x4, y1, y2, y3, y4, z1, z2, z3, z4)

            image = imread('Workshop Floor.jpg');

            xImage = [x1 x2; x3 x4];
            yImage = [y1 y2; y3 y4];
            zImage = [z1 z2; z3 z4];
            
            hold on
            surf(xImage, yImage, zImage, 'CData', image, 'FaceColor', 'texturemap');
            hold off
            
        end
        
        % Caution Poster
        function cautionPoster = getCautionPoster(~, x1, x2, x3, x4, y1, y2, y3, y4, z1, z2, z3, z4)

            image = imread('Caution Poster.jpg');

            xImage = [x1 x2; x3 x4];
            yImage = [y1 y2; y3 y4];
            zImage = [z1 z2; z3 z4];
            
            hold on
            surf(xImage, yImage, zImage, 'CData', image, 'FaceColor', 'texturemap');
            hold off
            
        end
        
        % Red Laser X-Axis
        function redLaserX = getRedLaserX(~, r1, i1, r2, y1, y2, z1, z2)
            for x = r1:i1:r2
                line('XData', [x x], 'YData', [y1 y2], 'ZData', [z1 z2], 'Color', [1 0 0]);
                
            end
            
        end
        
        % Red Laser Y-Axis
        function redLaserY = getRedLaserY(~, r1, i1, r2, x1, x2, z1, z2)
            for y = r1:i1:r2
                line('XData', [x1 x2], 'YData', [y y], 'ZData', [z1 z2], 'Color', [1 0 0]);
            
            end
            
        end
        
    end
    
end