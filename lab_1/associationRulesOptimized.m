% Course: Information Systems
% Association Rule Analysis with Apriori
% Author: Dr. George Azzopardi
% Date: November 2018
function [AR,confidence,support] = associationRulesOptimized(minsup,minconf)

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

% Generate association rules
warning off;
AR = cell(0);
conf = [];
sup = [];
% We consider the itemsets that have at least two items
for k = 2:numel(frequentItems)
    for j = 1:size(frequentItems{k},1)
        lowConfList = {};
        % Improvement: Turn around foreach loop to start with the most
        % antecedents, then go lower instead of other way around
        for i = numel(frequentItems{k}(j,:))-1:-1:1
            antecendentlist = nchoosek(frequentItems{k}(j,:),i);
            for l = 1:size(antecendentlist,1)       
                consequence = find(~ismember(frequentItems{k}(j,:),antecendentlist(l,:)));
                isSubsetOf = false;
                % Improvement: check if our current antecedentlist member
                % is a subset of what is already in the lowConfList
                for x = 1:size(lowConfList)
                    isSubsetOf = all(ismember(antecendentlist(l,:), lowConfList{x}));
                end
                if isSubsetOf == false
                    confidence = support{k}(j)*ntrans/sum(all(dataset(:,antecendentlist(l,:)),2));
                    if confidence >= minconf
                        sup(end+1) = support{k}(j);
                        conf(end+1) = confidence;
                        antecedentstr = '';
                        for m = 1:size(antecendentlist,2)
                            antecedentstr = [antecedentstr,trlbl{antecendentlist(l,m)},','];
                        end
                        consequencestr = '';
                        for m = 1:numel(consequence)
                            consequencestr = [consequencestr,trlbl{frequentItems{k}(j,consequence(m))},','];
                        end
                        AR{end+1} = [antecedentstr(1:end-1),' -> ',consequencestr(1:end-1),sprintf(' [%2.2f,%2.2f]',sup(end),conf(end))];
                    else
                        % Improvement: if confidence is not high enough, store
                        % it in the lowConfList to keep track of antecendents
                        % that do not have high enough confidence
                        lowConfList{end+1} = antecendentlist(l,:);
                    end
                end
            end
        end        
    end
end

% Sort the association rules by confidence and support
confidence = round(conf * 10000) / 10000;
support = round(sup * 10000) / 10000;
if(isempty(confidence))
   AR = "No association rules found that support the minimum confidence"; 
else
   [~,srtidx] = sortrows([confidence',support'],[-1,-2]);
    confidence = confidence(srtidx);
    support = support(srtidx);
    AR = AR(srtidx); 
end