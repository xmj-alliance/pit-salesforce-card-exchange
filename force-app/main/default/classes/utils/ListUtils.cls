public with sharing class ListUtils {
  /**
   * @description Swap two objects In Place
   * @param twoObjects a list of 2 objects to swap
   */
  public static void swap(List<Object> twoObjects) {
    // swap position
    Object tmp = twoObjects[0];
    twoObjects[0] = twoObjects[1];
    twoObjects[1] = tmp;
  }

  /**
   * @description build a random Integer number ∈ [minValue, maxValue)
   * @param bounds a tupple of [minValue, maxValue]
   */
  public static Integer buildRandomIntegerBetween(Integer[] bounds) {
    return buildRandomIntegerBetween(bounds, 1)[0];
  }

  /**
   * @description build a random Long number ∈ [minValue, maxValue)
   * @param bounds a tupple of [minValue, maxValue]
   */
  public static Long buildRandomIntegerBetween(Long[] bounds) {
    return buildRandomIntegerBetween(bounds, 1)[0];
  }

  /**
   * @description build a list of random Integer numbers ∈ [minValue, maxValue)
   * @param bounds a tupple of [minValue, maxValue]
   * @param count How many to generate
   */
  public static List<Integer> buildRandomIntegerBetween(
    Integer[] bounds,
    Integer count
  ) {
    if (bounds[0] > bounds[1]) {
      swap(bounds);
    }

    Integer minValue = bounds[0];
    Integer maxValue = bounds[1];

    List<Integer> results = new List<Integer>();

    for (Integer i = 0; i < count; i++) {
      results.add(
        Math.floor(Math.random() * (maxValue - minValue) + minValue).intValue()
      );
    }

    return results;
  }

  /**
   * @description build a list of random Long numbers ∈ [minValue, maxValue)
   * @param bounds a tupple of [minValue, maxValue]
   * @param count How many to generate
   */
  public static List<Long> buildRandomIntegerBetween(
    Long[] bounds,
    Long count
  ) {
    if (bounds[0] > bounds[1]) {
      swap(bounds);
    }

    Long minValue = bounds[0];
    Long maxValue = bounds[1];

    List<Long> results = new List<Long>();

    for (Long i = 0; i < count; i++) {
      results.add(
        Math.floor(Math.random() * (maxValue - minValue) + minValue).longValue()
      );
    }

    return results;
  }
}
