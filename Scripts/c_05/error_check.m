function nieje_ok = error_check(a)
% nieje_ok = error_check(hrana)
% Tato funkcia kontroluje, ci je zadany vstup "hrana" kladne cislo
% Ak nie je, funkcia vypise na obrazovku chybovu hlasku 
% a nastavi indikatorovu premennu nieje_ok na 1.

% Vstupy:
% hrana ... cislo, pri ktorom kontrolujeme ci je kladne
%
% Vystupy:
% nieje_ok ... indikator urcujuci, ci je zadany vstup iny ako kladny
if isempty(a) %ak nezadal ziadnu hodnotu, pekne uzivatela poprosime, aby nieco zadal
    warning('Nezadali ste ziadnu hodnotu, prosim najprv zadajte hodnotu, a potom stlacte Enter.')
    nieje_ok = 1;
elseif a <= 0 %ak zadal zaporne cislo
    warning('No, no, no! Dlzka hrany kocky nemoze byt zaporne cislo!')
    nieje_ok = 1;
else
    nieje_ok = 0;
end
end