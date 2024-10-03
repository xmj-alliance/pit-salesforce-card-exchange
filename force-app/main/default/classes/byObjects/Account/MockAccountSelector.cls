@IsTest
public with sharing class MockAccountSelector extends MockDBSelector implements IAccountSelector {
  // Interface implementations
  public Account[] selectByID(Set<Id> ids) {
    return get('selectByID');
  }
}
