%% stopAnimation
%


function stopAnimation(robot, q, isHolding, prop)
   robot.model.animate(q);
   drawnow();
   if isHolding == true
       prop.updatePos(robot.model.fkine(q) * robot.endEffectorToPropTransform)
   end
end