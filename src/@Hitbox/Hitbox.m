classdef Hitbox
    properties
        vertices;
        faces;
        faceNormals;
        positionTransform;
    end
    
    methods
        function self = Hitbox(height, width, length, displacement, initialTransform)
            self.vertices = self.getVertices(height, width, length, displacement, initialTransform);
            self.faces = self.getFaces();
        end
        
        function vertices = getVertices(~, height, width, length, displacement, initialTransform)
            bottomCentrePoint = [0, 0, -height];
            topCentrePoint = [0, 0, 0];
            initialVector = transl(initialTransform);
            vertices(1, :) = transl(transl(width / 2  + displacement(1, 1), length / 2 + displacement(2, 1), 0  + displacement(3, 1)) * initialTransform);
            vertices(2, :) = transl(transl(width / 2  + displacement(1, 1), -length / 2 + displacement(2, 1), 0  + displacement(3, 1)) * initialTransform);
            vertices(3, :) = transl(transl(-width / 2  + displacement(1, 1), -length / 2 + displacement(2, 1), 0  + displacement(3, 1)) * initialTransform);
            vertices(4, :) = transl(transl(-width / 2  + displacement(1, 1), length / 2 + displacement(2, 1), 0  + displacement(3, 1)) * initialTransform);
            vertices(5, :) = transl(transl(width / 2  + displacement(1, 1), length / 2 + displacement(2, 1), height  + displacement(3, 1)) * initialTransform);
            vertices(6, :) = transl(transl(width / 2  + displacement(1, 1), -length / 2 + displacement(2, 1), height  + displacement(3, 1)) * initialTransform);
            vertices(7, :) = transl(transl(-width / 2  + displacement(1, 1), -length / 2 + displacement(2, 1), height  + displacement(3, 1)) * initialTransform);
            vertices(8, :) = transl(transl(-width / 2  + displacement(1, 1), length / 2 + displacement(2, 1), height  + displacement(3, 1)) * initialTransform);
            % vertices(1, :) = [width / 2 + initialVector(1, 1) + displacement(1, 1), length / 2 + initialVector(2, 1) + displacement(2, 1), 0 + initialVector(3, 1) + displacement(3, 1)];
            % vertices(2, :) = [width / 2 + initialVector(1, 1) + displacement(1, 1), -length / 2 + initialVector(2, 1) + displacement(2, 1), 0 + initialVector(3, 1) + displacement(3, 1)];
            % vertices(3, :) = [-width / 2 + initialVector(1, 1) + displacement(1, 1), -length / 2 + initialVector(2, 1) + displacement(2, 1), 0 + initialVector(3, 1) + displacement(3, 1)];
            % vertices(4, :) = [-width / 2 + initialVector(1, 1) + displacement(1, 1), length / 2 + initialVector(2, 1) + displacement(2, 1), 0 + initialVector(3, 1) + displacement(3, 1)];
            % vertices(5, :) = [width / 2 + initialVector(1, 1) + displacement(1, 1), length / 2 + initialVector(2, 1) + displacement(2, 1), height + initialVector(3, 1) + displacement(3, 1)];
            % vertices(6, :) = [width / 2 + initialVector(1, 1) + displacement(1, 1), -length / 2 + initialVector(2, 1) + displacement(2, 1), height + initialVector(3, 1) + displacement(3, 1)];
            % vertices(7, :) = [-width / 2 + initialVector(1, 1) + displacement(1, 1), -length / 2 + initialVector(2, 1) + displacement(2, 1), height + initialVector(3, 1) + displacement(3, 1)];
            % vertices(8, :) = [-width / 2 + initialVector(1, 1) + displacement(1, 1), length / 2 + initialVector(2, 1) + displacement(2, 1), height + initialVector(3, 1) + displacement(3, 1)]; 
        end
        
        function faces = getFaces(~)
            faces = [
                1, 2, 3; 1, 4, 3;
                1, 5, 6; 1, 2, 6;
                2, 6, 7; 2, 3, 7;
                8, 3, 7; 8, 4, 3;
                4, 1, 5; 4, 8 ,5;
                5, 6, 7; 5, 8, 7;
            ];
        end
        
        function faceNormals = getFaceNormals(self)               
            faceNormals = zeros(size(self.faces, 1), 3);
            for faceIndex = 1 : size(self.faces, 1)
                v1 = self.vertices(self.faces(faceIndex, 1)', :);
                v2 = self.vertices(self.faces(faceIndex, 2)', :);
                v3 = self.vertices(self.faces(faceIndex, 3)', :);
                faceNormals(faceIndex, :) = unit(cross(v2 - v1, v3 - v1));
            end 
        end
        
        function edgePlot = plotEdges(self)
            edges = [
                1, 2; 1, 4; 1, 3; 3, 4; 3, 2;
                5, 6; 5, 8; 5, 7; 7, 8; 7, 6;
                8, 4; 8, 3; 7, 3; 7, 2; 6, 2;
                6, 1; 5, 1; 5, 4
                ];
            hold on
            for i = 1 : size(edges, 1)
                edgePlot(i) = plot3([self.vertices(edges(i, 1), 1), self.vertices(edges(i, 2), 1)],...
                [self.vertices(edges(i, 1), 2), self.vertices(edges(i, 2), 2)],...
                [self.vertices(edges(i,1) , 3), self.vertices(edges(i, 2), 3)], 'k');
            end
            hold off
        end
        
        function updatedVertices = updatePosition(self, goalTransform)
            for i = 1:8
                vertexVector = self.vertices(i, :);
                transformedVertices(i, :) = transl(goalTransform * transl(vertexVector))';
            end
            updatedVertices = transformedVertices;
        end
    end
    
end
