%% Cvicenie 07 - kapitoly 8 a 9 (datove struktury a data transfer)
clear
close all
clc

%% I. Nacitanie datoveho suboru -
% Nacitame Excelovsku tabulku, v Attaway je na tieto ucely predstavena
% funkcia xlsread(), ta uz vsak v novsich verziach MATLABu nie je velmi
% podporovana, lepsie je vyuzit funkciu readtable()

%Ponechanie povodnych nazvov premennych -> volba 'PreserveVariableNames',true
% ak tato volba sposobuje chybu, potom je lepsie ju nepouzit (niektore
% znaky v nazvoch premennych, ktore nie su podporovane sa potom nahradia
% (vid stlpcek UCO)
% data_raw = readtable('ZAEK.xlsx','PreserveVariableNames',true);
data_raw = readtable('ZAEK.xlsx');

%Zachovanie niektorych datovych typov - v 6. stlpci tabulky mame textove
%retazce, MATLAB pri nacitani dat pouziva niekolko prvych riadkov tabulky
%na urcenie o aky datovy typ sa jedna, kedze v stlpci 6 sa striedaju cisla
%s pismenami, moze sa stat, ze MATLAB identifikuje typ dat v tomto stlpci
%ako "double", t.j. ciselna informacia, pokial sa to stane, mozeme manualne
%nastavit, ze informacia v 6. stlpci je v skutocnosti text, pomocou
%nasledovnych prikazov:

% opts = detectImportOptions('ZAEK.xlsx');
% opts.VariableTypes{6} = 'char';
% data_raw = readtable('ZAEK.xlsx',opts);


%% II. Zakladna praca s datovym typom "table"
%a) zobrazenie tabulky
disp(data_raw)

%b) zobrazenie vybranych stlpcov (ciselne)
disp(data_raw(:,[1,3,5]))

%... alebo riadkov (ciselne)
disp(data_raw(1:10,[1,3,5]))

% ... alebo len vyber prvych n riadkov (v tomto pripade 5)
head(data_raw,5)

%zobrazenie jednotlivych stlpcov (podla nazvu stlpcov)
disp(data_raw.('U_O'))
% ...a len niektoreho prvku
disp(data_raw.('U_O')(2))

%rozdiel v zatvorkach (okruhle vs zlozene)
disp(data_raw(1,4))
disp(data_raw{1,4})

%c) vytvorenie novych riadkov a stlpcov
data_raw.T(128) = 14;

pom=unique(data_raw.U_O); %vypise len unikatne riadky (v nasom pripade vsetky)
size(pom,1)==size(data_raw,1)

%zmazanie riadku (obdobne aj stlpca) tabulky
data_raw(128,:)=[];


%vytvorenie novych stlpcov - meno a priezvisko
[data_raw.Priezvisko,rest] = strtok(data_raw.Student,',');
data_raw.Meno = erase(rest,', ');

%Prevedenie informacie v stlpci Datum na format datumu
% data_raw.Datum=x2mdate(data_raw.Datum,0,'datetime'); % alebo 'datenum'=default),

%d) premenovanie stlpcov, doplnenie nazvu riadkov a dalsich vlastnosti
%Nazvy riadkov musia byt jedinecne!

% napr. priezvisko (najprv vhodne overit jedinecnost)
pom=unique(data_raw.Priezvisko);
size(pom,1)==size(data_raw,1)

% alebo cele meno:
pom=unique(data_raw.Student);
size(pom,1)==size(data_raw,1)


%data_raw.Properties.RowNames = data_raw.Priezvisko;
data_raw.Properties.RowNames = data_raw.Student;

%Premenovanie­ UCO (momentalne "U_O")
%ak nevieme, na ktorej pozicii je stlpec UCO
ind = strfind(data_raw.Properties.VariableNames, 'U_O');
ind = cellfun(@isempty,ind)
data_raw.Properties.VariableNames{~ind}='UCO';
% inak
%  data_raw.Properties.VariableNames{3} = 'UCO';

%e) ULOHA: zavedenie kategorickej premennej pre obory - EKON, FIN, PEM  a OST
%Obor_kategorie OSTATNI
pom = strings(size(data_raw,1),1);
pom(:) = 'OST';
data_raw.Obor_kategorie = pom;

kategorie = {'EKON','FIN','PEM'};
% ???


% Prevod do kategorialnej premennej
data_raw.Obor_kategorie = categorical(data_raw.Obor_kategorie);
data_raw.Hodnoceni = categorical(data_raw.Hodnoceni);
data_raw.Cv = categorical(data_raw.Cv);

% Dopocitanie bodov
data_raw.Celkom = sum(data_raw{:,8:12},2);
data_raw.Celkom_test = sum(data_raw{:,{'Cast_A','Cast_B'}},2);

% Funkcie: summary a grpstats
summary(data_raw)

pom = data_raw(:,{'Celkom_test','Celkom','Obor_kategorie'});
statistiky_1 = grpstats(pom,'Obor_kategorie');
disp(statistiky_1)
pom = data_raw(:,{'Cv','Celkom_test','Celkom','Obor_kategorie'});
statistiky_2 = grpstats(pom,{'Cv','Obor_kategorie'});
disp(statistiky_2)

% zlucenie premennych (vytvorenie matice v ramci tabulky)
ustna_cast = [data_raw.Projekt data_raw.Obhajoba];
data_raw.Ustni_cast = ustna_cast;
disp(data_raw(:,{'Ustni_cast'}))

%% III. Prevod do struktury a praca s tymto datovym typom
% prevedenie suhrnu statistik do formatu struktury
s = summary(data_raw);

