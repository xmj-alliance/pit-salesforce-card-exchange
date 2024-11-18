@IsTest
public with sharing class TinyTestWorkshop {
  public static List<Account> buildAccounts(Integer howMany) {
    List<Account> accounts = new List<Account>();

    for (Integer i = 0; i < howMany; i++) {
      accounts.add(new Account(Name = 'Account ' + string.valueOf(i)));
    }
    return accounts;
  }

  public static List<Trading_Product__c> buildTradingProducts(Integer howMany) {
    List<Trading_Product__c> tradingProducts = new List<Trading_Product__c>();

    for (Integer i = 0; i < howMany; i++) {
      tradingProducts.add(new Trading_Product__c());
    }
    return tradingProducts;
  }
}
