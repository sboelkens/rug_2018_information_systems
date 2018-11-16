%task 01
ShoppingListHistogram();

%task 02-03
tic;
[AR1,confidence1,support1] = associationRulesOptimized(0.001, 0.8);
toc;

tic;
[AR2,confidence2,support2] =  associationRules(0.001, 0.8);
toc;

%task 04
[~, a] = size(AR2);
fprintf('number of rules that satisfy support = 0.001 and  confidence 0.8 is %s\n',int2str(a));

%task 05
for i = 1:31
    fprintf('%s\n',AR2{1,i});
end
