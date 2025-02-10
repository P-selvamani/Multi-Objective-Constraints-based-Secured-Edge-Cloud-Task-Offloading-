function [] = Plot_Results()
clc;
clear all;
close all;
warning off;
% 
ca = {'Best','Worst','Mean','Median','Std_dev'};
%% Convergence
Algms = {'Eso','Co','Waoa','Lo', 'Prop'};
for var = 1:5 % For all  variations
    for i = 1 : 5 % For all agorithms
        eval(['load ', char(Algms{i})])
        eval(['val(i, :) = ', char(Algms{i}), '(var).fit;'])
    end
       
     ind = find(val(:, end) == min(val(:, end)));
    t = val(5, :);
    val(5, :) = val(ind(1), :);
    val(ind(1), :) = t;
    for i = 1 : 5
%         stat(i, :) = Statistical_Analysis(val(i, :));
        a1{i} = Statistical_Analysis(val(i, :));
    end
    
    fprintf('Statistical Report: %d\n',var)
    ca = {'Best','Worst','Mean','Median','Std_dev'};
    T = table(a1{1}',a1{2}',a1{3}',a1{4}',a1{5}','Rownames',ca);
    T.Properties.VariableNames = {'ESO','CO','WaOA','LO', 'PROPOSED'};
    disp(T)   
    
    figure,
    plot(val(1, :), 'r', 'LineWidth', 2)
    hold on;
    plot(val(2, :), 'g', 'LineWidth', 2)
    plot(val(3, :), 'b', 'LineWidth', 2)
    plot(val(4, :), 'm', 'LineWidth', 2)
    plot(val(5, :), 'c', 'LineWidth', 2)
    set(gca, 'fontsize', 12);
    grid on;
    xlabel('Iteration', 'fontsize', 12);
    
    ylabel('Cost Function', 'fontsize', 12);
    h = legend('ESO','CO','WaOA','LO', 'H-WOLOA');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['./Results/Convergence_', num2str(var)])
end

load Res
Stats = {'BEST', 'WORST', 'MEAN', 'MEDIAN', 'STD'};
Terms = { 'Makespan'; 'Throughput';' Security' ;'Resource Utilization'; 'Energy Consumption'; 'Cost'; };

for i = 1:10
    for j = 1:5
        Outs{i}(j, :) = Res(i).out{j};
    end
    Outs{i}(isinf(Outs{i})|isnan(Outs{i})) = 0;
end

Positive = [1,2,3];

for i = 1:length(Terms)
    for j = 1:length(Outs)
        if length(find(ismember(i, Positive))) >= 1
            Statistics(j, 1) = max(Outs{j}(:, i));
            Statistics(j, 2) = min(Outs{j}(:, i));
            Statistics(j, 3) = mean(Outs{j}(:, i));
            Statistics(j, 4) = median(Outs{j}(:, i));
            Statistics(j, 5) = std(Outs{j}(:, i));
        else
            Statistics(j, 1) = min(Outs{j}(:, i));
            Statistics(j, 2) = max(Outs{j}(:, i));
            Statistics(j, 3) = mean(Outs{j}(:, i));
            Statistics(j, 4) = median(Outs{j}(:, i));
            Statistics(j, 5) = std(Outs{j}(:, i));
        end
    end

    for j = 1:size(Statistics, 2)
        if length(find(ismember(i, Positive))) >= 1
            [a, b] = max(Statistics(:, j));
        else
            [a, b] = min(Statistics(:, j));
        end
        x = Statistics(b, j);
        y = Statistics(5, j);
        Statistics(5, j) = x;
        Statistics(end, j) = x;
        Statistics(b, j) = y;
    end

    disp(strcat(char(Terms{i}), " - Algorithm Comparison - Statistical Report"))
    T = table(char(Stats), Statistics(1, :)', Statistics(2, :)', Statistics(3, :)', Statistics(4, :)', Statistics(5, :)');
    T.Properties.VariableNames = {'Statistics','ESO', 'CO','WaOA','LO','H-WOLOA'};
    disp(T)
    
    disp(strcat(char(Terms{i}), " - Method Comparison - Statistical Report"))
    T = table(char(Stats), Statistics(6, :)', Statistics(7, :)', Statistics(8, :)', Statistics(9, :)', Statistics(10, :)');
    T.Properties.VariableNames = {'Statistics','DRL', 'LPGA','GS-MEC','PMCO','H-WOLOA'};
    disp(T)
end

X = 1:5;
for i = 1:length(Terms)
    for j = 1:5
        Plt_Vaues(j, :) = sort(Outs{j}(X, i));
    end
    for j = 1:size(Plt_Vaues, 2)
        if length(find(ismember(i, Positive))) >= 1
            [a, b] = max(Plt_Vaues(:, j));
        else
            [a, b] = min(Plt_Vaues(:, j));
        end
        x = Plt_Vaues(b, j);
        y = Plt_Vaues(end, j);
        Plt_Vaues(end, j) = x;
        Plt_Vaues(b, j) = y;
    end  
    x=[1, 2, 3,4,5];
    figure,
    plot(x, Plt_Vaues(1, :)','-dr', 'LineWidth', 2, 'markersize',12); hold on
    plot(x, Plt_Vaues(2, :)','-dg', 'LineWidth', 2, 'markersize',12);
    plot(x, Plt_Vaues(3, :)','-db', 'LineWidth', 2, 'markersize',12);
    plot(x, Plt_Vaues(4, :)','-dm', 'LineWidth', 2, 'markersize',12);
    plot(x, Plt_Vaues(5, :)','-dc', 'LineWidth', 2, 'markersize',12);
    set(gca, 'fontsize', 12);
    grid on;
    ylabel(char(Terms{i}), 'FontSize', 14);
    xlabel('No of Configuration', 'fontsize', 12);
    h = legend('ESO', 'CO','WaOA','LO','H-WOLOA');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['./Results/alg_', char(Terms{i})])
end
X = 1:5;
for i = 1:length(Terms)
    for j = 1:5
        Plt_Vaues(j, :) = sort(Outs{j+5}(X, i));
    end
    for j = 1:size(Plt_Vaues, 2)
        if length(find(ismember(i, Positive))) >= 1
            [a, b] = max(Plt_Vaues(:, j));
        else
            [a, b] = min(Plt_Vaues(:, j));
        end
        x = Plt_Vaues(b, j);
        y = Plt_Vaues(end, j);
        Plt_Vaues(end, j) = x;
        Plt_Vaues(b, j) = y;
    end
    figure,
    bar(X, Plt_Vaues')
    set(gca, 'FontSize', 14);
    xlabel('No of Configuration', 'FontSize', 14);
    ylabel(char(Terms{i}), 'FontSize', 14);
    xticklabels(["1", "2", "3", "4", "5"])
    h = legend('DRL', 'LPGA','GS-MEC','PMCO','H-WOLOA');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\met_', char(Terms{i})])
end
end
function[a] = Statistical_Analysis(val)
a(1) = min(val);
a(2) = max(val);
a(3) = mean(val);
a(4) = median(val);
a(5) = std(val);
end