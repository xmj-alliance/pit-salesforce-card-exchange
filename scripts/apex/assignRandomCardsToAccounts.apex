List<Trading_Product__c> inserting = new List<Trading_Product__c>();

List<Account> accs = [
  SELECT Id
  FROM Account
];

List<Product2> products = [
  SELECT Id
  FROM Product2
];

Integer productsCount = products.size();

for (Account currentAcc : accs) {
  Integer howManyCardsToGive = ListUtils.buildRandomIntegerBetween(
    new List<Integer>{ 0, productsCount - 1 },
    1
  )[0];

  List<Integer> givingCardIndexes = ListUtils.buildRandomIntegerBetween(
    new List<Integer>{ 0, productsCount - 1 },
    howManyCardsToGive
  );

  for (Integer index : givingCardIndexes) {
    Trading_Product__c tp = new Trading_Product__c(
      Account__c = currentAcc.Id,
      Product__c = products[index].Id
    );
    inserting.add(tp);
  }
}

insert inserting;
