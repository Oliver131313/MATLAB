%% MATLAB projekt - vypocet konecneho poradia sucasnej sezony Premier League (21/22) z minulych sezon
% Nutne poznamenat: Na to aby bol tento script odolny voci chybam ostatnych
% obdobi je nutne zadat este niekolko podmienok. Primarnym cielom tohto
% skriptu je dosimulovat sucasnu sezonu. Pre platnost aj do buducna, by
% bolo nutne aby sa zohladnilo, ze nejaky tim nebude sucastou dalsej este
% nehranej sezony alebo nebol sucastou tej minulej. Teraz to bude fungovat, pretoze dany tim uz je sucastou
% novej sezony, nakolko odohral nejake zapasy a disponuje statisitkami.
clear
close all
clc
%% DOROBIT - Pre timy, ktore nehrali v PL minulu sezonu by sme na simulovanie vysledkov tej buducej mohli zobrat
% domace a vonkajsie priemery poslednych 7 timov v minulej sezone a priradit im ich na simulaciu tej buducej.
% Samozrejme, nie je to uplne vedecky pristup ale pri pohlade do minulosti je jasne, ze novacikovia neokupuju
% popredne priecky hned v 1. sezone. To, ze budeme brat priemery poslednych 7 timov je z pohladu cloveka, ktory
% sleduje futbal pomerne rozumny predpoklad.

%% Spusti Python script, ktory aktualizuje data - Simulacia teda bezi v real-time 
system('python PL_matches.py')

%% Nacitanie dat
% Nacitanie odohranych zapasov
played = readtable('pl_played.csv');
played = played(:, [1, 5, 7, 12, 13]);
% Vsetky odohrane zapasy z poslednych 2 sezon (vratane tej sucasnej
% nedohranej)
played_all = played(:, 2:5);
% played = played(:, [5, 7, 12, 13]);
played_all_col_names = played_all.Properties.VariableNames;

disp(played_all(1:10, :))

% Nacitanie neodohranych zapasov (sezona 21/22)
n_played = readtable('pl_not_played.csv');
n_played = n_played(:, ["date","h_Team", "a_Team"]);
n_played_col_names = n_played.Properties.VariableNames;

disp(n_played(1:10, :)) 

func = @(p, q) [mean(p), mean(q)];
% Group_by + mean - Domace statistiky
[group, id] = findgroups(played_all(:, 1));
home = splitapply(func, played_all(:, 3), played_all(:,4), group);
h_agr = array2table([table2array(id), string(home)],...
  'VariableNames', {'Team', 'h_scored', 'h_conc'});

%% Vypocet priemerov pre domace a vonkajsie statistiky skorovanych a inkasovanych golov
played_all_agr = table_agr(played_all, "mean");

% Tabulka pre sucasnu sezonu
this_season = played(played.season == 2, 2:5);
h_pts = zeros(length(this_season.h_Team), 1);
a_pts = zeros(length(this_season.h_Team), 1);
for i = 1:length(this_season.h_Team)
    if this_season{i, 3} > this_season{i, 4}
        h_pts(i) = 3;
        a_pts(i) = 0;
    elseif this_season{i, 3} == this_season{i, 4}
        h_pts(i) = 1;
        a_pts(i) = 1;
    else
        h_pts(i) = 0;
        a_pts(i) = 3;
    end
end

this_season_agr = this_season(:, 1:2);
this_season_agr.h_points = h_pts;
this_season_agr.a_points = a_pts;
this_season_agr = table_agr(this_season_agr, "sum");
this_season_agr.Points = this_season_agr.h_points + this_season_agr.a_points;
%% Koresponduju vstrelene goly v zapase s Poissonovym rozdelenim?
subplot(3, 1, 1)
histfit(played_all.h_scored, 10, 'Poisson')
subplot(3, 1, 2)
histfit(played_all.a_scored, 10, 'Poisson')
subplot(3, 1, 3)
histfit(played_all.h_scored + played_all.a_scored, 10, 'Poisson')
% Goly priblizne zodpovedaju Poisson rozdeleniu

%% Simulacia
% Pocet simulacii
S = 100;
N_zapasy = size(n_played, 1);
N_Teams = size(unique(n_played.h_Team), 1);
Team_sim_points = zeros(N_Teams, S);
size(Team_sim_points)

