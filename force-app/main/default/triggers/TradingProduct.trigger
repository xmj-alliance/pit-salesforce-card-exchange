trigger TradingProduct on Trading_Product__c(after insert, after update) {
  TriggerSnip snip = new TriggerSnip();
  snip.OldList = Trigger.Old;
  snip.OldMap = Trigger.OldMap;
  snip.NewList = Trigger.New;
  snip.NewMap = Trigger.NewMap;

  TradingProductHandler handler = TradingProductHandler.build().fromSnip(snip);

  switch on Trigger.operationType {
    when AFTER_INSERT {
      handler.afterInsert();
    }
    when AFTER_UPDATE {
    }
    when else {
      throw new PCEException(
        'Trigger operationType not implemented: ' +
        String.valueOf(Trigger.operationType)
      );
    }
  }
}
