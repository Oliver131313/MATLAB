%% MATLAB projekt - vypocet konecneho poradia sucasnej sezony Premier League (21/22) z minulych sezon
clear
close all
clc

%% DOROBIT TAK aby simulovalo z dat z predoslej sezony celu sucasnu sezonu a 
% pridat tam pocet bodov z doterajsich vysledkov sezony a k tomu prilepit
% dosimulovany pocet bodov k zvysku tejto sezony (simulacia by mala byt
% zalozena na zapasoch uz odohratych v tejto sezone a na zapasoch z minulej
% sezony !!!
% Bude to vyzadovat:
% - dataset zapasov od minulej sezony az do terajsieho bodu (simulacia
%   zvysku sezony)
%   - z tohto spocitat pocet bodov pre aktualnu sezonu a prilepit ich ku
%   nasimulovanemu poctu bodov neodohratych zapasov tejto sezony
% - dataset zapasov IBA minulej sezony (na simulaciu celej sezony)
%% Spusti Python script, ktory aktualizuje data - Simulacia teda bezi v real-time 
system('python PL_matches.py')

%% Nacitanie dat

% Nacitanie odohranych zapasov
played = readtable('pl_played.csv');
% Obmedzenie dat na poslednych XY sezon
played = played(played.date >= '2020-09-12', [5, 7, 12, 13]);
% played = played(:, [5, 7, 12, 13]);
played_col_names = played.Properties.VariableNames;

disp(played(1:10, :))

% Nacitanie neodohranych zapasov (sezona 21/22)
n_played = readtable('pl_not_played.csv');
% Nutnost vylucit Brentford kvoli nedostupnosti statistik
n_played = n_played(~strcmp(n_played.h_Team, 'Brentford')& ~strcmp(n_played.a_Team, 'Brentford'), ...
                    ["date","h_Team", "a_Team"]);
n_played_col_names = n_played.Properties.VariableNames;

disp(n_played(1:10, :))

func = @(p, q) [mean(p), mean(q)];
% Group_by + mean - Domace statistiky
[group, id] = findgroups(played(:, 1));
home = splitapply(func, played(:, 3), played(:,4), group);
h_agr = array2table([table2array(id), string(home)],...
  'VariableNames', {'Team', 'h_scored', 'h_conc'});


%% Vypocet priemerov pre domace a vonkajsie statistiky skorovanych a inkasovanych golov
played_agr = table_agr(played, "mean")
disp(played_agr(1:10, :))

%% Koresponduju vstrelene goly v zapase s Poissonovym rozdelenim?
subplot(3, 1, 1)
histfit(played.h_scored, 10, 'Poisson')
subplot(3, 1, 2)
histfit(played.a_scored, 10, 'Poisson')
subplot(3, 1, 3)
histfit(played.h_scored + played.a_scored, 10, 'Poisson')
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
        h_scored = table2array(played_agr(strcmp(played_agr.Team, h_t), "h_scored"));
        h_conc = table2array(played_agr(strcmp(played_agr.Team, h_t), "h_conc"));
        a_scored = table2array(played_agr(strcmp(played_agr.Team, a_t), "a_scored"));
        a_conc = table2array(played_agr(strcmp(played_agr.Team, a_t), "a_conc"));
        % Vygenerovanie nahodneho cisla z Poisson rozdelenia podla
        % jednotlivych priemerov = [r_h_s, r_h_c, r_a_s, r_a_c]
        r = poissrnd([h_scored, h_conc, a_scored, a_conc]);
% Neskor zakompnovat vazeny priemer, ktory by sa snazil urcit
% pravdepodobnost vitazstva pri vstreleni/inkasovani golu
% doma/vonku
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
    % V skutocnosti vytvorime dve tabulky - jedna bude simulovat poradie do
    % sucasneho datumu a druha bude simulovat celu sezonu
    sim_points = n_played(:, [2, 3]);
    sim_points.h_points = h_points;
    sim_points.a_points = a_points;
    sim_agr = table_agr(sim_points, "sum");
    sim_agr.total = sim_agr.h_points + sim_agr.a_points;
    for ii = 1:size(sim_agr.Team, 1)
        Team_sim_points(ii, s) = sim_agr{ii, 'total'};
    end
    
%     current_date = datetime('now');
%     sim_now_points = n_played(n_played.date <= current_date, [2, 3]);
%     size_now = size(n_played(n_played.date <= current_date, [2, 3]), 1);
%     sim_now_points.h_points = h_points(1:size_now);
%     sim_now_points.a_points = a_points(1:size_now);
%     sim_now_agr = table_agr(sim_now_points, "sum");
%     sim_now_agr.total = sim_now_agr.h_points + sim_now_agr.a_points;
%     for ii = 1:size(sim_now_agr.Team, 1)
%         Team_now_sim_points(ii, s) = sim_now_agr{ii, 'total'};
%     end
end

%% Konecne a priebezne simulovane poradie v sezone 21/22 v PL
% Cela sezona
rank_full = sim_agr(:, 1);
rank_full.Points = round(mean(Team_sim_points, 2));
rank_full = sortrows(rank_full, 'Points', 'descend');
rank_full.Ranking = zeros(height(rank_full), 1);
% Tvorba poradia
x = []
index = 0
for i = 1:height(rank_full)
    index = index + 1
    x(end+1) = index
end
rank_full.Ranking = x'
rank_full = rank_full(:, [3, 1, 2]);

% Sezona do tejto chvile
rank_now = sim_now_agr(:, 1);
rank_now.Points = round(mean(Team_now_sim_points, 2));
rank_now = sortrows(rank_now, 'Points', 'descend');
rank_now.Ranking = x';
rank_now = rank_now(:, [3, 1, 2]);
%% Vystupna vizualizacia tabuliek
fprintf('\nSimulované poradie Premier League 2021/2022.\n')
fprintf('Do dnešného dňa:\n')
disp(rank_now)
fprintf('Celá sezóna:\n')
disp(rank_full)


%% 
func = @(p) [sum(p)];
% Group_by + mean - Domace statistiky
[group, id] = findgroups(sim_points(:, 1));
home = splitapply(func, sim_points(:, 3), group);
h_agr = array2table([table2array(id), string(home)],...
    'VariableNames', {'Team', 'h_points'});

% Group_by + mean - Vonkajsie statistiky
[group, id] = findgroups(sim_now_points(:, 2));
away = splitapply(func, sim_now_points(:, 4), group);
a_agr = array2table([table2array(id), string(away)],...
    'VariableNames', {'Team', 'a_points'});

% Spojenie - Domace aj vonkajsie statistiky pre kazdy tim, ktory figuroval
% v PL od sezony 2010/2011
sim_now_points = join(h_agr, a_agr, 'Keys', 'Team');
sim_now_points.Properties.VariableNames = {'Team', 'h_points', 'a_points'};

% Transformacia spat na double
sim_now_points.h_points = double(sim_now_points.h_points);
sim_now_points.a_points = double(sim_now_points.a_points);
table = sortrows(sim_now_points, 'Team', 'ascend'); % Zoradene podla abecedy
