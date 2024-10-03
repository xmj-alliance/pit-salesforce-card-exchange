public with sharing class DBModifier implements IDBModifier {
  public Database.SaveResult[] doInsert(List<SObject> records) {
    return Database.insert(records);
  }

  public Database.SaveResult[] doUpdate(List<SObject> records) {
    return Database.update(records);
  }

  public Database.UpsertResult[] doUpsert(List<SObject> records) {
    return Database.upsert(records);
  }
}
