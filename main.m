opcdevice = OPCXMLDA();
opcdevice.url = 'http://169.254.224.71:8080';
%ans = opcdevice.browse()
%opcdevice.opctags
[old_value, old_type] = opcdevice.read("A.parameters.pH.Setpoint")
opctags=["A.parameters.pH.Setpoint" "A.parameters.Temp.Setpoint" "A.parameters.Stirrer.Setpoint" "A.parameters.Stirrer.Name", "A.parameters.Stirrer.FilterWindow", "bah","A.parameters.Stirrer.Measured"];

[values, types] = opcdevice.readBulk(opctags)
T = table(opctags', values, types, 'VariableNames', {'Tags', 'Values', 'Types'})
%opcdevice.write("A.parameters.Temp.Setpoint", 20)
opcdevice.writeBulk(["A.parameters.Temp.Setpoint" "A.parameters.pH.Setpoint"], [15,7])
