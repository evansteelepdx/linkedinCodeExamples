import { LightningElement, track } from 'lwc';

export default class WindowTest extends LightningElement {
    @track vendor = 'Apple Inc.';
    @track person = 'Steve Wozniak';

    handleVendor() {
        console.log(window.windowFunction);
        if (!window.getVendor) {
            console.log('The windowReciever component is likely missing from the page');
        } else {
            this.vendor = window.getVendor();
            this.person = window.myResult;
        }
    }
}