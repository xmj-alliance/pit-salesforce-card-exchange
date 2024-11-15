public with sharing class MockUtils {
  public static List<SObject> getModifiedMockData(MethodSpy dbModifierSpy) {
    List<Object> spyArgs = dbModifierSpy.callLog.getLast();
    return (List<SObject>) spyArgs[0];
  }
}
