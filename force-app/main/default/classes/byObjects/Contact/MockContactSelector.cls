@IsTest
public with sharing class MockContactSelector extends MockDBSelector implements IContactSelector {
  // unusual results
  private ContactCountingWrapper[] getContactCountingsResults = new List<ContactCountingWrapper>{};

  // Interface implementations
  public ContactCountingWrapper[] getContactCountings(Set<Id> contactIDs) {
    return getContactCountingsResults;
  }

  // unusual assignments
  public void assignContactCountings(ContactCountingWrapper[] newResults) {
    getContactCountingsResults = newResults;
  }
}
