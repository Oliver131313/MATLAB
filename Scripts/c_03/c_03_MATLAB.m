% Toto je skript k 2. cviceniu zo Zakladov Matlabu, tento skript spocita
% objem a povrch kocky s hranou lubovolnej velkosti, ktoru zada uzivatel
% Tento komentar sa zaroven bude zobrazovat v napovede ku skriptu
% (t.j. po zavolani prikazu "help Cvicenie02")

clear       %zmaze vsetky premenne z Workspace
close all   %zavrie vsetky okna (obrazky)
clc         %vymaze obsah Command Window

%% Blok 2: inicializacia klucovych premennych
%Potrebujem poznat hodnotu dlzky hrany kocky
% (i) bud ju definujem v skripte
% hrana = 9;

% (ii) alebo necham uzivatela, aby ju zadal (pomocou funkcie input())
hrana = input('Zadajte dlzku hrany kocky \n(zadajte ako cislo a potom stlacte enter):\n');

%% Blok 2.1: Skontrolujeme, ci pri inpute spravil chybu - Takto kontrolujeme raz, no moze urobit chybu znovu
% if isempty(hrana)
%     fprintf('Nezadal si ziadnu hodnotu ty somarik! Prosim zadaj nejake cislo:\n');
%     hrana = input('Zadajte dlzku hrany kocky \n(zadajte ako cislo a potom stlacte enter):\n');
% elseif hrana <= 0 
%     fprintf('Zadal si hodnotu mensiu alebo rovnu 0! Moze byt hrana kocky negativna alebo nulova ty trulo?: \n');
%     hrana = input('Zadajte dlzku hrany kocky \n(zadajte ako cislo a potom stlacte enter):\n');
% else 
%     disp('Dakujem pane! ... Pocitam objem a povrch kocky.')
% end

%% Blok 2.2: Takto skontrolujeme, ci urobil chybu a budeme ho promptovat kym nas nepochopi
while isempty(hrana) | hrana <= 0
    fprintf('Bud si zadal hodnotu <= 0 alebo si nezadal nic. Oprav to!\n')
    hrana = input('Zadajte dlzku hrany kocky \n(zadajte ako cislo a potom stlacte enter):\n');
end

%a rovno moze zadat aj v akych jednotkach ta hodnota je
jednotka = input('Zadajte este v akych jendotkach uvadzate dlzku hrany kocky:\n','s');
%% Blok 3: Spocitam vysledky
% spocitam objem kocky podla vzorca V = a^3
objem = hrana^3;

% spocitam povrch kocky podla vzorca S = 6*a^2
povrch = 6*hrana^2;

%% Blok 4: prezentacia vysledkov
%{
Toto je jednoduchy neformatovany vystup na obrazovku pomocou funkcie disp()
 a zaroven ukazka komentaru na viacero riadkov
%}
disp(['Toto je dlzka hrany kocky: ', num2str(hrana), ' v cm.'])
disp(['Toto je objem kocky: ', num2str(objem) ' v cm^3.'])
disp(['Toto je povrch kocky: ', num2str(povrch) ' v cm^2.'])


% Toto je ina alternativa vypisu na obrazovku, formatovany (=krajsi) vypis
fprintf('\nPre dlzku hrany kocky %.2f %s som spocital\n objem kocky: %.2f %s^3 \n povrch kocky: %.2f %s^2 \n',...
    hrana,jednotka,objem,jednotka,povrch,jednotka)

%% Blok 5: prezentacia grafickych vystupov
%vykreslim si obrazok, ktory bude zobrazovat ako sa vyvija objem a povrch
%kocky pre rozne dlzky hrany od 1 do hodnoty zadanej uzivatelom

%vytvorime si vektor s hodnotami dlzky hrany (celociselne hodnoty od 1 po
%hodnotu premennej hrana)
os_x=1:hrana;

objem_v = objemkocky(os_x);      %hodnoty objemu pre rozne dlzky hrany
povrch_v=6.*os_x.^2;    %hodnoty povrchu pre rozne dlzky hrany

figure %otvori nove prazdne okno pre graficke vystupy
plot(os_x,objem_v,'r-*')    %vykresli hodnoty objemu kocky
%'r-*': 'r' nastavi farbu ciary na cervenu,
%'-' nastavi zobrazovanu ciaru ako plnu ciaru,
%'*' prida znak * pre vykreslene body.
hold on %umozni vykreslovat dalsie ciary do rovnakeho obrazku
plot(os_x,povrch_v,'g--+')  %vykresli hodnoty povrchu kocky
%'g--+': 'g' nastavi farbu ciary na zelenu,
%'--' definuje ciaru ako prerusovanu,
%'+' prida znak plus pre vykreslene body.

%zmenim rozsah osi x (podobne by slo zmenit rozsah osi y prikazom "ylim")
xlim([0.5 hrana+0.5])

%pridam popisky osi x a y
xlabel(sprintf('Velkost hrany kocky (pre max. hranu dlzky %.2f)', hrana))
% funkcia "sprintf" funguje podobne ako "fprintf", ale vysledny
% formatovany text nevypise na obrazovku, ale "ulozi" ako textovy
% retazec => mozno ju pouzivat ako argument inych funkcii vyzadujucich
% vstup vo forme textoveho retazca, napr. xlabel, title, legend a pod.
ylabel('Objem/povrch kocky')

%pridam titulok grafu
title('Moj prvy graf - vyvoj objemu a povrchu kocky pre rozne dlzky hrany')

%pridam legendu do grafu
legend(sprintf('Objem kocky (v %s^3)',jednotka),sprintf('Povrch kocky (v %s^2)',jednotka))

%pridam mriezku
grid

%ulozim VYBRANE premenne do Matlabovskeho datoveho suboru (.mat)
%varianta 1
save DataCvicenie2.mat hrana jednotka objem povrch
%varianta 2 (ina syntax, inak ekvivalentne)
save('DataCvic2.mat', 'hrana', 'jednotka', 'objem', 'povrch');

%ulozim VSETKY premenne do Matlabovskeho datoveho suboru (.mat)
save DataCvicenie2.mat

% vymazem si workspace a nahram data z .mat file naspat
clear
load DataCvicenie2.mat
