function GroupComfort=GroupOccThermalComfortDefine_1(OccupantsComfort)
% Definition of group occupants' comfort based on Majority Rule
% input: OccupantsComfort: the vector of each occupant's comfort
% output: the group comfort (-1=cold, 0=comfortable, and 1=hot)

NumColdOcc=size(find(OccupantsComfort==-1),2);
NumComfortableOcc=size(find(OccupantsComfort==0),2);
NumHotOcc=size(find(OccupantsComfort==1),2);
Y=find([NumColdOcc NumComfortableOcc NumHotOcc]==max([NumColdOcc NumComfortableOcc NumHotOcc]))-2;
if size(Y,2)>1
    Y=0;
end

GroupComfort=Y;
end