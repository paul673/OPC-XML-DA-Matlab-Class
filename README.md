# OPC-XML-Interface for Labfors 5
An OPC XML Interface for Matlab. Used to communicate with a Labfors 5 bioreactor system.
this is a forked repository with some minor changes.

Working OPCXML Actions:
- Read
- Write
- Browse

The interface is designed as a Matlab Class. To use it copy the folder containing the class in your matlab path. The OPCXMLDA constructs the required XML file for each OPC action and sends the corresponding HTTP request. The `read` and `write` method are only able to embedd a signle tag into the request. Reading or writing multible values at a time does therefore require to send multible requests. The `readBulk` and `writeBulk` were introduced to read and write to multible tags at once. 


Example Usage
```
% Initialize OPC device
opcdevice = OPCXMLDA(); 
opcdevice.url = 'http://169.254.224.71:8080'; % Tower interface IP-address port 8080

% Read current pH (one value at a time)
[ph, xml_unit] = opcdevice.read('A.parameters.pH.CurValue');

% Set pH setpoint to 9 (one value at a time) (has not been tested yet)
opcdevice.write('A.parameters.pH.Setpoint', 9); 

% Browse tags (Not required)
browse_result = opcdevice.browse();

% Read multible tags at once
[values, types] = opcdevice.readBulk(["A.parameters.pH.Setpoint" "A.parameters.Temp.Setpoint"]);

% Write to multible tags at once
opcdevice.writeBulk(["A.parameters.Temp.Setpoint" "A.parameters.pH.Setpoint"], [15,7])




% No need for close since we just send HTTP requests and do not establish a persistent connection
```





Tested on Matlab 2026a.

