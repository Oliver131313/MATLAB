%% MATLAB projekt - vypocet konecneho poradia sucasnej sezony Premier League (21/22) z minulych sezon
clear
close all
clc

%% Nacitanie dat

% Nacitanie odohranych zapasov
played = readtable('pl_played.csv');
% Obmedzenie dat na poslednych 10 sezon
played = played(played.date >= '2010-08-14', 2:end)
played_col_names = played.Properties.VariableNames;

% Nacitanie neodohranych zapasov (sezona 21/22)
n_played = readtable('pl_played.csv');
n_played(:, 'Var1') = [];
n_played_col_names = n_played.Properties.VariableNames;

%% Vypocet priemerov pre domace a vonkajsie statistiky skorovanych a inkasovanych golov
% anonymna funkcia na priemerovanie vybranych stlpcov
func = @(p, q) [mean(p), mean(q)];

% Group_by + mean - Domace statistiky
[group, id] = findgroups(played.h_Team);
home = splitapply(func, played.h_scored, played.a_scored, group);
h_agr = array2table([id, string(home)],...
  'VariableNames', {'Team', 'h_scored', 'h_conc'});

% Group_by + mean - Vonkajsie statistiky
[group, id] = findgroups(played.a_Team; 
away = splitapply(func, played.a_scored, played.h_scored, group);
a_agr = array2table([id, string(away)],...
  'VariableNames', {'Team', 'a_scored', 'a_conc'});

% Spojenie - Domace aj vonkajsie statistiky pre kazdy tim, ktory figuroval
% v PL od sezony 2010/2011
played_agr = join(h_agr, a_agr, 'Keys', 'Team')
played_agr.Properties.VariableNames = {'Team', 'h_scored', 'h_conc', 'a_scored', 'a_conc'};
% Transformacia spat na double
played_agr.h_scored = double(played_agr.h_scored);
played_agr.h_conc = double(played_agr.h_conc);
played_agr.a_scored = double(played_agr.a_scored);
played_agr.a_conc = double(played_agr.a_conc);



