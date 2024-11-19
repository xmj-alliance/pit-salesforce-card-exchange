import { LightningElement, wire } from "lwc";

// Apex
import getTradingRankingAccounts from "@salesforce/apex/AccountController.getTradingRankingAccounts";

/**
 * @typedef { import("./accountTradingRanking.interface").IAccountTrading } IAccountTrading
 */

export default class AccountTradingRanking extends LightningElement {
  get columns() {
    return [
      { label: "Account Name", fieldName: "name" },
      {
        label: "Trading Cards Count",
        fieldName: "tradingCardsCount",
        type: "number",
      },
    ];
  }

  /** @type { IAccountTrading[] } */
  displayingAccounts;

  @wire(getTradingRankingAccounts)
  accountsWire({ data, error }) {
    if (error) {
      this.error = error;
      console.error(error);
      return;
    }
    if (data) {
      const displayingAccounts = [];
      for (const datium of data) {
        displayingAccounts.push(this.#inboundAccount(datium));
      }
      this.displayingAccounts = displayingAccounts;
    }
  }

  /**
   * @param { any } account Salesforce Account object
   * @return { IAccountTrading } Displayed Account
   */
  #inboundAccount = (account) => {
    return {
      id: account.Id,
      name: account.Name,
      tradingCardsCount: account.Trading_Cards_Count__c,
    };
  };
}
