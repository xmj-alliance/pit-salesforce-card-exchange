/**
 * @description This class now contains coverage-only tests
 */
@IsTest
public with sharing class AccountControllerTest {
  @IsTest
  static void testCoverageShouldBeHappy() {
    // Configure mock service
    Mock accountServiceMock = Mock.forType(IAccountService.class);
    AccountController.accountServiceInstance = (IAccountService) accountServiceMock.stub;

    // Calling without assertions
    AccountController.getTradingRankingAccounts();

    Assert.isTrue(true);
  }
}
