import BaseChatMessage from "lightningsnapin/baseChatMessage";
import { track } from "lwc";

import chat_knowledge_logo from "@salesforce/resourceUrl/chat_knowledge_logo";

const CHAT_CONTENT_CLASS = "chat-content";
const CHAT_LINK_CLASS = "chat-link";
const AGENT_USER_TYPE = "agent";
const CHASITOR_USER_TYPE = "chasitor";
const SUPPORTED_USER_TYPES = [AGENT_USER_TYPE, CHASITOR_USER_TYPE];

export default class KnowledgeChatMessage extends BaseChatMessage {
  @track messageStyle = "";
  @track knowledgeURL = "";
  @track isLinkVisible = false;
  @track isMessageVisible = true;
  knowledgeImage;

  isValidHttpUrl(string) {
    let url;
    try {
      url = new URL(string);
    } catch (e) {
      return false;
    }
    return url.protocol === "http:" || url.protocol === "https:";
  }

  isSupportedUserType(userType) {
    return SUPPORTED_USER_TYPES.some(
      (supportedUserType) => supportedUserType === userType
    );
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
        this.knowledgeImage = chat_knowledge_logo;
        this.messageStyle = CHAT_LINK_CLASS;
        this.knowledgeURL = element.innerText;
        this.isLinkVisible = true;
        this.isMessageVisible = false;
      } else {
        this.isLinkVisible = false;
        this.isMessageVisible = true;
      }
    } else {
      throw new Error(`Unsupported user type passed in: ${this.userType}`);
    }
  }
}
