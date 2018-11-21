
minsup = 0.001;
minconf = 0.8;

[frequentItems, dataset, ntrans, trlbl, minconf, support] = getFrequentItems(minsup,minconf);

tic;
[AR1,confidence1,support1] = getConfidence(frequentItems, dataset, ntrans, trlbl, minconf, support);
toc;

tic;
[AR2,confidence2,support2] =  getConfidenceOptimized(frequentItems, dataset, ntrans, trlbl, minconf, support);
toc;


[~, a] = size(AR1);
fprintf('Original code: number of rules that satisfy support = %1.4d and confidence %1.4d is %s\n',[minsup, minconf,int2str(a)]);

[~, a] = size(AR2);
fprintf('Optimized code: number of rules that satisfy support = %1.4d and confidence %1.4d is %s\n',[minsup, minconf,int2str(a)]);