public interface ITradingProductSelector {
  TradingProductCountingWrapper[] getCountings(Set<Id> tradingProductIDs);
}
