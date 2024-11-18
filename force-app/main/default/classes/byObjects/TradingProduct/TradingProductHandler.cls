public with sharing class TradingProductHandler {
  private IAccountSelector accountSelectorInstance;
  private ITradingProductSelector tradingProductSelectorInstance;
  private IDBModifier dbModifierInstance;

  private List<Trading_Product__c> oldTradingProducts;
  private Map<Id, SObject> oldTradingProductMap;
  private List<Trading_Product__c> newTradingProducts;
  private Map<Id, SObject> newTradingProductMap;

  public TradingProductHandler fromSnip(TriggerSnip snip) {
    // Not casting Maps
    // To avoid Invalid conversion from runtime type Map<Id, SObject> to Map<Id, Contact>
    oldTradingProducts = (List<Trading_Product__c>) snip.OldList;
    oldTradingProductMap = snip.OldMap;
    newTradingProducts = (List<Trading_Product__c>) snip.NewList;
    newTradingProductMap = snip.NewMap;

    return this;
  }

  private TradingProductHandler() {
  }

  @TestVisible
  private TradingProductHandler(Map<String, Object> dependencyMap) {
    this.accountSelectorInstance = (IAccountSelector) dependencyMap.get(
      'IAccountSelector'
    );
    this.tradingProductSelectorInstance = (ITradingProductSelector) dependencyMap.get(
      'ITradingProductSelector'
    );
    this.dbModifierInstance = (IDBModifier) dependencyMap.get('IDBModifier');
  }

  public static TradingProductHandler build() {
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => new AccountSelector(),
      'ITradingProductSelector' => new TradingProductSelector(),
      'IDBModifier' => new DBModifier()
    };
    return new TradingProductHandler(dependencyMap);
  }

  public void afterInsert() {
    // After a Trading Product is inserted
    // Count the belonging Trading Products for each related Account
    // Update these Accounts' Card Count field

    Set<Id> accountIDs = new Set<Id>();
    Set<Id> tradingProductIDs = new Set<Id>();

    for (Trading_Product__c tProduct : newTradingProducts) {
      tradingProductIDs.add(tProduct.Id);
      accountIDs.add(tProduct.Account__c);
    }

    Account[] relatedAccounts = accountSelectorInstance.selectByID(accountIDs);
    Map<Id, Account> relatedAccountMap = new Map<Id, Account>(relatedAccounts);

    TradingProductCountingWrapper[] tradingProductCountings = TradingProductSelectorInstance.getCountings(
      tradingProductIDs
    );

    for (TradingProductCountingWrapper counting : tradingProductCountings) {
      Account relatedAccount = relatedAccountMap.get(counting.AccountID);
      if (relatedAccount == null) {
        continue;
      }
      relatedAccount.Trading_Cards_Count__c = counting.TradingProductsCount;
    }

    dbModifierInstance.doUpdate(relatedAccounts);
  }
}
