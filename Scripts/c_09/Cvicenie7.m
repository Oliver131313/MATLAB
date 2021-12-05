%% Skript k cvièeniu 7 - BPE_ZMAT
% vytvaranie pokrocilych funkcii a úvod do objektovo-orientovaneho
% programovania(OOP)
clear
close all
clc


%% Cast I - Tvorba a praca s pokrocilymi uzivatelskymi funkciami
% function function a využitie function handle (viï fnfn.m)
fnfn(@cos)
fnfn(@cos, [-2*pi, pi])
graph_abs = fnfn(@abs, [-25, 10])

% priklad anonymnej funkcie
% nazov_funkcie = @(vstup1, vstup2) zapis_funkcie;
funkcehodnoty = @(x, fn) fn(x);
vystup_anonym = funkcehodnoty(-pi, @tan) 
% Ked ten graf rozkliknem vo workspace ('graph_abs') dostanem sa na web rozhranie s moznostou
% upravovat graficke parametre grafu - Pozor musi byt otvoreny aj samotny
% graf


%% Cast II - Uvod do OOP, grafy a ich uprava
% práca s grafmi ako objektmi (viï FigSize.m a SaveFigure.m)
properties(graph_abs);
methods(graph_abs)


% zmenme hodnoty rozsahu osi velkost okna, v ktorom sa zobrazuje graf
get(graph_abs, 'Color')
set(graph_abs, 'Color', [1, 0.5, 0.5])

graph_abs.Color = [0.25, 0.65, 0];
graph_abs.LineWidth = 5;
graph_abs.LineStyle = ':';

% alternativne funkcia gcf (get current figure) vrati handle pre aktualny
% (=posledny aktivny) obrazok


% alternativne funkcia gca (get current axes) vrati handle pre osi
% aktualneho (=posledneho aktivneho) obrazku


% ked sme s grafom spokojny, mozeme graf ulozit (vid napr. externa funkcia SaveFigure.m)
SaveFigure('./moj_xty_graf')


%% BONUS - Tvorba vlastnych tried, inicializacia objektov, a definovanie specifickych funkcii na objektoch tychto tried
% (vid pes.m)

% Komisar_Rex=pes('Rex','Chytá hamburgery a zloèincov','German shepherd')
% 
% Haciko=pes('Hachiko', 'Trpezlivos�', 'Akita Inu', 'Hidesaburó Ueno');
% 
% moj_ovciak=Komisar_Rex;
% moj_ovciak.Name='Rhea';
% moj_ovciak.Superpower='Nosí kamene z rieky.';
% moj_ovciak.Owner='Guess who';
% 
% 
% % skúsime ako funguje funkcia, ktorú sme si definovali špeciálne pre
% % objekty triedy pes (Pozor: stlmte si zvuk! :) )
% najdi_ovciaka(Haciko);
% najdi_ovciaka(moj_ovciak);
% 

