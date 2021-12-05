%% Kutis - Kapitola 08, priklad 05
% Create three cell array variables that store people’s names, verbs, and nouns.
% Write a script that will initialize these cell arrays, and then print sentences using
% one random element from each cell array (e.g., ‘Xavier eats sushi’).

names = {'Martin', 'Štepán', 'Jakub'};
verbs = {'má rád', 'zjedol'};
nouns = {'bicykel', 'loptu', 'psy'};

S = 5;                      % Pocet viet
for i = 1:S
   % Nahodne cisla pre kazdu premennu
   name_r = randi([1, length(names)]); 
   verb_r = randi([1, length(verbs)]); 
   noun_r = randi([1, length(nouns)]);
   % Vytvorenie nahodnej vety
   fprintf('\n%s %s %s.\n', names{name_r}, verbs{verb_r}, nouns{noun_r})
   
end

%% Kutis - Kapitola 09, priklad 01
% Create a spreadsheet that has on each line an integer student identification
% number followed by three quiz grades for that student. Read that information
% from the spreadsheet into a matrix and print the average quiz score for each
% student.
% Random grades
rand_matrix = randi(5, 50, 4);
rand_id = 1:2:100;
rand_matrix(:, 1) = rand_id;

% Zapis do excelu
xlswrite('students', rand_matrix);
% Nacitaj z excelu
tab = readtable('students.xls');

% Premenuj stlpce
cols = {'ID', 'Grade_1', 'Grade_2', 'Grade_3'};
tab.Properties.VariableNames = cols;

% Priemer pre kazdeho studenta
tab.Grade_avg = mean(tab{:,2:end},2);
