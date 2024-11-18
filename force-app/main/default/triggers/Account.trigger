trigger Account on Account(after insert, after update) {
  AccountHandler handler = new AccountHandler();
  switch on Trigger.operationType {
    when AFTER_INSERT {
    }
    when AFTER_UPDATE {
      handler.afterUpdate();
    }
    when else {
      throw new PCEException(
        'Trigger operationType not implemented: ' +
        String.valueOf(Trigger.operationType)
      );
    }
  }
}
