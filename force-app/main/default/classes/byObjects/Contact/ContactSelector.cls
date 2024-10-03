public with sharing class ContactSelector implements IContactSelector {
  public ContactCountingWrapper[] getContactCountings(Set<Id> contactIDs) {
    ContactCountingWrapper[] wrappers = new List<ContactCountingWrapper>{};
    List<AggregateResult> rawResults = [
      SELECT Account.Id, count(Id) contactCount
      FROM Contact
      WHERE Id IN :contactIDs
      GROUP BY Account.Id
    ];

    for (AggregateResult counting : rawResults) {
      ContactCountingWrapper wrapper = new ContactCountingWrapper();
      wrapper.AccountID = (Id) counting.get('Id');
      wrapper.ContactsCount = (Integer) counting.get('contactCount');
      wrappers.add(wrapper);
    }

    return wrappers;
  }
}
