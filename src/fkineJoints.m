function trMatrix = fkineJoints(robotModel, q)
    sizeMatrix = size(robotModel.links);
    size_n = sizeMatrix(2);
    trMatrix = cell(size_n + 1, 1);
    trMatrix{1, 1} = robotModel.base;
    for i = 2:size_n + 1
        link = robotModel.links(1, i - 1);
        if isempty(link.theta) == 0
            theta = q(1, i - 1) + link.theta;
        else
            theta = q(1, i - 1);
        end
        a = link.a;
        d = link.d;
        alpha = link.alpha;
        tr = trMatrix{i - 1, 1} * trotz(theta) * transl(0, 0, d) * transl(a, 0, 0) * trotx(alpha);
        trMatrix{i, 1} = tr;
    end
end