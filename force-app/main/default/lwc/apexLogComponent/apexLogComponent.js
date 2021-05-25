import { LightningElement } from "lwc";
import getApexLogList from "@salesforce/apex/apexLogComponentController.getApexLogList";

export default class ApexLogComponent extends LightningElement {
  searchKey = "";
  logIds;
  error;

  handleKeyChange(event) {
    this.searchKey = event.target.value;
  }

  handleLoad() {
    getApexLogList({ searchKey: this.searchKey })
      .then((result) => {
        this.logIds = result;
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.logIds = undefined;
      });
  }
}
