public with sharing class AccountController {
  @TestVisible
  private static IAccountService accountServiceInstance = AccountService.build();

  @AuraEnabled(Cacheable=true)
  public static List<Account> getTradingRankingAccounts() {
    return accountServiceInstance.getTradingRankingAccounts();
  }
}
