public with sharing class AccountService implements IAccountService {
  private final IAccountSelector accountSelectorInstance;

  private AccountService() {
  }

  @TestVisible
  private AccountService(Map<String, Object> dependencyMap) {
    this.accountSelectorInstance = (IAccountSelector) dependencyMap.get(
      'IAccountSelector'
    );
  }

  public static AccountService build() {
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => new AccountSelector()
    };
    return new AccountService(dependencyMap);
  }

  public List<Account> getTradingRankingAccounts() {
    return accountSelectorInstance.selectForTradingRanking(10);
  }
}
