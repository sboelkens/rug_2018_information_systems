% Course: Information Systems
% Association Rule Analysis with Apriori
% Author: Dr. George Azzopardi
% Date: November 2018
function [frequentItems, dataset, ntrans, trlbl, minconf, support] = getFrequentItems(minsup,minconf)

if nargin == 0
    minsup = 0.001;
    minconf = 0.8;
elseif nargin == 1
    minconf = 0.8;
end

shoppingList = readDataFile;
% shoppingList = {
%     {'Bread', 'Milk'};
%     {'Bread','Cheese','Ham','Eggs'};
%     {'Milk','Cheese','Ham','Coke'};
%     {'Bread','Milk','Cheese','Ham'};
%     {'Bread','Milk','Cheese','Coke'}
%     };
% 
% shoppingList = {
%         {'Bread', 'Milk', 'Chips', 'Mustard'};
%         {'Beer', 'Diaper', 'Bread', 'Eggs'};
%         {'Beer', 'Coke', 'Diaper', 'Milk'};
%         {'Beer', 'Bread', 'Diaper', 'Milk', 'Chips'};
%         {'Coke', 'Bread', 'Diaper', 'Milk'};
%         {'Beer', 'Bread', 'Diaper', 'Milk', 'Mustard'};
%         {'Coke', 'Bread', 'Diaper', 'Milk'}
%     };

% shoppingList = {
%         {'A','D'};
%         {'A','C'};
%         {'A','B','C'};
%         {'B','E','F'}
%     };

% shoppingList = {
%         {'1','3','4'};
%         {'2','3','5'};
%         {'1','2','3','5'};
%         {'2','5'}
%     };

ntrans = size(shoppingList,1);
items = unique([shoppingList{:}]);
nitems = numel(items);

[tridx,trlbl] = grp2idx(items);

% Create the binary matrix
dataset = zeros(ntrans,nitems);
for i = 1:ntrans
   dataset(i,tridx(ismember(items,shoppingList{i}))) = 1;
end

% Generate frequent items of length 1
support{1} = sum(dataset)/ntrans;
f = find(support{1} >= minsup);
frequentItems{1} = tridx(f);
support{1} = support{1}(f);

% Generate frequent item sets
k = 1;
while k < nitems && size(frequentItems{k},1) > 1
    % Generate length (k+1) candidate itemsets from length k frequent itemsets
    frequentItems{k+1} = [];
    support{k+1} = [];
    
    % Consider joining possible pairs of item sets
    for i = 1:size(frequentItems{k},1)-1
        for j = i+1:size(frequentItems{k},1)
            if k == 1 || isequal(frequentItems{k}(i,1:end-1),frequentItems{k}(j,1:end-1))
                candidateFrequentItem = union(frequentItems{k}(i,:),frequentItems{k}(j,:));  
                if all(ismember(nchoosek(candidateFrequentItem,k),frequentItems{k},'rows'))                
                    sup = sum(all(dataset(:,candidateFrequentItem),2))/ntrans;                    
                    if sup >= minsup
                        frequentItems{k+1}(end+1,:) = candidateFrequentItem;
                        support{k+1}(end+1) = sup;
                    end
                end
            else
                break;
            end            
        end
    end         
    k = k + 1;
end
