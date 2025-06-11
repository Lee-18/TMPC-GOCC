function GroupComfort=GroupOccThermalComfortDefine_3(OccupantsComfort,OccupantsWeight)
% Definition of group occupants' comfort based on Heterogeneous and inclusion 
% input: OccupantsComfort: the vector of each occupant's comfort
%        OccupantsWeight: the weight of each occupant's comfort
% output: the weighting precentage of occupant feeling comfortable

Y_comf_w=0;
Y_all_w=0;
for occ_id=1:length(OccupantsComfort)
    if OccupantsComfort(occ_id)==0
        Y_comf_w=Y_comf_w+OccupantsWeight(occ_id);
    end
    Y_all_w=Y_all_w+OccupantsWeight(occ_id);
end

Y=Y_comf_w/Y_all_w;
GroupComfort=Y;

end