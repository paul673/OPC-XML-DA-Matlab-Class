opcdevice = OPCXMLDA("OPC_log.txt");
opcdevice.url = 'http://169.254.224.71:8080';

%ans = opcdevice.browse()
%opcdevice.opctags
%[old_value, old_type] = opcdevice.read("A.parameters.pH.Setpoint")
opctags=["A.parameters.pH.Setpoint" "A.parameters.Temp.Setpoint" "A.parameters.Stirrer.Setpoint" "A.parameters.Stirrer.Name", "A.parameters.Stirrer.FilterWindow", "bah","A.parameters.Stirrer.Measured"];

[values, types] = opcdevice.readBulk(opctags)
T = table(opctags', values, types, 'VariableNames', {'Tags', 'Values', 'Types'})
%opcdevice.write("A.parameters.Temp.Setpoint", 20)
%opcdevice.writeBulk(["A.parameters.Temp.Setpoint" "A.parameters.pH.Setpoint"], [15,7])

setp = [500 200 600];


s_setpoints = nan(60,1);
s_measured  = nan(60,1);
time = nan(60,1);

% Initialize plot
figure('Color','w');
hold on
h1 = animatedline('Color','b','LineWidth',1.5);
h2 = animatedline('Color','r','LineWidth',1.5,'LineStyle','--');

ylim([0 1000]);

xlabel('Time [s]')
ylabel('Stirrer speed [rpm]')
legend('Measured','Setpoint','Location','best')
grid on

tic
for i=1:60
    [v,t] = opcdevice.readBulk(["A.parameters.Stirrer.CurValue","A.parameters.Stirrer.Setpoint"]);
    measured = v{1};
    setpoint = v{2};
    if mod(i,20)==0
        opcdevice.writeBulk(["A.parameters.Stirrer.Setpoint"], [setp(i/20)])
    end
    
    % Store data
    time(i) = toc;
    s_measured(i) = measured;
    s_setpoints(i) = setpoint;

    % Update plot
    addpoints(h1,time(i),measured);
    addpoints(h2,time(i),setpoint);

    drawnow limitrate


    pause(10)
end