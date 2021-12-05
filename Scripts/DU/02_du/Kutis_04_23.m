%% Kap.4 - 23 Rewrite the switch statement as if-else statement that accomplishes exactly the same thing
% ranforce = randi([0, 12]);
% switch ranforce
%     case 0
%         disp('There is no wind')
%     case {1,2,3,4,5,6}
%         disp('There is a breeze')
%     case {7,8,9}
%         disp('This is a gale')
%     case {10,11}
%         disp('It is a storm')
%     case 12
%         disp('Hello, Hurricane!')
% end

ranforce = randi([0, 12]);
if ranforce == 0
    disp('There is no wind')
elseif any(ranforce == [1, 2, 3, 4, 5, 6])
    disp('There is a breeze')
elseif any(ranforce == [7, 8, 9])
    disp('This is a gale')
elseif any(ranforce == [10, 11])
    disp('It is a storm')
else
    disp('Hello, Hurricane!')
end