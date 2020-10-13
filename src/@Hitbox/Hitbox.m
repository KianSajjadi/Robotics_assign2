classdef Hitbox
    properties
        vertices;
        faces;
        faceNormals;
        positionTransform;
    end
    
    methods
        function self = Hitbox(height, width, length, initialTransform)
            self.vertices = self.getVertices(height, width, length, initialTransform);
            self.faces = self.getFaces(vertices);
            self.faceNormals = self.getFaceNormals(vertices, faces);
        end
        
        function vertices = getVertices(~, height, width, length, initialTransform)
            bottomCentrePoint = [0, 0, -height];
            topCentrePoint = [0, 0, 0];
            vertices(1, :) = [width/2, length/2, 0];
            vertices(2, :) = [width/2, -length/2, 0];
            vertices(3, :) = [-width/2, -length/2, 0];
            vertices(4, :) = [-width/2, length/2, 0];
            vertices(5, :) = [width/2, length/2, -height];
            vertices(6, :) = [width/2, -length/2, -height];
            vertices(7, :) = [-width/2, -length/2, -height];
            vertices(8, :) = [-width/2, length/2, -height]; 
        end
        
        function faces = getFaces(~)
            faces = [
                1, 2, 3; 1, 4, 3;
                1, 4, 5; 4, 5, 8;
                4, 3, 8; 3, 7, 8;
                3, 7, 6; 2, 3, 6;
                1, 2, 6; 1, 5, 6;
                5, 7, 8; 5, 6, 7
            ];
        end
        
        function faceNormals = getFaceNormals(~, vertices, faces)               
            faceNormals = zeros(size(face,1),3);
            for faceIndex = 1:size(face,1)
                v1 = vertices(faces(faceIndex,1)',:);
                v2 = vertices(faces(faceIndex,2)',:);
                v3 = vertices(faces(faceIndex,3)',:);
                faceNormals(faceIndex,:) = unit(cross(v2-v1,v3-v1));
            end 
        end
        
        function plotEdges(~, vertices)
            edges = [
                1, 2; 1, 4; 1, 3; 3, 4; 3, 2;
                5, 6; 5, 8; 5, 7; 7, 8; 7, 6;
                8, 4; 8, 3; 7, 3; 7, 2; 6, 2;
                6, 1; 5, 1; 5, 4
                ];
            hold on
            for i=1:size(edges,1)
                plot3([vertices(edges(i,1),1),vertices(edges(i,2),1)],...
                [vertices(edges(i,1),2),vertices(edges(i,2),2)],...
                [vertices(edges(i,1),3),vertices(edges(i,2),3)],'k')
            end
            hold off
        end
        
        function updatePosition(~, vertices)
            for i = 1:8
                vertices(i, :) = transl(goalTransform * transl(vertices(i, :)))';
            end
        end
    end
    
end
