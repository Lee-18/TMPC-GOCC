function GroupComfort=GroupOccThermalComfortDefine_2(OccupantsComfort)
% Definition of group occupants' comfort based on Homogeneous and inclusion
% input: OccupantsComfort: the vector of each occupant's comfort
% output: the precentage of occupant feeling comfortable

Y=length(find(OccupantsComfort==0))/length(OccupantsComfort);
GroupComfort=Y;

end