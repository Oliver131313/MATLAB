function table = table_agr(table1, f)
% Argumenty: table1 = tabulka o 4 stlpcoch; f = "mean" alebo "sum"
% Vezme statistiky timu pre domace zapasy a vonkajsie zapasy, spriemeruj/scita 
% pocet golov/pocet bodov a spoji do jednej agregovanej tabulky
if f == "mean" 
    func = @(p, q) [mean(p), mean(q)];
    % Group_by + mean - Domace statistiky
    [group, id] = findgroups(table1(:, 1));
    home = splitapply(func, table1(:, 3), table1(:,4), group);
    h_agr = array2table([table2array(id), string(home)],...
        'VariableNames', {'Team', 'h_scored', 'h_conc'});
    
    % Group_by + mean - Vonkajsie statistiky
    [group, id] = findgroups(table1(:, 2));
    away = splitapply(func, table1(:, 4), table1(:, 3), group);
    a_agr = array2table([table2array(id), string(away)],...
        'VariableNames', {'Team', 'a_scored', 'a_conc'});
    
    % Spojenie - Domace aj vonkajsie statistiky pre kazdy tim, ktory figuroval
    % v PL od sezony 2010/2011
    table1 = join(h_agr, a_agr, 'Keys', 'Team');
    table1.Properties.VariableNames = {'Team', 'h_scored', 'h_conc', 'a_scored', 'a_conc'};
    % Transformacia spat na double
    table1.h_scored = double(table1.h_scored);
    table1.h_conc = double(table1.h_conc);
    table1.a_scored = double(table1.a_scored);
    table1.a_conc = double(table1.a_conc);
    table = sortrows(table1, 'Team', 'ascend'); % Zoradene podla abecedy
    
elseif f=="sum"
    
    func = @(p) [sum(p)];
    % Group_by + mean - Domace statistiky
    [group, id] = findgroups(table1(:, 1));
    home = splitapply(func, table1(:, 3), group);
    h_agr = array2table([table2array(id), string(home)],...
        'VariableNames', {'Team', 'h_points'});
    
    % Group_by + mean - Vonkajsie statistiky
    [group, id] = findgroups(table1(:, 2));
    away = splitapply(func, table1(:, 4), group);
    a_agr = array2table([table2array(id), string(away)],...
        'VariableNames', {'Team', 'a_points'});
    
    % Spojenie - Domace aj vonkajsie statistiky pre kazdy tim, ktory figuroval
    % v PL od sezony 2010/2011
    table1 = join(h_agr, a_agr, 'Keys', 'Team');
    table1.Properties.VariableNames = {'Team', 'h_points', 'a_points'};

    % Transformacia spat na double
    table1.h_points = double(table1.h_points);
    table1.a_points = double(table1.a_points);
    table = sortrows(table1, 'Team', 'ascend'); % Zoradene podla abecedy
end

% % Group_by + mean - Domace statistiky
% [group, id] = findgroups(table1(:, 1));
% home = splitapply(func, table1(:, 3), table1(:,4), group);
% h_agr = array2table([table2array(id), string(home)],...
%   'VariableNames', {'Team', 'h_scored', 'h_conc'});
% 
% % Group_by + mean - Vonkajsie statistiky
% [group, id] = findgroups(table1(:, 2)); 
% away = splitapply(func, table1(:, 4), table1(:, 3), group);
% a_agr = array2table([table2array(id), string(away)],...
%   'VariableNames', {'Team', 'a_scored', 'a_conc'});
% 
% % Spojenie - Domace aj vonkajsie statistiky pre kazdy tim, ktory figuroval
% % v PL od sezony 2010/2011
% table1 = join(h_agr, a_agr, 'Keys', 'Team');
% table1.Properties.VariableNames = {'Team', 'h_scored', 'h_conc', 'a_scored', 'a_conc'};
% % Transformacia spat na double
% table1.h_scored = double(table1.h_scored);
% table1.h_conc = double(table1.h_conc);
% table1.a_scored = double(table1.a_scored);
% table1.a_conc = double(table1.a_conc);
% table = sortrows(table1, 'Team', 'ascend') % Zoradene podla abecedy
end