# pit-salesforce-card-exchange

This pit builds processes in an imaginary exchange cards trading platform and displays the unit test designs without DB operations.

It mainly depends on the Apex Mockery library.

It leverages the dependency injection pattern to separate the business logic and tests.

![topAccounts](https://imgur.com/9JZtZ1A.jpeg)

## Test runs

Because the tests do not contain DB operations, they are blazing fast!

![testRuns](https://imgur.com/xo8vRyC.jpeg)

## Prerequisites

- Install [Apex Mockery][apexMockeryLink] in your org.
- Deploy the source to your Org
- Assign "Card_Exchange" Permission set to your users.
- Create several Accounts and Products, then run `assignRandomCardsToAccounts.apex`

## Use case

This is an imaginary exchange card trading platform.

An Account is a customer intending to sell cards.

A Product is the definition of a trading card.

The custom object `TradingProduct` stores the enlisted trading cards in the market.

## Scenarios

### As a customer, I want to know how many trading cards I have enlisted

The `Trading_Cards_Count__c` field in the `Account` object shows how many trading cards this customer has.

It is a number field updated after a `TradingProduct` object is created and linked to this Account.

#### Implementation

Every time a `TradingProduct` is inserted, the total number of `TradingProduct` under this Account is re-counted, and the `Trading_Cards_Count__c` field is updated.

- `TradingProductHandler.cls`
  - The `afterInsert()` method deals with trading card recounting.
  - Both class constructors are private. Consumer of this class is expected to call the public `build()` method when they use this class.
  - However, the constructor with input `Map<String, Object> dependencyMap` is `@TestVisible`. When it comes to unit tests, `build()` method should not be called. Its dependencies are expected to be mocked and passed in with this constructor during class instantiation.
  - The dependency map expects interfaces rather than actual classes, which allows the test mock version to be used during unit tests. The mocked version can have zero DB operations in it, which is a lot faster than the one with DB operations.
    - In this class, `IAccountSelector` and `ITradingProductSelector` are demanded for SOQL queries, and `IDBModifier` for DML.
    - The public `build()` method automatically instantiates the instances with real DB operations: `AccountSelector`, `TradingProductSelector`, and `DBModifier`.
  - The current records coming from the `TradingProduct` Trigger can be simply passed in by calling the `fromSnip(TriggerSnip snip)` method

#### Testing

All tests are done without accessing DB.

The tests use the Apex-Mockery library, the one based on Apex Stub API.

- `TradingProductHandlerTest.cls`
  - In the preparation stage, each selector (SOQL) method used in the `TradingProductHandler` class is mocked to return a value. Each DBModifier (DML) method is mocked but without returning a value.
    - Even if a method does not return a value, it is still required to be mocked. Otherwise, it becomes `null`, throws a `NullPointerException`, and breaks the tests.
  - The mocked dependencies are packed into a Map
  - In the Action stage, the `TradingProductHandler` is instantiated by calling the `@TestVisible` version of the constructor, passing in the dependency map.
    - Without doing `insert tradingProducts`, which is guaranteed to access DB, Mocking dependencies speeds up the unit tests drastically, plus allowing us to test only the parts needed.
  - In the verification stage, the updated records is fetched by reading from the DB Modifier spy configured in the perparation stage. Afterward, the normal asserts are in place.

### As an Admin, I can see the customer ranking from the App home page

A lightning page with a custom LWC has been created, and configured as the app home page.

The lightning table inside the LWC displays the accounts and number of their related Trading Products.

The table is sorted by the Trading Products count in descending order.

#### Implementation

The `AccountController` is defined with the `@AuraEnabled` method inside, exposed to the Lightning Components.

Due to the static context of controller methods, it is hard to implement dependency injection patterns directly in a controller class. Therefore, a service class is defined without static business logic methods. Then, dependency injection becomes possible.

The service class handles Account queries.

- `AccountService.cls`
  - The `getTradingRankingAccounts` method handles Account queries.
  - Similar to `TradingProductHandler`, both class constructors are private. Consumer calls the public `build()` method to instantiate.
    - The public `build()` method automatically instantiates the instances with real DB operations: `AccountSelector`
    - The `@TestVisible` constructor with `Map<String, Object> dependencyMap` input allows unit tests to inject test dependencies.
- `AccountController.cls`
  - Builds the service instance
  - Point the static `@AuraEnabled` methods to the service methods
  - No constructors defined

#### Testing

Similar to Trading Product tests, the tests here have no DB accesses.

- `AccountServiceTest.cls`
  - In the preparation stage, the only selector (SOQL) method used in the `AccountService` class is mocked to return a value.
  - The mocked dependencies are packed into a Map
  - In the Action stage, the `AccountService` is instantiated by calling the `@TestVisible` version of the constructor, passing in the dependency map. Then, the target method is called.
  - In the verification stage, the result comes directly from the target method return value. Then, the result is asserted.
- `AccountControllerTest.cls`
  - Since the business logic sits in its related service class, there is no need to test again here.
  - It contains only dummy tests that boost code coverage.
  - All the methods are mocked to prevent `NullPointerException`.

## Appendix - SF CLI Readme

### Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

### How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

### Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

### Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

<!-- Refs -->

[apexMockeryLink]: https://github.com/salesforce/apex-mockery
