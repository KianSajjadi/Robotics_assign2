function fkineJoints = getFkineJoints(robot, q)
    sizeMatrix = size(robot.model.links);
    size_n = sizeMatrix(2);
    fkineJoints = cell(size_n + 1, 1);
    fkineJoints{1, 1} = robot.model.base;
    for i = 2:size_n + 1
        link = robot.model.links(1, i - 1);
        if isempty(link.theta) == 0
            theta = q(1, i - 1) + link.theta;
        else
            theta = q(1, i - 1);
        end
        a = link.a;
        d = link.d;
        alpha = link.alpha;
        tr = fkineJoints{i - 1, 1} * trotz(theta) * transl(0, 0, d) * transl(a, 0, 0) * trotx(alpha);
        fkineJoints{i, 1} = tr;
    end
end