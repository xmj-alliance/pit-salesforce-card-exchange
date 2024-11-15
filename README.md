# pit-salesforce-card-exchange

This pit is for unit test designs mainly with Apex Mockery library

## Prerequisites

Install [Apex Mockery][apexMockeryLink] in your org.

## Use case

This is an imaginary exchange cards trading platform.

An Account is the customer intending to sell cards.

A Product is the definition of a trading card

The custom object TradingProduct is the enlisted trading cards in the market.

## Scenarios

### As a customer, I want to know how may trading cards I have enlisted

(TradingProduct Trigger handler)

### As an Admin, I can see the customer ranking from App home page

(Account controller)

## SF CLI Readme

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
