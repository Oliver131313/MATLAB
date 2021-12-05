%% Skript k cvičeniu 10: Práca s grafmi
% Práca s grafmi (vytvaranie pokrocilejsich grafov a ich uprava)
clear
close all
clc


%% Cast I - Tvorba a praca s 2D grafmi

% vyuzijeme udaje o testovani na COVID-19
testy=readtable('testy.csv'); % dataset s poctami testov
pozitivnetesty=readtable('nakaza.csv'); % dataset s poctami pozitivnych vysledkov

x=testy.datum(end-30:end,1); % vektor datumov
y=testy.prirustkovy_pocet_testu(end-30:end,1); %vektor denneho poctu testov


% ukazka prace s roznymi typmi grafov (funkcie: bar, area, stem)
figure
subplot(2,2,1)
plot(x,y)
title('Prirastkovy pocet testov na COVID-19 (funkcia plot)')
xlabel('Datum')
ylabel('Pocet testov')
subplot(2,2,2)
bar(x,y)
title('Prirastkovy pocet testov na COVID-19 (funkcia bar)')
xlabel('Datum')
ylabel('Pocet testov')
subplot(2,2,3)
area(x,y)
title('Prirastkovy pocet testov na COVID-19 (funkcia area)')
xlabel('Datum')
ylabel('Pocet testov')
subplot(2,2,4)
stem(x,y)
title('Prirastkovy pocet testov na COVID-19 (funkcia stem)')
xlabel('Datum')
ylabel('Pocet testov')
linkaxes %rozlicne rozsahy os vsetkych 4  grafov mozno zjednotit pomocou linkaxes

% ULOHA: Ukazka porovnania poctu testov a poctu pozitivnych testov pre
% kazdy den
y2 = [testy.prirustkovy_pocet_testu(end-30:end, 1), pozitivnetesty.prirustkovy_pocet_nakazenych(end-31:end-1, 1)];
bar(x,y2)
title('Prirastkovy pocet testov na COVID-19 (funkcia bar)')
xlabel('Datum')
ylabel('Pocet testov')
xticks(x(1:2:end))
xtickformat('dd-MM')
legend('Pocet testov', 'Pocet pozitivnych')


% ULOHA: Chceme vykreslit podiel pozitivnych testov na celkovom pocte testov
y3 = [pozitivnetesty.prirustkovy_pocet_nakazenych(end-31:end-1, 1),...
    (testy.prirustkovy_pocet_testu(end-30:end, 1) - pozitivnetesty.prirustkovy_pocet_nakazenych(end-31:end-1, 1))]

figure
b3 = bar(x, y3, 'stacked')
b3(1).FaceColor = [1 0 0];
b3(2).FaceColor = [0 0.6 0.2];
title('Denne pocty testov na COVID-19 za poslednych 31 dni');
xlabel('Datum')
ylabel('Pocet testov')
xticks(x(1:2:end))
xtickformat('dd-MM')
legend('Pozitivne testy', 'Negativne testy');



% Ukazka histogramu (na pocte testov za poslednych 201 dni)
figure
histogram(testy.prirustkovy_pocet_testu(end-200:end));


% Ukazka konstrukcie a upravy kolacoveho grafu
figure
pyr=pie([37 19 7 37])


% ukazka animacie
x_pom = 25:-1:0;
%NA DOPLNENIE (vid Cvicenie10_riesenie.m)


%% Cast II - Tvorba a praca s 3D grafmi
% 3D stlpcovy graf vyvoja poctu testov pre rozne mesiace
% vytvorime maticu s hodnotami testov od zaciatku Marca po koniec Novembra
Y=NaN(31,9);
for ii=3:11
    Y(1:length(find(month(testy.datum)==ii)),ii-2)=[testy.prirustkovy_pocet_testu(month(testy.datum)==ii)];
end

figure
% ULOHA: Vytvorte 3D stlpcovy graf pre vyvoj poctu testov po mesiacoch

xlabel('Mesiac');
xticklabels(3:11);
ylabel('Den');
zlabel('Pocet testov');
title('Vyvoj poctu testov COVID-19 podla jednotlivych mesiacov');
legend({'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'});



% trochu iny 3D graf na zaver
figure;
clear;
[y,x,z] = meshgrid(linspace(-2,2,300));
f = (x.^2+9/4*y.^2+z.^2-1).^3-x.^2.*z.^3-9/80*y.^2.*z.^3;
heart=patch(isosurface(x,y,z,f,.0));
heart.FaceColor='red';
heart.EdgeColor='none';
axis off;
view([1 1.5 0.5]);
camlight;
lighting gouraud;
heart.Parent.Parent.Position=[100 100 800 600];

% ukážka ako uložiť graf
% (i) vo formate .fig (Matlabovsky format umoznujuci neskorsie dalsie upravy)
savefig(heart.Parent.Parent,'3Dsrdce.fig');

% (ii) v inych formatoch (napr. jpg, tif, pdf, png, ...)
print(heart.Parent.Parent,'-dpng','-r100','3Dsrdce');