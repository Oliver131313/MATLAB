clear all
%% Kap. 2 - 48
% Generate a vector of 20 random integers, each in the range from 50 to
% 100. Create a variable evens that stores all of the even numbers from the
% vector, and a variable odds that stores the odd numbers.
rand_vector = randi([50, 100], 1, 20);       % Vektor 20 nahodnych cisel z intervalu 50-100
filt_even = rem(rand_vector, 2) == 0;        % Filter parnych cisel
even_vector = rand_vector(filt_even);        % Vyfiltruj mi iba cisla, ktore su parne + uloz do vektora
odd_vector  = rand_vector(~filt_even);       % Vyfiltruj mi iba cisla, ktore su (doslova) opakom parnych 
                                             % + uloz do vektora
%% Kap. 3 - 34
vecout(5)                % Call funkcie vecout  
    
% Funkcia pre tento ucel - ***MUSI byt na konci scriptu***
function [vec] = vecout(x)
increment = x + 5;      % Inkrementacia + 5 
vec = x:increment;      % Vytvorenie vektora [x, x+1, x+2,..., increment]
end