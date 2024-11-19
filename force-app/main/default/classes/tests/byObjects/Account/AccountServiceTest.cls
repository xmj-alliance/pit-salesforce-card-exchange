@IsTest
public with sharing class AccountServiceTest {
  static RandomGenerator randomGeneratorInstance = new RandomGenerator();

  static SObjectType ACCOUNT_TYPE = Account.getSObjectType();

  /**
   * @note In real scenarios I would still keep the DB operations within this test, since
   * the SOQL itself is intended to be tested.
   * But for this demo, I use mocking anyway
   */
  @IsTest
  static void shouldGetTopTradingAccounts() {
    // Arrange
    Integer accountsCount = 100;
    List<Account> accounts = TinyTestWorkshop.buildAccounts(accountsCount);
    List<Id> accountIDs = randomGeneratorInstance.buildId(
      ACCOUNT_TYPE,
      accountsCount
    );

    // Mocking result sorted by card count DESC
    for (Integer i = 0; i < accountsCount; i++) {
      accounts[i].Id = accountIDs[i];
      accounts[i].Trading_Cards_Count__c = accountsCount - i;
    }

    // Configure mock SOQL results
    Mock accountSelectorMock = Mock.forType(IAccountSelector.class);
    MethodSpy selectForTradingRankingSpy = accountSelectorMock.spyOn(
      'selectForTradingRanking'
    );
    selectForTradingRankingSpy.returns(accounts);

    // Prepare the dependency map
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => accountSelectorMock.stub
    };

    // Act
    Test.startTest();
    List<Account> toppingAccounts = new AccountService(dependencyMap)
      .getTradingRankingAccounts();
    Test.stopTest();

    Assert.areEqual(accountsCount, toppingAccounts.size());
    Assert.areEqual(accountsCount, toppingAccounts[0].Trading_Cards_Count__c);
  }
}
