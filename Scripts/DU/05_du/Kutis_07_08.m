%% HW Kutis, kap. 7, pr. 8
close all
clear all
clc

% Create a string array that contains pet types, e.g.,
pets = ["cat" "dog" "gerbil"];
% Show the difference in the following methods of indexing into the first two strings:
pets(1:2)           % Vyberie prve dva prvky vektoru ako 1x2 string array
pets{1:2}           % "Rozbali" dane hodnoty vektoru postupne od prveho ku druhemu do char formatu
[p1 p2] = pets{1:2} % Rozbalene hodnoty podla poradia spoji do jedneho char vektoru/formatu


