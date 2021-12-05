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
% linkaxes %rozlicne rozsahy os vsetkych 4  grafov mozno zjednotit pomocou linkaxes

% Ukazka porovnania poctu testov a poctu pozitivnych testov
y2=[testy.prirustkovy_pocet_testu(end-30:end,1) pozitivnetesty.prirustkovy_pocet_nakazenych(end-31:end-1,1)];
figure
bar(x,y2);
xticks(x(1:2:end))      % funckie xticks/yticks umoznuju upravit zobrazene znacky na osach x a y,
xtickformat('dd-MMM')   % xtickformat/ytickformat umoznuju definovat format popiskov znaciek na osach x a y
legend('Pocet testov', 'Pocet novych nakazenych');

% Chceme vykreslit podiel pozitivnych testov na celkovom pocte testov
% y3 = ["pocet pozitivnych testov" "pocet negativnych testov" ]
y3=[pozitivnetesty.prirustkovy_pocet_nakazenych(end-30:end,1), (testy.prirustkovy_pocet_testu(end-30:end,1)-pozitivnetesty.prirustkovy_pocet_nakazenych(end-30:end,1))];
figure
b3=bar(x,y3,'stacked') %ulozime si "madlo" ku stlpcovemu grafu (b3 bude objekt typu "bar")
xticks(x(1:2:end));      % funckie xticks/yticks umoznuju upravit zobrazene znacky na osach x a y,
xtickformat('dd-MMM');   % xtickformat/ytickformat umoznuju definovat format popiskov znaciek na osach x a y
b3(1).FaceColor=[1 0.1 0.1];
b3(2).FaceColor=[0.1 1 0.1];
legend('Pozitivne testy', 'Negativne testy');
title('Denne pocty testov na COVID-19 za poslednych 31 dni');
xlabel('Datum');
ylabel('Pocet testov');


% Ukazka histogramu (na pocte testov za poslednych 201 dni)
figure
histogram(testy.prirustkovy_pocet_testu(end-200:end));


% Ukazka konstrukcie a upravy kolacoveho grafu
figure
kolac=pie([37 19 7 37], {'obloha' 'časť pyramídy na slnku' 'časť pyramídy v tieni' ' '});
kolac(1).FaceColor=[0 0.6 1];
kolac(1).EdgeColor='none';
kolac(3).FaceColor=[1 0.9 0.0];
kolac(3).EdgeColor='none';
kolac(5).FaceColor=[0.93 0.69 0.13];
kolac(5).EdgeColor='none';
kolac(7).FaceColor=[0 0.6 1];
kolac(7).EdgeColor='none';
title('Pyramída');

% ukazka animacie
x_pom = 25:-1:0;
for ii=1:length(x_pom)
    kolac=pie([37 x_pom(ii) (26-x_pom(ii)) 37], {' ', ' ', ' ', ' '});
    kolac(1).FaceColor=[0 0.6 1];
    kolac(1).EdgeColor='none';
    if ii ~= length(x_pom)
        kolac(3).FaceColor=[1 0.9 0];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[0.93 0.69 0.13];
        kolac(5).EdgeColor='none';
        kolac(7).FaceColor=[0 0.6 1];
        kolac(7).EdgeColor='none';
    else
        kolac(3).FaceColor=[0.93 0.69 0.13];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[0 0.6 1];
        kolac(5).EdgeColor='none';
    end
    title('Pyramída');
    
    M(ii)=getframe;
end
for jj=1:length(x_pom)
    kolac=pie([37 x_pom(jj) (26-x_pom(jj)) 37], {' ' ' ' ' ' ' '});
    kolac(1).FaceColor=[0 0.6 1];
    kolac(1).EdgeColor='none';
    if jj ~= length(x_pom)
        kolac(3).FaceColor=[0.93 0.69 0.13];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[0.72 0.52 0.05];
        kolac(5).EdgeColor='none';
        kolac(7).FaceColor=[0 0.6 1];
        kolac(7).EdgeColor='none';
    else
        kolac(3).FaceColor=[0.72 0.52 0.05];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[0 0.6 1];
        kolac(5).EdgeColor='none';
    end
    title('Pyramída');
    
    M(length(x_pom)+jj)=getframe;
end
for kk=1:length(x_pom)
    kolac=pie([37 x_pom(kk) (26-x_pom(kk)) 37], {' ' ' ' ' ' ' '});
    kolac(1).FaceColor=[0 0.6 1];
    kolac(1).EdgeColor='none';
    if kk ~= length(x_pom)
        kolac(3).FaceColor=[0.72 0.52 0.05];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[0.93 0.69 0.13];
        kolac(5).EdgeColor='none';
        kolac(7).FaceColor=[0 0.6 1];
        kolac(7).EdgeColor='none';
    else
        kolac(3).FaceColor=[0.93 0.69 0.13];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[0 0.6 1];
        kolac(5).EdgeColor='none';
    end
    title('Pyramída');
    
    M(2*length(x_pom)+kk)=getframe;
end
for ll=1:length(x_pom)
    kolac=pie([37 x_pom(ll) (26-x_pom(ll)) 37], {' ' ' ' ' ' ' '});
    kolac(1).FaceColor=[0 0.6 1];
    kolac(1).EdgeColor='none';
    if ll ~= length(x_pom)
        kolac(3).FaceColor=[0.93 0.69 0.13];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[1 0.9 0];
        kolac(5).EdgeColor='none';
        kolac(7).FaceColor=[0 0.6 1];
        kolac(7).EdgeColor='none';
    else
        kolac(3).FaceColor=[1 0.9 0];
        kolac(3).EdgeColor='none';
        kolac(5).FaceColor=[0 0.6 1];
        kolac(5).EdgeColor='none';
    end
    title('Pyramída');
    
    M(3*length(x_pom)+ll)=getframe;
end
movie(M)


%% Cast II - Tvorba a praca s 3D grafmi
% 3D stlpcovy graf vyvoja poctu testov pre rozne mesiace
% vytvorime maticu s hodnotami testov od zaciatku Marca po koniec Novembra
Y=NaN(31,9);
for ii=3:11
    Y(1:length(find(month(testy.datum)==ii)),ii-2)=[testy.prirustkovy_pocet_testu(month(testy.datum)==ii)];
end

figure
bar3(Y);
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