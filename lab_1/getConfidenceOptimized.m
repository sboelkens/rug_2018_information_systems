% Course: Information Systems
% Association Rule Analysis with Apriori
% Author: Dr. George Azzopardi
% Date: November 2018
function [AR,confidence,support] = getConfidenceOptimized(frequentItems, dataset, ntrans, trlbl, minconf, support)

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
%                     isSubsetOf = all(ismember(antecendentlist(l,:), lowConfList{x}{1})) && all(ismember(lowConfList{x}{2}, consequence));
%                     isSubsetOf = all(ismember(consequence, lowConfList{x}));
                    isSubsetOf = all(ismember(antecendentlist(l,:), lowConfList{x}));
                    if isSubsetOf
                       break;
                    end
                end
                if isSubsetOf
                    continue;
                end
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
                    AR{end+1} = [antecedentstr(1:end-1),' -> ',consequencestr(1:end-1),sprintf(' [%2.4f,%2.4f]',sup(end),conf(end))];
                else
                    % Improvement: if confidence is not high enough, store
                    % it in the lowConfList to keep track of antecendents
                    % that do not have high enough confidence
%                     lowConfList{end+1} = {antecendentlist(l,:), consequence};
%                     lowConfList{end+1} = consequence;
                    lowConfList{end+1} = antecendentlist(l,:);
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