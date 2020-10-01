classdef Prop < handle
    %% Properties
    properties
        faces;
		points;
		data;
		numPoints;
		prop_h;
        positionTransform;
        propName;
    end
    %% Methods
    methods
        function self = Prop(initTransform, propName)
                self.positionTransform = initTransform;
                [faces, points, data] = self.getPolyData(propName);
                self.faces = faces;
                self.points = points;
                self.data = data;
                numPointsMtx = size(points);
                numPoints = numPointsMtx(1);
                self.numPoints = numPoints;            
                drawnow();
                self.propName = propName;
        end
         
        function [faces, points, data] = getPolyData(~, propName)
			[faces, points, data] = plyread(propName + ".ply", "tri");
        end
        
        function initProp(self)
            hold on
			self.prop_h = trisurf(self.faces, self.points(:, 1), self.points(:, 2), self.points(:, 3), "LineStyle", "none");
            self.updatePosition(self.positionTransform);
			hold off
        end
        
        function updatePosition(self, goalTransform)
			for i = 1:self.numPoints
				self.prop_h.Vertices(i, :) = transl(goalTransform * transl(self.points(i, :)))';
			end
        end
        
    end 
end