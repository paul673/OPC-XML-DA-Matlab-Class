# OPC-XML-Interface for Labfors 5
An OPC XML Interface for Matlab. Used to communicate with a Labfors 5 bioreactor system.
this is a forked repository with some minor changes.

Working OPCXML Actions:
- Read
- Write
- Browse


The interface is designed as a Matlab Class. To use it copy the folder containing the class in your matlab path.

Example Usage
```
% Initialize OPC device
opcdevice = OPCXMLDA(); 
opcdevice.url = 'http://169.254.224.71:8080'; % Tower interface IP-address port 8080

% Read current pH
[ph, xml_unit] = opcdevice.read('A.parameters.pH.CurValue');

% Set pH setpoint to 9 (has not been tested yet)
opcdevice.write('A.parameters.pH.Setpoint', 9); 

% Browse tags (Not required)
browse_result = opcdevice.browse();

% No need for close since we just send HTTP requests and do not establish a persistent connection
```



**TODO**
- Add readBulk method
- Add writeBulk method

Tested on Matlab 2026a.

