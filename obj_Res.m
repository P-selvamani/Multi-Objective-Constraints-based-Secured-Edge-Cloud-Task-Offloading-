function[fit] = obj_Res(soln)
global Param
for i = 1:size(soln,1)
    sol = soln(i,:);
    No_of_Task = [1, 2, 3, 4, 5];
    No_of_VM = [500, 600, 700, 800, 900];
    ind{i} = find(No_of_Task(i) == round(sol(i+1)));
    Id(i) = No_of_VM(ind{i});
    channel_index = ind{i};
    schedule(i) = No_of_VM(channel_index);
    Resource_Utilization = (schedule(i)/5).*100;
    Makespan = max(Param(i).Completion_Time);
    Energy_Consumption = (Param(i).Available_Memory/Param(i).Memory_Requirement).*Param(i).processing_Time;
    cost = sum( Param(i).Completion_Time + Resource_Utilization + Energy_Consumption );
    security = sum(Param(i).Memory_Requirement + Param(i).CPU_Requirement + Param(i).Priority);   
    fit(i) = (1 / (Makespan + security)) + (Resource_Utilization + Energy_Consumption + cost);
end
end
