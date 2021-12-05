function V=objemkocky(a)
% objem=objemkocky(a)
% Toto je napoveda k funkcii objemkocky, tato funkcia, pocita objem kocky 
% na zaklade jedineho vstupu, ktory definuje dlzku hrany kocky
%
% Vstupy:
% a ... dlzka hrany kocky
%
% Vystupy
% objem ... cislo udavajuce objem kocky
%
% Vytvoril: Jakub Chalmoviansky, 27 Septembra 2021

obsah_steny_kocky=a.^2;
V=obsah_steny_kocky.*a;

end
