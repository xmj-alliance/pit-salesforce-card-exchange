@IsTest
public with sharing class TradingProductHandlerTest {
  static RandomGenerator randomGeneratorInstance = new RandomGenerator();

  static SObjectType ACCOUNT_TYPE = Account.getSObjectType();
  static SObjectType TRADING_PRODUCT_TYPE = Trading_Product__c.getSObjectType();

  @IsTest
  static void whenInsertedWithSameAccount_shouldUpdateAccountTradingProductsCount() {
    // Arrange
    List<Account> accounts = TinyTestWorkshop.buildAccounts(1);
    accounts[0].Id = randomGeneratorInstance.buildId(ACCOUNT_TYPE);

    Integer tradingProductsCount = 3;
    List<Trading_Product__c> tradingProducts = TinyTestWorkshop.buildTradingProducts(
      tradingProductsCount
    );
    List<Id> tradingProductIDs = randomGeneratorInstance.buildId(
      TRADING_PRODUCT_TYPE,
      tradingProductsCount
    );

    for (Integer i = 0; i < tradingProductsCount; i++) {
      tradingProducts[i].Id = tradingProductIDs[i];
      tradingProducts[i].Account__c = accounts[0].Id;
    }

    TradingProductCountingWrapper tradingProductsCountingResult = new TradingProductCountingWrapper();
    tradingProductsCountingResult.AccountID = accounts[0].Id;
    tradingProductsCountingResult.TradingProductsCount = tradingProductsCount;

    // Configure mock SOQL results
    Mock accountSelectorMock = Mock.forType(IAccountSelector.class);
    MethodSpy selectByIDSpy = accountSelectorMock.spyOn('selectByID');
    selectByIDSpy.returns(accounts);

    Mock tradingProductSelectorMock = Mock.forType(
      ITradingProductSelector.class
    );
    MethodSpy getCountingsSpy = tradingProductSelectorMock.spyOn(
      'getCountings'
    );
    getCountingsSpy.returns(
      new List<TradingProductCountingWrapper>{ tradingProductsCountingResult }
    );

    // Configure DML
    Mock dbModifierMock = Mock.forType(IDBModifier.class);
    MethodSpy doUpdateSpy = dbModifierMock.spyOn('doUpdate');

    // Prepare the dependency map
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => accountSelectorMock.stub,
      'ITradingProductSelector' => tradingProductSelectorMock.stub,
      'IDBModifier' => dbModifierMock.stub
    };

    // Act
    Test.startTest();
    TriggerSnip snip = new TriggerSnip().fromList(tradingProducts);
    new TradingProductHandler(dependencyMap).fromSnip(snip).afterInsert();
    Test.stopTest();

    // Verify
    List<Account> updatedAccounts = (List<Account>) MockUtils.getModifiedMockData(
      doUpdateSpy
    );
    Account updatedAccount = updatedAccounts[0];

    Assert.areEqual(
      tradingProductsCount,
      updatedAccount.Trading_Cards_Count__c
    );
  }

  @IsTest
  static void whenInsertedLargeQuantities_shouldUpdateAccountTradingProductsCount() {
    // Arrange
    Integer accountsCount = 100;
    List<Account> accounts = TinyTestWorkshop.buildAccounts(accountsCount);
    List<Id> accountIDs = randomGeneratorInstance.buildId(
      ACCOUNT_TYPE,
      accountsCount
    );

    for (Integer i = 0; i < accountsCount; i++) {
      accounts[i].Id = accountIDs[i];
    }

    Integer tradingProductsCount = 100;
    List<Trading_Product__c> tradingProducts = TinyTestWorkshop.buildTradingProducts(
      tradingProductsCount
    );
    List<Id> tradingProductIDs = randomGeneratorInstance.buildId(
      TRADING_PRODUCT_TYPE,
      tradingProductsCount
    );

    for (Integer i = 0; i < tradingProductsCount; i++) {
      tradingProducts[i].Id = tradingProductIDs[i];
      tradingProducts[i].Account__c = accounts[i].Id;
    }

    TradingProductCountingWrapper[] tradingProductsCountingResults = new List<TradingProductCountingWrapper>();
    for (Integer i = 0; i < accountsCount; i++) {
      TradingProductCountingWrapper countingResult = new TradingProductCountingWrapper();
      countingResult.AccountId = accounts[i].Id;
      countingResult.TradingProductsCount = 1;
      tradingProductsCountingResults.add(countingResult);
    }

    // Configure mock SOQL results
    Mock accountSelectorMock = Mock.forType(IAccountSelector.class);
    MethodSpy selectByIDSpy = accountSelectorMock.spyOn('selectByID');
    selectByIDSpy.returns(accounts);

    Mock tradingProductSelectorMock = Mock.forType(
      ITradingProductSelector.class
    );
    MethodSpy getCountingsSpy = tradingProductSelectorMock.spyOn(
      'getCountings'
    );
    getCountingsSpy.returns(tradingProductsCountingResults);

    // Configure DML
    Mock dbModifierMock = Mock.forType(IDBModifier.class);
    MethodSpy doUpdateSpy = dbModifierMock.spyOn('doUpdate');

    // Prepare the dependency map
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => accountSelectorMock.stub,
      'ITradingProductSelector' => tradingProductSelectorMock.stub,
      'IDBModifier' => dbModifierMock.stub
    };

    // Act
    Test.startTest();
    TriggerSnip snip = new TriggerSnip().fromList(tradingProducts);
    new TradingProductHandler(dependencyMap).fromSnip(snip).afterInsert();
    Test.stopTest();

    // Verify
    List<Account> updatedAccounts = (List<Account>) MockUtils.getModifiedMockData(
      doUpdateSpy
    );

    Account updatedAccount = (Account) updatedAccounts[accountsCount - 1];
    Assert.areEqual(1, updatedAccount.Trading_Cards_Count__c);
  }
}
