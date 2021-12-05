%% Kutis - kap. 10, pr. 16 - Najdenie korenov kvadratickej funkcie pomocou vnorenych funkcii
clear
close all
clc

%% Call funkcie
disp("\nKomplexne korene:\n")
quadr_roots(1, 1, 1) % Komplexny koren

disp("\Realne korene:\n") % Realny koren
quadr_roots(1, 2, -3)

%% Samotna funkcia
function [roots] = quadr_roots(a,b,c)
% Tato funkcia vypocita korene kvadratickej funkcie pomocou vnorenej
% funkcie na vypocet diskriminantu.

    function d = discriminant(a, b, c)
        % Vlozena funkcia pocitajuca diskriminant
        d = b^2 - 4*a*c;
    end
d = discriminant(a, b, c);

roots = [];
sqrt_discr = sqrt(d);
r1 = (-b + sqrt_discr) / 2*a;
r2 = (-b - sqrt_discr) / 2*a;
   if r1 == r2
        roots(1) = r1;
   else
        roots(1) = r1;
        roots(2) = r2;
   end
end % quadr_roots
