import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';


export default class PresenceUtil extends LightningElement {
    connectedCallback() {
        this.handleSubscribe();
    }
    handleSubscribe() {
        const messageCallback = (response) => {
            const selectedEvent = new CustomEvent('userpresence', { detail: JSON.stringify(response) });
            this.dispatchEvent(selectedEvent);
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe('/topic/UserServicePresence', -1, messageCallback).then(response => {
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
        });
    }
}