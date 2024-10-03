public interface IDBModifier {
  Database.SaveResult[] doInsert(List<SObject> records);
  Database.SaveResult[] doUpdate(List<SObject> records);
  Database.UpsertResult[] doUpsert(List<SObject> records);
}
