import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import Id from "@salesforce/user/Id";

export default class ChatGreetingComponent extends LightningElement {
  userId = Id;
  handleSuccess(event) {
    const toastEvent = new ShowToastEvent({
      title: "Greeting changed successfully",
      variant: "success",
      message:
        "To apply changes, log out of Omni-Channel and log into Omni-Channel again."
    });
    this.dispatchEvent(toastEvent);
  }
}
