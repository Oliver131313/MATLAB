% Toto je skript k 4. cvièeniu. Tento skript vylepsuje skript z predosleho
% tyzdna zavedenim cyklov (for a while).

clear       %zmaze vsetky premenne z Workspace
close all   %zavrie vsetky okna (obrazky)
clc         %vymaze historiu prikazov/vypisu z Command Window

%% Inicializacia klucovych premennych
%Potrebujem poznat hodnotu dlzky hrany kocky...
%bud ju definujem v skripte
% hrana = 9;

%...alebo necham uzivatela, aby ju zadal
hrana=input('Zadajte dlzku hrany kocky \n(zadajte ako cele cislo a potom stlacte enter):\n');

%% Skontrolujme, ze uzivatel chape, co po nom chceme
% jedno rozvetvenie pre nespravne hodnoty

% if isempty(hrana) %ak nezadal ziadnu hodnotu, pekne ho poprosime, aby nieco zadal
%     fprintf('Nezadali ste ziadnu hodnotu, prosim najprv zadajte hodnotu, a potom stlacte Enter.\n\n')
%     hrana=input('Zadajte dlzku hrany kocky \n(zadajte ako cislo a potom stlacte Enter):\n');
% elseif hrana<0 %ak zadal zaporne cislo
%     fprintf('No, no, no! Zadali ste: %.2f.\n Dlzka hrany kocky nemoze byt zaporne cislo!\n\n',hrana)
%     hrana=input('Zadajte dlzku hrany kocky \n(zadajte ako kladne cislo a potom stlacte Enter):\n');
% elseif hrana==0  %zostava nam moznost, ze zadana dlzka hrany kocky je 0, potom ale nemusime nic pocitat
%     fprintf('\nAk je dlzka hrany kocky %1.0f, takato kocka nema ziadny objem ani povrch. Skuste zadat nejaku kladnu hodnotu.\n',...
%         hrana)
%     hrana=input('Zadajte dlzku hrany kocky \n(zadajte ako kladne cislo a potom stlacte Enter):\n');
% else
%     % v ostatnych pripadoch je dlzka hrany kocky kladne cislo, takze
%     % spocitame objem a povrch
%     fprintf('Dakujem! Pocitam objem a povrch kocky.\n')
% end
% % a este chceme vediet v akych jednotkach ta hodnota je
% jednotka=input('\nZadajte este v akych jednotkach uvadzate dlzku hrany kocky:\n','s');
% % spocitam objem kocky pomocou funkcie "objemkocky"
% objem = objemkocky(hrana);
% % spocitam povrch kocky podla vzorca S = 6*a^2
% povrch = 6*hrana^2;
% % prezentacia vysledkov
% fprintf('\nPre dlzku hrany kocky %.2f %s som spocital\n objem kocky: %.2f %s^3 \n povrch kocky: %.2f %s^2 \n',...
%     hrana,jednotka,objem,jednotka,povrch,jednotka)


%% Kontrolu musime robit opakovane po kazdom zadani (skuste pri predoslom kode zada� 2-krat po sebe zaporne cislo)
% aplikujeme cyklus, kedze nevieme, kolkokrat uzivatel zada hodnotu
% nespravne, pouzijeme while cyklus:

count = 0;
while (isempty(hrana) || hrana <= 0)
    fprintf('Bud si zadal hodnotu <= 0 alebo si nezadal nic. Oprav to!\n')
    count = count + 1;
    if count >= 6
        hrana = randi(10);
        fprintf('\nSi imbecil? Musim tu hranu zadat za teba!...Hrana kocky: %5.2f', hrana)
    else 
        hrana = input('Zadajte dlzku hrany kocky \n(zadajte ako cislo a potom stlacte enter):\n');
    end
end

if count < 3
    disp('\nDiky moc! Pocitam objem kocky...')
elseif count >= 3 && count < 6
    fprintf('\nTo bol porod kamo...dik. Pocitam objem kocky')
end

jednotka = input('\nZadajte este v akych jednotkach uvadzate dlzku hrany kocky:\n','s');
% spocitam objem kocky pomocou funkcie "objemkocky"
objem = objemkocky(hrana);
% spocitam povrch kocky podla vzorca S = 6*a^2
povrch = 6*hrana^2;
% prezentacia vysledkov
fprintf('\nPre dlzku hrany kocky %.2f %s som spocital\n objem kocky: %.2f %s^3 \n povrch kocky: %.2f %s^2 \n',...
    hrana,jednotka,objem,jednotka,povrch,jednotka)


%% Prezentacia grafickych vystupov
%vykreslim si obrazok, ktory bude zobrazovat ako sa vyvija objem a povrch
%kocky pre rozne dlzky hrany od 1 do hodnoty zadanej uzivatelom

%vytvorime si vektor s hodnotami dlzky hrany (celociselne hodnoty od 1 po
%hodnotu premennej hrana)
os_x=1:hrana;

objem_v = objemkocky(os_x); %hodnoty objem pre rozne dlzky hrany
povrch_v=6.*os_x.^2; %hodnoty povrchu pre rozne dlzky hrany

figure %otvori nove prazdne okno pre graficke vystupy
subplot(2, 1, 1)
plot(os_x,objem_v,'r-*')    %vykresli hodnoty objemu kocky
%'r-*': 'r' nastavi farbu ciary na cervenu,
%'-' nastavi zobrazovanu ciaru ako plnu ciaru,
%'*' prida znak * pre vykreslene body.


%pomenujem osi
xlabel(sprintf('Velkost hrany kocky (pre max. hranu dlzky %.2f)', hrana))
ylabel('Objem/povrch kocky')
%pridam titulok grafu
title('Vyvoj objemu kocky pre rozne dlzky hrany')
%pridam legendu do grafu
legend(sprintf('Objem kocky (v %s^3)',jednotka))
%pridam mriezku
grid

subplot(2, 1, 2)
plot(os_x,povrch_v,'g--+')  %vykresli hodnoty povrchu kocky
%'g--+': 'g' nastavi farbu ciary na zelenu,
%'--' definuje ciaru ako prerusovanu,
%'+' prida znak plus pre vykreslene body.

%zmenim rozsah osi x
xlim([0.5 hrana+0.5])
%pomenujem osi
xlabel(sprintf('Velkost hrany kocky (pre max. hranu dlzky %.2f)', hrana))
ylabel('Objem/povrch kocky')
%pridam titulok grafu
title('Vyvoj povrchu kocky pre rozne dlzky hrany')
%pridam legendu do grafu
legend(sprintf('Povrch kocky (v %s^2)',jednotka))
%pridam mriezku
grid

% linkaxes - vsetky osy budu na rovnakej skale
linkaxes




% %ulozim VYBRANE premenne do Matlabovskeho datoveho suboru (.mat)
% %varianta 1
% save DataCvicenie2.mat hrana jednotka objem povrch
% %varianta 2 (ina syntax)
% save('DataCvic2.mat', 'hrana', 'jednotka', 'objem', 'povrch');
%
%
% %ulozim VSETKY premenne do Matlabovskeho datoveho suboru (.mat)
% save DataCvicenie2.mat
%
% % vymazem si workspace a nahram data z .mat file naspat
% clear
% load DataCvicenie2.mat %hrana


