
minsup = 0.005;
minconf = 0.4;

fprintf('Support = %1.4f and Confidence %1.4f\n\n',[minsup, minconf]);


fprintf('Calculating frequent itemsets\n');
tic;
[frequentItems, dataset, ntrans, trlbl, minconf, support] = getFrequentItems(minsup,minconf);
toc;
fprintf('\n');

fprintf('Calculating confidence using original code\n');
tic;
[AR1,confidence1,support1] = getConfidence(frequentItems, dataset, ntrans, trlbl, minconf, support);
toc;
[~, a] = size(AR1);
fprintf('Original code: number of rules that satisfy is %s\n\n',int2str(a));


fprintf('Calculating confidence using optimized code\n');
tic;
[AR2,confidence2,support2] =  getConfidenceOptimized(frequentItems, dataset, ntrans, trlbl, minconf, support);
toc;
[~, a] = size(AR2);
fprintf('Optimized code: number of rules that satisfy is %s\n\n',int2str(a));
