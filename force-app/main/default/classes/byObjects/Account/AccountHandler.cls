public with sharing class AccountHandler {
  public void afterUpdate() {
    system.debug('is Account afterUpdate');
  }
}
