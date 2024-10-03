public with sharing class TriggerSnip {
  public List<SObject> OldList { get; set; }
  public Map<Id, SObject> OldMap { get; set; }
  public List<SObject> NewList { get; set; }
  public Map<Id, SObject> NewMap { get; set; }

  /**
   * @description create a new instance from a list
   * Side Note: instances in `entities` will be REFed from oldList and OldMap
   * @param entities input SObjects
   * @return this instance
   */
  public TriggerSnip fromList(List<SObject> entities) {
    // set oldList to reference the input entities
    OldList = entities;
    NewList = new List<SObject>();
    OldMap = new Map<Id, SObject>();
    NewMap = new Map<Id, SObject>();

    for (SObject entity : entities) {
      SObject newEntity = entity.clone(true, false, true, true);
      NewList.add(newEntity);

      // create maps
      if (entity.Id != null) {
        OldMap.put(entity.Id, entity);
        NewMap.put(entity.Id, newEntity);
      }
    }

    return this;
  }
}
