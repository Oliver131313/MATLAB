% Toto je skript k 5. cviceniu. Tento skript dokoncuje skript z predoslych
% cviceni, pri vypoctoch vyuziva 2 funkcie:
% 1. funkcia: kontroluje spravnost zadanej hodnoty hrany
% 2. funkcia: pocita objem a povrch

clear       %zmaze vsetky premenne z Workspace
close all   %zavrie vsetky okna (obrazky)
clc         %vymaze historiu prikazov/vypisu z Command Window

%% Inicializacia klucovych premennych
pocet_kociek=randi(5); % Kolko kociek budeme pocitat?
hrana=zeros(pocet_kociek,1); %dopredu alokujeme miesto pre hodnoty hrany kocky
fprintf('Budeme pocitat objem a povrch %d kociek.\n',pocet_kociek)

%% V cykle si spocitame udaje pre viacero kociek, ktorych dlzku hrany uzivatel zada
for ii=1:pocet_kociek
    
    nieje_ok = 1; %premenna, ktora indikuje, ci uzivatel zadal akceptovatelnu
    %hodnotu dlzky hrany kocky (1 - nie je ok, 0 - je ok)
    pocitadlo = 0;
    
    while nieje_ok && pocitadlo<3
        pom = input(sprintf('Zadajte dlzku %d. hrany kocky \n(zadajte ako cele cislo a potom stlacte enter):\n',ii))
        pocitadlo = pocitadlo+1;
        nieje_ok = error_check(pom);
    end   
        
    if pocitadlo==3 && (isempty(pom) || pom<=0)
        pom=randi(10);
        fprintf('Toto vazne nema cenu! Nastavujem hranu kocky na %4.2f!\n',pom);
    else
        disp('Dakujem! Pocitam objem a povrch kocky.')
    end
    hrana(ii) = pom;
    
    %zadana dlzka hrany je kladne cislo
    % potom chceme vediet v akych jednotkach ta hodnota je (staci nam to
    % zadat v prvom behu cyklu)

end

jednotka=input('\nZadajte este v akych jednotkach je uvedena dlzka hrany kocky:\n','s');
[objem, povrch] = objempovrchkocky(hrana);

fprintf('\n Cislo kocky     Dlzka hrany (%s)    Objem (%s^3)    Povrch (%s^2) \n',...
        jednotka, jednotka, jednotka)
fprintf('---------------------------------------------------------------------\n')
for jj = 1:pocet_kociek
    fprintf('%2.f           %8.2f                   %8.2f           %8.2f\n',...
            jj, hrana(jj), objem(jj), povrch(jj))
end
    
%% Prezentacia grafickych vystupov
%vykreslim si obrazok, ktory bude zobrazovat ako sa vyvija objem a povrch
%kocky pre rozne dlzky hrany od 1 do hodnoty zadanej uzivatelom

%vytvorime si vektor s hodnotami dlzky hrany (celociselne hodnoty od 1 po
%hodnotu premennej hrana)
os_x=1:max(hrana);

[objem_v, povrch_s] = objempovrchkocky(os_x);

% objem_v = objemkocky(os_x); %hodnoty objem pre rozne dlzky hrany
% povrch_v=6.*os_x.^2; %hodnoty povrchu pre rozne dlzky hrany

figure %otvori nove prazdne okno
subplot(2,1,1) %vykreslime si vyvoj objemu a povrchu kocky do samostatnych grafov pod seba
grid %pridam mriezku pre vsetky nasledujuce grafy
plot(objem_v,'r-*')    %vykresli hodnoty objemu kocky
%'r-*': 'r' nastavi farbu ciary na cervenu,
%'-' nastavi zobrazovanu ciaru ako plnu ciaru,
%'*' prida znak * pre vykreslene body.
%pomenujem osi
xlabel(sprintf('Velkost hrany kocky (pre max. hranu dlzky %.2f)', max(hrana)))
ylabel('Objem kocky')
title('Toto je graf vyvoja objemu kocky pre rozne celociselne hodnoty dlzky hrany.')

subplot(2,1,2)
plot(povrch_s,'g--+')  %vykresli hodnoty povrchu kocky
%'g--+': 'g' nastavi farbu ciary na zelenu,
%'--' definuje ciaru ako prerusovanu,
%'+' prida znak plus pre vykreslene body.
xlabel(sprintf('Velkost hrany kocky (pre max. hranu dlzky %.2f)', max(hrana)))
ylabel('Povrch kocky')
title('Toto je graf vyvoja povrchu kocky pre rozne celociselne hodnoty dlzky hrany.')
linkaxes

%zmenim rozsah osi x (pre oba grafy)
xlim([0.5 max(hrana)+0.5])


