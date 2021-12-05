% --------------- Spustaj jednotlive prikazy cez command line -----------
% '%' sluzi na komentovanie kodu

% % Delete whole workspace
clear all

% % Vypis text
disp('hello world') 

% % Moznost vypisat holy text zadanim 'string' do command window ale ulozi
% % to do default premennej "ans"

% % Napoveda skrz - help *funkcia* v command window, alebo CTRL + F1 pre krajsiu a plnsiu dokumentaci

% % Nepomenuvat premenne, ktore zacinaju cislom (musia zacinam pismenom -
% % je to CASE sensitive)

% % Samozrejme nazvy premennych (viacslovne) oddelovat '_' - napr.
% % moja_premenna alebo mozno pouzit aj MojaPremenna

% % Umocnovanie strieskou ^
moja_premenna = 5^2

% % Prikazy sa ukoncuju bodkociarkou (strednik - ;) a v command windowe
% % sluzi podkociarka na potlacenie vystupu (je to dobre, pretoze ak by mal
% % command window vyhodnocovat kazdy jeden prikaz tak to velmi spomaluje
% % chod programu

% % Porovnanie ci sa dve hodnoty rovnaju pomocou == (vystupom je logicka 0
% % alebo 1 - zaujimavostou je, ze vsetky numericke hodnoty vacsie alebo rovne 1 su povazovane za logicku 1)
d = 5
f = 6
logic_d_f = d == 6 % Vystup: logical 0

% % Pre nerovna sa: ~=
% % Vacsie rovne ...atd: >=, >, <=, <

% % Vektor
vektor = [1, 2, 3, 4, 5]
% alebo
vektor = [1 2 3 4 5] % Moznost dva pristupy kombinovat ale pre citatelnost sa neodporuca

% % Stlpcovy vektor
s_vektor = [1; 2; 3; 4; 5]
% alebo
s_vektor = [1
    2
    3
    4
    5] 

% Matica
matica = [1 2
    3 4
    8 9]

% alebo 
matica = [1, 2; 3, 4; 5, 6]

% % Nasepkavac zapnes tabulatorom (nasepkava ako dokoncit pisane slovo)

% % Indexovanie - riadok, stlpec
matica(2, 1)
% Riadky ktore ma zaujimaju a stlpec
matica([1, 2, 3], 1)
% Vsetky stlpce a prvy riadok - : - dvojbodka sluzi ako chcem vsetko, v
% tomto pripade chcem vsetky stlpce a prvy riadok
matica(1, :)

% % Prazdna matica
prazdna_mat = []

% % Postupny vektor 1 az 20
post_vektor = [1:20]

% % Postupny vektor s krokom - druha suradnica je ten krok
post_vektor = [1:0.5:10]

% % Viem zaciatocny a koncovy bod ale neviem kroky no viem jeho velkost
% 15 cisel medzi jedna a 10 s rovnakou vzdialenostou medzi nimi
linspace(1, 10, 15)

% Precitaj si kapitoly 1 a 2 (ak chces mozes aj 3)
% Na konci kazdej kapitoly su exercises - takze ich mozes prejst aby si sa
% zlepsil :D













