public with sharing class RandomGenerator {
  private final List<String> characters = 'abcdefghijklmnopqrstuvwxyz0123456789'
    .split('');
  private final Integer charactersCount = characters.size();

  public String buildRandomString(Integer length) {
    String result = '';

    for (Integer i = 0; i < length; i++) {
      Integer currentCharIndex = Math.mod(
        Math.abs(Crypto.getRandomInteger()),
        charactersCount
      );

      result += characters[currentCharIndex];
    }

    return result;
  }

  public String buildRandomEmail() {
    return buildRandomEmail(6, 6, 'com');
  }

  public String buildRandomEmail(Integer nameLength) {
    return buildRandomEmail(nameLength, 6, 'com');
  }

  public String buildRandomEmail(
    Integer nameLength,
    Integer domainLength,
    String domainSuffix
  ) {
    return buildRandomString(nameLength) +
      '@' +
      buildRandomString(domainLength) +
      '.' +
      domainSuffix;
  }

  public String buildAutoNumber(BuildAutoNumberParam param) {
    String digits = String.valueOf(param.currentNumber);
    if (param.rightPad) {
      digits = digits.rightPad(param.totalDigitsCount, param.paddingCharacter);
    } else {
      digits = digits.leftPad(param.totalDigitsCount, param.paddingCharacter);
    }

    return param.prefix + digits + param.suffix;
  }

  public Id buildId(SObjectType buildType) {
    return buildId(buildType, 1)[0];
  }

  public List<Id> buildId(SObjectType buildType, Integer buildCount) {
    // SF 18-digit ID format:
    //      001                XXXXXXXXXXXX          AAA
    //
    //  SObject key prefix | central digits | Case identifier

    Integer centralDigitsCount = 12;

    List<Id> result = new List<Id>();

    // takes up 3 digits
    String prefix = buildType.getDescribe().getKeyPrefix();

    BuildAutoNumberParam autoNumParam = new BuildAutoNumberParam();
    autoNumParam.paddingCharacter = '0';
    autoNumParam.totalDigitsCount = centralDigitsCount;
    autoNumParam.prefix = prefix;
    autoNumParam.suffix = '';
    autoNumParam.rightPad = false;

    // get a random starting point
    Integer startingNumber = Math.abs(Crypto.getRandomInteger());

    for (Integer i = 0; i < buildCount; i++) {
      autoNumParam.currentNumber = startingNumber + i;
      result.add(Id.valueOf(buildAutoNumber(autoNumParam)));
    }
    return result;
  }

  public class BuildAutoNumberParam {
    Long currentNumber { get; set; }
    String paddingCharacter { get; set; }
    Integer totalDigitsCount { get; set; }
    String prefix { get; set; }
    String suffix { get; set; }
    Boolean rightPad { get; set; }
  }
}
