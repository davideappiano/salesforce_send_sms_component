import { api, LightningElement, wire, track} from 'lwc';
import getTemplates from '@salesforce/apex/SMSTemplateCtrl.getSMSTemplates';
import getTemplateOptions from '@salesforce/apex/SMSTemplateCtrl.getSMSTemplateOptions';

export default class SendSMS extends LightningElement {
    //@track messageTemplateOptions;
    @wire(getTemplates)messageTemplates;
    templateMessage = '';
    @wire(getTemplateOptions)messageTemplateOptions;
    @track messageDescription = "";

    @api
    get message() {
        return this.messageDescription;
    }

    handleMessageChange(event){
        this.messageDescription = event.detail.value;
    }

    handleChange(event) {
        const selTemplateId = event.detail.value;
        const templates = this.messageTemplates.data;
        if(templates.length > 0){
            const selTemplate = templates.filter(template => template.Id === selTemplateId);

            this.templateMessage = selTemplate.length > 0 ? selTemplate[0].Message__c : '';
            this.messageDescription = this.templateMessage;
        }
    }
}