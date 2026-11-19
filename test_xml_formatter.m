dom = xmlread("./@OPCXMLDA/write.xml");
par = ["Hahaha", 1, "buhu",2];
par2 = ["Hahaha", "buhu"];
val2 = [1,2];
units2 = ["xsd:double", "xsd:int"];
%r = soapactionInjectItemlist(dom, par);
r = soapactionInjectItemlist2(dom, par2);
r = soapactionchangeValues(dom,val2,units2);
xmlwrite(r)

function r=soapactionInjectItemlist2(dom, par)


    itemList = dom.getElementsByTagName("ItemList").item(0);
    template = dom.getElementsByTagName("Items").item(0);
    for i = 1:length(par)
        if i == 1
            item=template;
            
        else
            item=template.cloneNode(true);
            itemList.appendChild(item);
        end
        
        item.setAttribute("ItemName", par(i));
        item.setAttribute("ClientItemHandle", string(i));
    end
    r=dom;
    
end


function r=soapactionInjectItemlist(dom, par)

if (mod(length(par),2))
    error('wrong dimensions ["item1","val1","item2,"val2",...]')
else
    itemList = dom.getElementsByTagName("ItemList").item(0);
    template = dom.getElementsByTagName("Items").item(0);
    for i = 1:length(par)/2
        if i == 1
            item=template;
        else
            item=template.cloneNode(true);
            itemList.appendChild(item);
        end
        item.setAttribute("ItemName", par(i*2-1));
        item.setAttribute("ClientItemHandle", string(i))
    end
end
r=dom;
end

function r = soapactionchangeValuesList(dom,values,opctypes)
    %% Create an item list with soapactionInjectItemlist first and then inject values using this function
    if numel(values)~=numel(opctypes)
        error('wrong dimensions values must have same dim as opctypes')
    end

    values_dom = dom.getElementsByTagName('Value');
    if numel(values)~=values_dom.getLength
        error('Not enough Items in dom')
    end

    for i=1:numel(values)
        values_dom.item(i-1).setAttribute("xsi:type",opctypes(i));
        values_dom.item(i-1).setTextContent(string(values(i)));
    end
    r = dom;
end


function r = writeBulk(obj,opctags,values)
%% Check if num elements in opctags and values are equal
if numel(opctags) ~= numel(values)
    error('opctags and values must have the same number of elements.')
end

%% Iterate through values and assign opctype 
opctypes = strings(size(values));
xmlvalues = strings(size(values));
for i=1:length(values)
    [istype,opctype] = obj.checktype(values(i),opctags(i));
    opctypes(i) = opctype;
    xmlvalues(i) = obj.converttype(values(i),opctype);
end
% In order to make the write function we need to know what
% types are accepted by the device. Lets use the structure
% created from browse to get a similar structure but with the
% accepted types for every element.
[istype,opctype] = obj.checktype(value,itemNameArg);
if istype
    xmlvalue = obj.converttype(value,opctype);
    if (nargin == 3)
        try
            itemName = itemNameArg;
            %fields = textscan(ItemNameArg,'%s','Delimiter','.');
            fields = obj.getstructfieldsarray(itemNameArg);
        catch
            error('Given OPC-Tag is not Valid.')
        end
    else
        error('Wrong number of arguments given.')
    end
    operation = obj.operation.Write;
    soapaction = obj.getsoapAction(operation);%,["ItemName",itemName]);
    soapaction = obj.soapactionchangeParameters(soapaction,"Items",["ItemName",itemName]);
    %soapaction = obj.soapactionchangeParameters(soapaction,"Value",["xsi:type",opctype]);
    soapaction = obj.soapactionchangeValue(soapaction,xmlvalue,opctype);
    response = obj.request(soapaction,operation);
else
    error('wrong type')
end

r = "OK";%xmlwrite(response);
end
