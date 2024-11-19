public with sharing class AccountSelector implements IAccountSelector {
  public Account[] selectByID(Set<Id> ids) {
    return [
      SELECT Id, Name, Description
      FROM Account
      WHERE Id IN :ids
    ];
  }

  public Account[] selectForTradingRanking(Integer topNumber) {
    if (topNumber > 200 || topNumber <= 0) {
      topNumber = 200;
    }

    return [
      SELECT Id, Name, Trading_Cards_Count__c
      FROM Account
      ORDER BY Trading_Cards_Count__c DESC NULLS LAST
      LIMIT :topNumber
    ];
  }
}
