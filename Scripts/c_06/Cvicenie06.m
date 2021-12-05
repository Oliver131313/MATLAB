%% Toto je skript v cviceniu 6 z MPE_ZMAT. Cvicenie je venovane spracovaniu textu v MATLABe
close all
clear all
clc

%% MATLAB rozlisuje 2 typy textovych retazcov: character vector [char] a string array [str]
% Zadefinujme si 2 premenne, jednu pre kazdy typ textoveho retazca
a = "Toto je text vo formate str"
b = 'Toto je text vo formate char'

% ULOHA: V com su rozdiely? Ake rozmery maju vytvorene premenne?
size(a)
size(b)

% ULOHA: Vytvorme si druhu dvojicu premennych, s opacnym formatom, nez povodne,
% vyuzijeme funkcie char() a string() pre konverziu medzi formatmi
a_char = char(a)
b_str = string(b)


% Format mozeme overit pomocou funkcie class()
class(a)
class(b)

% s textom vo formate char sa da pracovat ako s vektorom:
transponovane_b = b'

size(b)
size(transponovane_b)
b*b'

% String comparison (funguje aj pre char vectory)
strcmp(b, b')
strcmp(a, a')
strcmp(a, b)
% ULOHA: Funguje to aj s textom vo formate str?
% a * a'; % Nie

% ULOHA: Ako sa odkazeme na prve pismeno textu v char a ako v str?
a{1}(1) % Sposob pre strings - {} nas dostava "do vnutra" textu ako keby sme boli v char1
b(1) % Sposob pre chars


%% Vytvaranie "matic" s textom, t.j. poli s retazcami / poli s vektormi znakov 
% ULOHA: Co sa stane ak budeme chciet vytvorit novu premennu, v ktorej poskladame
% "pod seba" dva textove retazce rovnakeho typu?

%string
str = [a ; b_str]
str{2}
str_concat = a + ' ' + b_str
% character vector
char = [b; a_char]

% Pre oba formaty sucasne funguje funkcia strcat(), ktora spaja text
% horizontalne
strcat(a, b_str) % to iste co som spravil v premennej str_concat
strcat(b, a_char)
strcat(a, a_char)

%% Dalsie funkcie pre pracu s textom
B = upper(b)
b_ = lower(b)

% Je strcmp case senstitive?
strcmp(b, B) % Nie!
strcmp(lower(b), lower(B))
% Strcmpi urobi to iste co toto strcmp(lower(b), lower(B))
strcmpi(b, B)
% Ak chcem porovnat na nejakej pozicii - strncmp
strncmp(a, b, 24)

% Hladanie vyrazu v stringu - vrati poziciu, kde sa nachadza hladany
% znak/sekvencia
strfind(a, 'str')
strfind(b, 'char')
strfind(a, 't')

%% Nadchove cvicenie
neznele = 'ptťfsšk';
znele = 'bdďvzžg';
nadchove_a = a;
for ii = 1:length(neznele)
    nadchove_a = strrep(lower(nadchove_a), neznele(ii), znele(ii));
end
disp(nadchove_a)