import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import myJs from '@salesforce/resourceUrl/myJs';
export default class WindowReciever extends LightningElement {

    connectedCallback() {
        Promise.all([
            loadScript(this, myJs + '/library.js'),
        ])
            .then((data) => {
                console.log(window.windowFunction);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading myJS',
                        message: error.message,
                        variant: 'error'
                    })
                );
            })
        // This window method is added outside of the static resource context
        if (!window.getVendor) {
            window.getVendor = function () {
                console.log(window.navigator.appName);
                return window.navigator.appName
            };
            window.myResult = (function () {
                var name = "a different app publisher";
                return name;
            })();
        }
    }
}