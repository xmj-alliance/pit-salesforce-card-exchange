public interface IAccountSelector {
  Account[] selectByID(Set<Id> ids);
  Account[] selectForTradingRanking(Integer topNumber);
}
