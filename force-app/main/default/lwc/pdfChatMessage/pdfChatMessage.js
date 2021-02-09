import BaseChatMessage from "lightningsnapin/baseChatMessage";
import { track } from "lwc";

const CHAT_CONTENT_CLASS = "chat-content";
const AGENT_USER_TYPE = "agent";
const CHASITOR_USER_TYPE = "chasitor";
const SUPPORTED_USER_TYPES = [AGENT_USER_TYPE, CHASITOR_USER_TYPE];

/**
 * Displays a chat message using the inherited api messageContent and is styled based on the inherited api userType and messageContent api objects passed in from BaseChatMessage.
 */
export default class ChatMessageDefaultUI extends BaseChatMessage {
  @track messageStyle = "";
  @track pdfURL = "";
  @track isPDFVisible = false;
  @track isMessageVisible = true;

  isSupportedUserType(userType) {
    return SUPPORTED_USER_TYPES.some(
      (supportedUserType) => supportedUserType === userType
    );
  }

  isValidHttpUrl(string) {
    let url;
    try {
      url = new URL(string);
    } catch (e) {
      return false;
    }
    return url.protocol === "http:" || url.protocol === "https:";
  }

  connectedCallback() {
    if (this.isSupportedUserType(this.userType)) {
      this.messageStyle = `${CHAT_CONTENT_CLASS} ${this.userType}`;
      let element = document.createElement("div");
      element.innerHTML = this.messageContent.value;
      if (
        this.userType === AGENT_USER_TYPE &&
        this.isValidHttpUrl(element.innerText)
      ) {
        this.pdfUrl = element.innerText;
        this.isPDFVisible = true;
        this.isMessageVisible = false;
      } else {
        this.isPDFVisible = false;
        this.isMessageVisible = true;
      }
    } else {
      throw new Error(`Unsupported user type passed in: ${this.userType}`);
    }
  }
}