for s = 1:S
    h_points = zeros(N_zapasy, 1);
    a_points = zeros(N_zapasy, 1);
    h_s_calc = zeros(S, 1);
    a_s_calc = zeros(S, 1);
    % Pre kazdy zapas vygeneruje vysledok
    for i = 1:N_zapasy
        h_t = char(n_played{i, "h_Team"});
        a_t = char(n_played{i, "a_Team"});
        % Potrebne priemery na kalkulaciu inkasovanych a vsietenych golov
        h_scored = table2array(played_all_agr(strcmp(played_all_agr.Team, h_t), "h_scored"));
        h_conc = table2array(played_all_agr(strcmp(played_all_agr.Team, h_t), "h_conc"));
        a_scored = table2array(played_all_agr(strcmp(played_all_agr.Team, a_t), "a_scored"));
        a_conc = table2array(played_all_agr(strcmp(played_all_agr.Team, a_t), "a_conc"));
        % Vygenerovanie nahodneho cisla z Poisson rozdelenia podla
        % jednotlivych priemerov = [r_h_s, r_h_c, r_a_s, r_a_c]
        r = poissrnd([h_scored, h_conc, a_scored, a_conc]);

        % Dane vypocty by mali zohladnovat jednak ofenzivnu silu
        % domacich/hosti a defenzivnu silu hosti/domacich
        h_s_sim = round((r(1) + r(4)) / 2);       % (Domaci_vstrel + Hostia_inkas) / 2
        a_s_sim = round((r(3) + r(2)) / 2);       % (Hostia_vstrel + Domaci_inkas) / 2
        
        % Uloz vypocitane hodnoty golov do vektora
        h_s_calc(i) = h_s_sim;
        a_s_calc(i) = a_s_sim;
        
        % Vysledok
        if h_s_sim > a_s_sim
            h_points(i) = 3;
            a_points(i) = 0;
        elseif h_s_sim < a_s_sim
            h_points(i) = 0;
            a_points(i) = 3;
        else 
            h_points(i) = 1;
            a_points(i) = 1;
        end
    end
    % Pre kazdu simulaciu vytvori simulovane skore, agreguje a urobi
    % tabulku - nasledne sa pocty bodov spriemeruju a vytvori sa
    % nasimulovane poradie pre tuto sezonu
    sim_points = n_played(:, [2, 3]);
    sim_points.h_points = h_points;
    sim_points.a_points = a_points;
    sim_agr = table_agr(sim_points, "sum");
    sim_agr.total = sim_agr.h_points + sim_agr.a_points;
    for ii = 1:size(sim_agr.Team, 1)
        Team_sim_points(ii, s) = sim_agr{ii, 'total'};
    end
end

%% Konecne a priebezne simulovane poradie v sezone 21/22 v PL
% Cela sezona
rank_full = sim_agr(:, 1);
rank_full.Points = round(mean(Team_sim_points, 2));
rank_full.Points = rank_full.Points + this_season_agr.Points;
rank_full = sortrows(rank_full, 'Points', 'descend');
rank_full.Ranking = zeros(height(rank_full), 1);
% Tvorba poradia
x = [];
index = 0;
for i = 1:height(rank_full)
    index = index + 1;
    x(end+1) = index;
end
rank_full.Ranking = x';
rank_full = rank_full(:, [3, 1, 2]);

% Vytvorime tabulku pre zname vysledky sucasnej sezony
this_season_agr.Points = round(this_season_agr.Points, 2);
this_season_agr = sortrows(this_season_agr, 'Points', 'descend');
this_season_agr.Ranking = x';
this_season_agr = this_season_agr(:,  [5, 1, 4]);
%% Vystupna vizualizacia tabuliek
fprintf('\nPremier League 2021/2022.\n')
fprintf('Do dne??n??ho d??a:\n')
disp(this_season_agr)

fprintf('\nSimulovan?? poradie Premier League 2021/2022.\n')
fprintf('Cel?? sez??na:\n')
disp(rank_full)
%% Sekcia pomocnych vypoctov
% func = @(p) [sum(p)];
% % Group_by + mean - Domace statistiky
% [group, id] = findgroups(sim_points(:, 1));
% home = splitapply(func, sim_points(:, 3), group);
% h_agr = array2table([table2array(id), string(home)],...
%     'VariableNames', {'Team', 'h_points'});
% 
% % Group_by + mean - Vonkajsie statistiky
% [group, id] = findgroups(sim_now_points(:, 2));
% away = splitapply(func, sim_now_points(:, 4), group);
% a_agr = array2table([table2array(id), string(away)],...
%     'VariableNames', {'Team', 'a_points'});
% 
% % Spojenie - Domace aj vonkajsie statistiky pre kazdy tim, ktory figuroval
% % v PL od sezony 2010/2011
% sim_now_points = join(h_agr, a_agr, 'Keys', 'Team');
% sim_now_points.Properties.VariableNames = {'Team', 'h_points', 'a_points'};
% 
% % Transformacia spat na double
% sim_now_points.h_points = double(sim_now_points.h_points);
% sim_now_points.a_points = double(sim_now_points.a_points);
% table = sortrows(sim_now_points, 'Team', 'ascend'); % Zoradene podla abecedy
% 
% 
% last_season = played(played.season == 1, :);
% for i = 1:length(unique(n_played.h_Team))
%     if (ismember(n_played.h_Team{i}, last_season.h_Team) | ismember(n_played.h_Team{i}, last_season.a_Team)) == 0
%         disp(n_played.h_Team{i})
%     else
%         disp('None')
%     end
% end     