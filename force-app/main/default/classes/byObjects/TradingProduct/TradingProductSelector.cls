public with sharing class TradingProductSelector implements ITradingProductSelector {
  public TradingProductCountingWrapper[] getCountings(
    Set<Id> tradingProductIDs
  ) {
    TradingProductCountingWrapper[] wrappers = new List<TradingProductCountingWrapper>();
    List<AggregateResult> rawResults = [
      SELECT Account__c, count(Id) tradingProductsCount
      FROM Trading_Product__c
      WHERE Id IN :tradingProductIDs
      GROUP BY Account__c
    ];

    for (AggregateResult counting : rawResults) {
      TradingProductCountingWrapper wrapper = new TradingProductCountingWrapper();
      wrapper.AccountID = (Id) counting.get('Account__c');
      wrapper.TradingProductsCount = (Integer) counting.get(
        'tradingProductsCount'
      );
      wrappers.add(wrapper);
    }

    return wrappers;
  }
}
