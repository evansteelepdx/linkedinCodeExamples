import { LightningElement, api } from "lwc";
import getUserServicePresence from "@salesforce/apex/fetchPresenceDetails.getUserServicePresence";
export default class PresenceListener extends LightningElement {
  @api presenceArray = [];
  awayStatus;
  handleNotification(event) {
    const textVal = JSON.parse(event.detail);
    getUserServicePresence({
      uspID: textVal.data.sobject.Id
    })
      .then((data) => {
        if (data.IsAway == true) {
          this.awayStatus = "🟠 ";
        } else {
          this.awayStatus = "🟢 ";
        }
        this.presenceArray = [
          ...this.presenceArray,
          {
            awayStatus: this.awayStatus,
            data: data
          }
        ];
        console.log(this.presenceArray);
      })
      .catch((error) => {
        console.error(error);
      });
  }
}
