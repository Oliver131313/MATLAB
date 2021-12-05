%% ***Ucitelov*** script na cvicenie 02

% spocita objem a povrch kocky s hranou lubovolnej velkosti, ktoru zada
% uzivatel
% Tento komentar sa bude/nebude zobrazovat v napovede?

clear       %zmaze vsetky premenne z Workspace
close all   %zavrie vsetky okna (obrazky)
clc         %vymaze historiu prikazov/vypisu z Command Window

%% Blok 2: inicializacia klucovych premennych
%Potrebujem poznat hodnotu dlzky hrany kocky...
% (i) bud ju definujem priamo v skripte
% a = 10.123;
% (ii) alebo necham uzivatela, aby ju zadal
a = input('Zadaj dlzku hrany kocky \n(zadaj ako cislo a stlac Enter):\n')
% a rovno moze zadat aj v akych jednotkach ta hodnota je
jednotka = input('Zadajte este v akych jednotkach uvadzate dlzku hrany kocky:\n', 's')

%% Blok 3: Spocitam vysledky
% spocitam objem kocky podla vzorca V = a^3
V = a^3;

% spocitam povrch kocky podla vzorca S = 6*a^2
S = 6 * a^2;

%% Blok 4: prezentacia vysledkov
%{ 
Toto je jednoduchy neformatovany vystup na obrazovku pomocou funkcie disp()
 a zaroven ukazka komentaru na viacero riadkov
%}
% disp(['Dlzka hrany kocky: a = ', num2str(a)])   % num2str zmeni cislo na string aby ich bolo mozne spojit do riadku
% disp(['Objem kocky: V = ', num2str(V)])
% disp(['Plocha kocky: S = ', num2str(S)])        % disp() zial dava iba neformatovane vystupy (NEPRAKTICKE)!

% Toto je ina alternativa vypisu na obrazovku, formatovany (=krajsi) vypis
fprintf('Pre dlzku hrany kocky a = %.2f %s som spocital:\n objem kocky: \tV = %.3f %s ^3\n povrch kocky: \tS = %.3f %s ^2\n',...
        a, jednotka, V, jednotka, S, jednotka)    % Na konci je fajn dat spatne lomitko lebo inak mam na konci vystupu >>

%% Blok 5: prezentacia grafickych vystupov
%vykreslim si obrazok, ktory bude zobrazovat ako sa vyvija objem a povrch
%kocky pre rozne dlzky hrany od 1 do hodnoty zadanej uzivatelom
vek_a = 1:ceil(a);        % Zaokruhli vrchnu hranicu na najblizsie velke cislo 
                              % (napr. ak mame 5.2, tak to skonci na 5 (matematicke zaokruhlenie)a to nechceme)

%vytvorime si vektor s hodnotami dlzky hrany (celociselne hodnoty od 1 po
%hodnotu premennej hrana)
vek_V = vek_a.^3;             % Operacia s vektorom po prvkoch vyzaduje .
vek_S = 6. * vek_a.^2;        % Ak nasobim skalarom tak bodku davat nemusim (ale mozem)

figure
plot(vek_a, vek_V)
hold on
plot(vek_a, vek_S)

xlabel('Dlzka hrany (a)')
ylabel('Objem/Povrch kocky')
title('Vyvoj objemu a porvrchu kocky pre rozne dlzky hrany')
legend(sprintf('Objem (V) v %s^3', jednotka'), sprintf('Povrch (S) v %s^2', jednotka))
grid                         % Mriezka
%% Blok 6: ukladanie dat
%ulozim VYBRANE premenne do Matlabovskeho datoveho suboru (.mat)
save('DataCvicenie2.mat', 'a', 'jednotka', 'V', 'S')
% Pridanie do uz ulozeneho datasetu - najlepsia moznost
% ?

%ulozim VSETKY premenne do Matlabovskeho datoveho suboru (.mat)
save('DataCvicenie2.mat')

% vymazem si workspace a nahram data z .mat file naspat
clear 
load('DataCvicenie2.mat')