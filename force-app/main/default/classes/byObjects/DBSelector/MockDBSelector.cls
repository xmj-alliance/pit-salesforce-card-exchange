public virtual class MockDBSelector {
  Map<String, SObject[]> mockResultsMap = new Map<String, SObject[]>{};

  public SObject[] get(String methodName) {
    SObject[] results = mockResultsMap.get(methodName);
    if (results == null) {
      results = new List<SObject>{};
      mockResultsMap.put(methodName, results);
    }
    return results;
  }

  public void assign(String methodName, SObject[] newResults) {
    mockResultsMap.put(methodName, newResults);
  }

  public void assign(Map<String, SObject[]> additionalResultMap) {
    for (String methodName : additionalResultMap.keySet()) {
      mockResultsMap.put(methodName, additionalResultMap.get(methodName));
    }
  }

  public void clear(String[] methodNames) {
    for (String methodName : methodNames) {
      clear(methodName);
    }
  }

  public void clear(String methodName) {
    mockResultsMap.put(methodName, new List<SObject>{});
  }
}
