function ShoppingListHistogram
shoppingList = readDataFile;
cat = categorical([shoppingList{:}]);
histogram(cat);
%set(gca,'xtick',[])
set(gca,'TickLength',[0 0])
set(gca, 'FontSize', 8)
xlabel('items names') 
ylabel('frenquency') 
title('Histogram showing the frequency of the shoppingList items') 
end

