public with sharing class AccountSelector implements IAccountSelector {
  public Account[] selectByID(Set<Id> ids) {
    return [
      SELECT Id, Name, Description
      FROM Account
      WHERE Id IN :ids
    ];
  }
}
