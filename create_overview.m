opcdevice = OPCXMLDA();
opcdevice.url = 'http://169.254.224.71:8080';

S = load("C:\Users\pauljg\Desktop\Programming\OPC-XML-DA-Matlab-Class\screen_result.mat").screen_result;

paths  = strings(0,1);
values = strings(0,1);
types  = strings(0,1);

[paths,values,types] = walk(S,"",opcdevice,paths,values,types);

T = table(paths,values,types);

%h = waitbar(0,'Reading OPC tags...');
function [paths,values,types] = walk(S,parent,opcdevice,paths,values,types)

    f = fieldnames(S);

    for i = 1:numel(f)

        name = f{i};
        x = S.(name);

        if parent == ""
            path = string(name);
        else
            path = parent + "." + name;
        end

        if isstruct(x)

            [paths,values,types] = walk( ...
                x,path,opcdevice,paths,values,types);

        else

            [v,t] = opcdevice.read(x);

            paths(end+1,1)  = path;
            values(end+1,1) = string(v);
            types(end+1,1)  = string(t);

        end
    end
end