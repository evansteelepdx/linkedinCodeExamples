import { LightningElement, track } from "lwc";
import getApexLogList from "@salesforce/apex/apexLogComponentController.getApexLogList";
import getTraceTargets from "@salesforce/apex/apexLogComponentController.getTraceTargets";

export default class ApexLogComponent extends LightningElement {
  @track searchKey = "";
  @track logUserValue = "";
  @track logUserOptions = [];

  logIds;
  error;

  handleKeyChange(event) {
    this.searchKey = event.target.value;
  }

  logUserChange(event) {
    this.logUserValue = event.target.value;
  }

  handleLoad() {
    getApexLogList({ searchTerm: this.logUserValue })
      .then((result) => {
        this.logIds = result;
        this.error = undefined;
        console.log(this.logIds);
      })
      .catch((error) => {
        this.error = error;
        this.logIds = undefined;
      });
  }
  connectedCallback() {
    getTraceTargets({})
      .then((result) => {
        var tmpLogOptions = [];
        for (const element of result) {
          tmpLogOptions.push({ label: element, value: element });
        }
        console.log(tmpLogOptions);
        this.logUserOptions = JSON.parse(JSON.stringify(tmpLogOptions));
      })

      .catch((error) => {
        console.error(error);
      });
  }
}
