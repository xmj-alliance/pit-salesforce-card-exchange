trigger Contact on Contact(after insert, after update) {
  TriggerSnip snip = new TriggerSnip();
  snip.OldList = Trigger.Old;
  snip.OldMap = Trigger.OldMap;
  snip.NewList = Trigger.New;
  snip.NewMap = Trigger.NewMap;

  ContactHandler handler = ContactHandler.build().fromSnip(snip);

  switch on Trigger.operationType {
    when AFTER_INSERT {
      handler.afterInsert();
    }
    when AFTER_UPDATE {
    }
    when else {
      system.debug('not implemented');
    }
  }
}
