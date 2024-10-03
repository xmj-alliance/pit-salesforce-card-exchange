@IsTest
public with sharing class MockDBModifier implements IDBModifier {
  @TestVisible
  private SObject[] insertedRecords = new List<SObject>{};

  @TestVisible
  private SObject[] updatedRecords = new List<SObject>{};

  public Database.SaveResult[] doInsert(List<SObject> records) {
    Database.SaveResult[] saveResults = new List<Database.SaveResult>{};

    for (SObject record : records) {
      Database.SaveResult saveResult = (Database.SaveResult) JSON.deserialize(
        '{"success":true,"id":"Some ID"}',
        Database.SaveResult.class
      );
      saveResults.add(saveResult);
      insertedRecords.add(record);
    }

    return saveResults;
  }

  public Database.SaveResult[] doUpdate(List<SObject> records) {
    Database.SaveResult[] saveResults = new List<Database.SaveResult>{};

    for (SObject record : records) {
      Database.SaveResult saveResult = (Database.SaveResult) JSON.deserialize(
        '{"success":true,"id":"Some ID"}',
        Database.SaveResult.class
      );
      saveResults.add(saveResult);
      updatedRecords.add(record);
    }

    return saveResults;
  }

  public Database.UpsertResult[] doUpsert(List<SObject> records) {
    // TODO
    throw new NotImplementedException();
  }

  public class NotImplementedException extends Exception {
  }
}
