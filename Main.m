function [] = main24_10_23()
clc;
clear;
close all
warning off
addpath('Datasets');

No_of_Task = [1, 2, 3, 4, 5];
No_of_VM = [500, 600, 700, 800, 900];

%% Variable Initialization
an = 0;
if an == 1
    for i = 1:5
        Param(i).Available_Memory  = randi([100, 250], 5000, 1); %GB
        Param(i).Available_CPU = randi([20, 40], 5000, 1);
        Param(i).processing_Time = randi([5, 10], 5000, 1);
        Param(i).Reaction_Time = randi([1, 5], 5000, 1);
        Param(i).CPU_Clock_Speed =  7.8 + (9.6-7.8).*rand(5000,1); %GHz
        Param(i).Memory_Requirement = randi([1, 2], 5000, 1); %GB
        Param(i).CPU_Requirement = 0.7 + (0.9-0.7).*rand(5000, 1);
        Param(i).Priority = randi([1, 5], 5000, 1);
        Param(i).Completion_Time = randi([0, 1400], 5000, 1);
        Param(i).Data = [Param(i).Available_Memory Param(i).Available_CPU Param(i).processing_Time Param(i).Reaction_Time Param(i).CPU_Clock_Speed Param(i).Memory_Requirement Param(i).CPU_Requirement Param(i).Completion_Time];        
        Param(i).Target = randi([0, 1], 5000, 1);        
    end
    save Param Param
end

%% Optimization for Resource Allocation
an = 0;
if an == 1
    load Param
    for i = 1:5
        Npop = 10;
        Chlen = size(No_of_Task,2);
        xmin = ones(Npop, Chlen);
        xmax = No_of_VM(i).*ones(Npop, Chlen);
        initsol = unifrnd(xmin, xmax);
        fname = 'obj_Res';
        itermax = 250;
                       
        [bestfit, fitness, bestsol, time] = ESOA(initsol, fname, xmin, xmax, itermax);         
        Eso(i).bf = bestfit;  Eso(i).fit = fitness;  Eso(i).bs = bestsol;  Eso(i).ct = time;
        save Eso Eso
        
        [bestfit, fitness, bestsol, time] = CO(initsol, fname, xmin, xmax, itermax);    
        Co(i).bf = bestfit;  Co(i).fit = fitness;  Co(i).bs = bestsol;  Co(i).ct = time;
        save Co Co
        
        [bestfit, fitness, bestsol, time] = WaOA(initsol, fname, xmin, xmax, itermax);
        Waoa(i).bf = bestfit;  Waoa(i).fit = fitness;  Waoa(i).bs = bestsol;  Waoa(i).ct = time;
        save Waoa Waoa
        
        [bestfit, fitness, bestsol, time] = LO(initsol, fname, xmin, xmax, itermax);           
        Lo(i).bf = bestfit;  Lo(i).fit = fitness;  Lo(i).bs = bestsol;  Lo(i).ct = time;
        save Lo Lo
        
        [bestfit, fitness, bestsol, time] = PROPOSED(initsol, fname, xmin, xmax, itermax);        
        Prop(i).bf = bestfit;  Prop(i).fit = fitness;  Prop(i).bs = bestsol;  Prop(i).ct = time;
        save Prop Prop
    end
end

Plot_Results()
close all;
end