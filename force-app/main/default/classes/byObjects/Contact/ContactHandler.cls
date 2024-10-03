public with sharing class ContactHandler {
  private IAccountSelector accountSelectorInstance;
  private IContactSelector contactSelectorInstance;
  private IDBModifier dbModifierInstance;

  private List<Contact> oldContacts;
  private Map<Id, SObject> oldContactMap;
  private List<Contact> newContacts;
  private Map<Id, SObject> newContactMap;

  public void afterInsert() {
    // After a Contact is inserted
    // Count the belonging contacts for each related Account
    // Update these Accounts' Description

    Set<Id> accountIDs = new Set<Id>();
    Set<Id> contactIDs = new Set<Id>();

    for (Contact currentContact : newContacts) {
      contactIDs.add(currentContact.Id);
      if (currentContact.AccountId != null) {
        accountIDs.add(currentContact.AccountId);
      }
    }

    Account[] relatedAccounts = accountSelectorInstance.selectByID(accountIDs);

    Map<Id, Account> relatedAccountMap = new Map<Id, Account>(relatedAccounts);

    ContactCountingWrapper[] contactCountings = contactSelectorInstance.getContactCountings(
      contactIDs
    );

    for (ContactCountingWrapper counting : contactCountings) {
      Account relatedAccount = relatedAccountMap.get(counting.AccountID);
      if (relatedAccount == null) {
        continue;
      }
      relatedAccount.Description =
        'This account has ' +
        counting.ContactsCount +
        ' Contacts now!';
    }

    dbModifierInstance.doUpdate(relatedAccounts);
  }

  public ContactHandler fromSnip(TriggerSnip snip) {
    // Not casting Maps
    // To avoid Invalid conversion from runtime type Map<Id, SObject> to Map<Id, Contact>
    oldContacts = (List<Contact>) snip.OldList;
    oldContactMap = snip.OldMap;
    newContacts = (List<Contact>) snip.NewList;
    newContactMap = snip.NewMap;

    return this;
  }

  public static ContactHandler build() {
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => new AccountSelector(),
      'IContactSelector' => new ContactSelector(),
      'IDBModifier' => new DBModifier()
    };
    return build(dependencyMap);
  }

  @TestVisible
  private static ContactHandler build(Map<String, Object> dependencyMap) {
    ContactHandler instance = new ContactHandler();
    instance.accountSelectorInstance = (IAccountSelector) dependencyMap.get(
      'IAccountSelector'
    );
    instance.contactSelectorInstance = (IContactSelector) dependencyMap.get(
      'IContactSelector'
    );
    instance.dbModifierInstance = (IDBModifier) dependencyMap.get(
      'IDBModifier'
    );

    return instance;
  }
}