% prevedenie "table" do "structure"
data_str = table2struct(data_raw);

% zobrazenie vybranych riadkov struktury
%Preco je tu vystup aky je?
disp([data_str(1).Student, data_str(1).Celkom_test])
% Vhodnejsia varianta
% ???

% Varianta viacerych poloziek
disp({data_str([1,3,5]).Student, data_str([1,3,5]).Celkom_test})
disp({data_str([1,3,5]).Student, data_str([1,3,5]).Celkom_test}')
% Vhodnejsia varianta
% ???


% Ziskanie nazvov poli a ulozenie do cell array
nam_field = fields(data_str);
disp(nam_field)

% Pouzitie mien do nazvov poli 
% (a zobrazenie poslednich piatich riadkov posledneho pola)
pom = [data_str.(nam_field{end})];
% reshape je nutny pretoze predchadzajuci prikaz vektorizoval maticu 
% poloziek daneho pola - toto pole predstavovalo vektor 1x2
pom = (reshape(pom',2,length(pom)/2))';
disp(pom(end-4:end,:))

% Premenovanie pola
[data_str.Obor_kod] = data_str.Obor_kategorie;
data_str = rmfield(data_str,'Obor_kategorie');

% Overenie, ci sa jedna o Ackarov (slovne hodnotenie­ Ano/Nie
% pole Ackar
[data_str.Ackar] = deal('Ne');
ind = find([data_str.Hodnoceni]=='A');
[data_str(ind).Ackar] = deal('Ano');
% alebo
% ind = iscategory(categorical({'A'}),char([data_str.Hodnoceni]));

%Overenie spravnosti - v jednoduchom vystupe
disp({data_str.Ackar;data_str.Hodnoceni}')

% Vypisanie mien vsetkych Ackarov, mena cviciaceho, hodnotenia a celkoveho
% poctu bodov s vyuzitim fprintf a nasledne zapisanie do suboru .txt
% definovanie nazvu suboru:
nazov ='ackari.txt';

%identifikator suboru a jeho otvorenie pre zapis vratane zmazania
%existujuceho obsahu:
FID = fopen(nazov,'w+');

%zapisanie jednotlivych riadkov textoveho suboru:
fprintf(FID,'\n\tToto je zoznam Áèkarov zo ZAEKu\n');
fprintf(FID,'\t******************************\n');
fprintf(FID,'  Meno \t\t\t Priezvisko \t\t\t Cvièiaci \t Hodnotenie \t Body\n');
fprintf(FID,'  ===================================================================\n');
for ii=ind
    fprintf(FID,'%10s \t %15s \t %15s \t %5s \t\t %3.0f \n',...
        data_str(ii).Meno, data_str(ii).Priezvisko, data_str(ii).Cv, ...
        data_str(ii).Hodnoceni, data_str(ii).Celkom);
end

% Uzavretie souboru
fclose(FID);

% Priprava a export Tabulky Ackarov do excelu
vyber = {'Meno','Priezvisko','Cv','Hodnoceni','Celkom'};
%inicializacia strukturalnej premennej (len pre vyhodenie warningu v cykle)
pom_str = struct([]);
for vv=1:length(vyber)
    if vv==1
        %tento cyklus staci spustit len raz pre urcenie velkosti pom_str
        for ii=1:length(ind)
            pom_str(ii).(vyber{vv}) = data_str(ind(ii)).(vyber{vv});
        end
        %po prvom spusteni cyklu uz nemusime priradovat prvok po prvku
    else
        [pom_str(:).(vyber{vv})] = data_str(ind).(vyber{vv});
    end
end

tabulka_export = struct2table(pom_str);
writetable(tabulka_export,'Ackari_ZAEK.xlsx');

%% IV. Bonus praca s API rozhranim
%https://fred.stlouisfed.org/docs/api/fred/
%nutnost registracie pre ziskanie "api key"
% url_tags = 'https://fred.stlouisfed.org/docs/api/fred/tags.html';

%https://api.stlouisfed.org/fred/series?series_id=GNPCA&api_key=abcdefghijklmnopqrstuvwxyz123456&file_type=json
%my_url = 'https://api.stlouisfed.org/fred/series?series_id=GNPCA&api_key=abcdefghijklmnopqrstuvwxyz123456&file_type=json';
%data = webread(my_url);

%CSU - Otevrena Data (aj ako api)
%https://www.czso.cz/csu/czso/otevrena_data
my_url = 'https://www.volby.cz/pls/ps2021/vysledky';
outfilename = websave('my_xml.xml',my_url);
my_data_CSU = xml2struct(outfilename);

%MPSV https://data.mpsv.cz/web/data/regionalni-statistika-ceny-prace-rscp
% JSON format
my_url = 'https://data.mpsv.cz/od/soubory/regionalni-statistika-ceny-prace/regionalni-statistika-ceny-prace.json';
my_data = webread(my_url);

my_table = struct2table(my_data.polozky);
head(my_table)
my_table(1:100,1:4)


% http://data.worldbank.org/developers/climate-data-api
% The service returns data formatted as JSON objects.
% webread converts homogeneous JSON objects to a structure array.
api = 'http://climatedataapi.worldbank.org/climateweb/rest/v1/';
url = [api 'country/cru/tas/year/USA'];
url2 = [api 'country/cru/pr/year/USA'];
tempr = webread(url);
precip = webread(url2);
figure
subplot(2,1,1)
plot([tempr.year],[tempr.data]);
subplot(2,1,2)
plot([precip.year],[precip.data]);

