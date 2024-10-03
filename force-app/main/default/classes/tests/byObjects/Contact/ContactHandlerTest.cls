@IsTest
public with sharing class ContactHandlerTest {
  static RandomGenerator randomGeneratorInstance = new RandomGenerator();
  @IsTest
  static void whenInsertedWithSameAccount_shouldUpdateAccountDescription() {
    // Arrange
    List<Account> accounts = buildAccounts(1);
    accounts[0].Id = randomGeneratorInstance.buildId(Account.getSObjectType());

    Integer contactsCount = 3;
    List<Contact> contacts = buildContacts(contactsCount);
    List<Id> contactIDs = randomGeneratorInstance.buildId(
      Contact.getSObjectType(),
      contactsCount
    );

    for (Integer i = 0; i < contactsCount; i++) {
      contacts[i].Id = contactIDs[i];
      contacts[i].AccountId = accounts[0].Id;
    }

    ContactCountingWrapper contactCountingResult = new ContactCountingWrapper();
    contactCountingResult.AccountID = accounts[0].Id;
    contactCountingResult.ContactsCount = contactsCount;

    // Configure mock SOQL results
    MockAccountSelector accountSelectorInstance = new MockAccountSelector();
    accountSelectorInstance.assign('selectByID', accounts);

    MockContactSelector contactSelectorInstance = new MockContactSelector();
    contactSelectorInstance.assignContactCountings(
      new List<ContactCountingWrapper>{ contactCountingResult }
    );

    MockDBModifier dbModifierInstance = new MockDBModifier();

    // Prepare the dependency map
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => accountSelectorInstance,
      'IContactSelector' => contactSelectorInstance,
      'IDBModifier' => dbModifierInstance
    };

    // Act
    Test.startTest();
    TriggerSnip snip = new TriggerSnip().fromList(contacts);
    ContactHandler.build(dependencyMap).fromSnip(snip).afterInsert();
    Test.stopTest();

    // Verify
    Account updatedAccount = (Account) dbModifierInstance.updatedRecords[0];

    Assert.isNotNull(updatedAccount.Description);

    Assert.isTrue(
      updatedAccount.Description.contains('3 Contacts'),
      'Account Description should say "now has 3 Contacts" but get ' +
      updatedAccount.Description
    );
  }

  @IsTest
  static void whenInsertedWithNoAccount_shouldNotCrash() {
    List<Contact> contacts = buildContacts(1);
    contacts[0].Id = randomGeneratorInstance.buildId(Contact.getSObjectType());

    // Configure mock SOQL results
    // -> No need to setup results in this test
    //    as the default results are empty lists

    // Prepare the dependency map
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => new MockAccountSelector(),
      'IContactSelector' => new MockContactSelector(),
      'IDBModifier' => new MockDBModifier()
    };

    // Act
    Test.startTest();
    TriggerSnip snip = new TriggerSnip().fromList(contacts);
    ContactHandler.build(dependencyMap).fromSnip(snip).afterInsert();
    Test.stopTest();

    // We are not crashed, yay!
    Assert.isTrue(true);
  }

  @IsTest
  static void whenInsertedLargeQuantities_shouldUpdateAccountDescriptions() {
    SObjectType AccountTYPE = Account.getSObjectType();
    SObjectType ContactTYPE = Contact.getSObjectType();

    // 100 new Contacts under 100 Accounts
    // Arrange
    Integer accountsCount = 100;
    List<Account> accounts = buildAccounts(accountsCount);
    for (Integer i = 0; i < accountsCount; i++) {
      accounts[i].Id = randomGeneratorInstance.buildId(AccountTYPE);
    }

    Integer contactsCount = 100;
    List<Contact> contacts = buildContacts(contactsCount);
    for (Integer i = 0; i < contactsCount; i++) {
      contacts[i].Id = randomGeneratorInstance.buildId(ContactTYPE);
      contacts[i].AccountId = accounts[i].Id;
    }

    ContactCountingWrapper[] contactCountingResults = new List<ContactCountingWrapper>{};
    for (Integer i = 0; i < accountsCount; i++) {
      ContactCountingWrapper contactCountingResult = new ContactCountingWrapper();
      contactCountingResult.AccountID = accounts[i].Id;
      contactCountingResult.ContactsCount = 1;
      contactCountingResults.add(contactCountingResult);
    }

    // Configure mock SOQL results
    MockAccountSelector accountSelectorInstance = new MockAccountSelector();
    accountSelectorInstance.assign('selectByID', accounts);

    MockContactSelector contactSelectorInstance = new MockContactSelector();
    contactSelectorInstance.assignContactCountings(contactCountingResults);

    MockDBModifier dbModifierInstance = new MockDBModifier();

    // Prepare the dependency map
    Map<String, Object> dependencyMap = new Map<String, Object>{
      'IAccountSelector' => accountSelectorInstance,
      'IContactSelector' => contactSelectorInstance,
      'IDBModifier' => dbModifierInstance
    };

    // Act
    Test.startTest();
    TriggerSnip snip = new TriggerSnip().fromList(contacts);
    ContactHandler.build(dependencyMap).fromSnip(snip).afterInsert();
    Test.stopTest();

    // Verify
    Account updatedAccount = (Account) dbModifierInstance.updatedRecords[
      accountsCount - 1
    ];

    Assert.isNotNull(updatedAccount.Description);
  }

  static List<Account> buildAccounts(Integer howMany) {
    List<Account> accounts = new List<Account>();

    for (Integer i = 0; i < howMany; i++) {
      accounts.add(new Account(Name = 'Account ' + string.valueOf(i)));
    }
    return accounts;
  }

  static List<Contact> buildContacts(Integer howMany) {
    List<Contact> contacts = new List<Contact>();

    for (Integer i = 0; i < howMany; i++) {
      contacts.add(
        new Contact(
          FirstName = 'Contact ' + string.valueOf(i),
          LastName = 'Testonics'
        )
      );
    }
    return contacts;
  }
}
