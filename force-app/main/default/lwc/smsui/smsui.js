import {LightningElement, track, api} from 'lwc';
import {
    FlowNavigationCancelEvent,
    FlowNavigationNextEvent,
} from 'lightning/flowSupport'
import { loadScript } from 'lightning/platformResourceLoader';
import PARSER from '@salesforce/resourceUrl/PapaParse';

export default class Smsui extends LightningElement {
    parserInitialized = false;
    loading = false;

    @api
    get references() {
        var el = this.template.querySelector('lightning-datatable');
        if(el != null) {
            var selected = el.getSelectedRows();
            return selected.map(sel => sel.REFERENCE);
        }
        return [];
    }
    
    @track _rows;

    get columns(){
        const columns = [
            { label: 'INDEX', fieldName: 'INDEX' },
            { label: 'REFERENCE', fieldName: 'REFERENCE' },
            { label: 'NAME', fieldName: 'NAME' },
            { label: 'FORNAME', fieldName: 'FORNAME' },
            { label: 'PHONENUMBER1', fieldName: 'PHONENUMBER1' },
            { label: 'PHONENUMBER2', fieldName: 'PHONENUMBER2' },
            { label: 'EMAIL1', fieldName: 'EMAIL1' },
            { label: 'ADRESS1', fieldName: 'ADRESS1' },
            { label: 'ZIPCODE', fieldName: 'ZIPCODE' },
            { label: 'CITY', fieldName: 'CITY' },
            { label: 'INFO1', fieldName: 'INFO1' },
            { label: 'INFO2', fieldName: 'INFO2' },
        ];
        return columns;
    }

    get rows(){
        if(this._rows){
            return this._rows.map((row, index) => {
                row.key = index;
                return row;
            })
        }
        return [];
    }

    renderedCallback() {
        if(!this.parserInitialized){
            loadScript(this, PARSER)
                .then(() => {
                    this.parserInitialized = true;
                })
                .catch(error => console.error(error));
        }
    }

    handleCancel(){
        const navigateEvent = new FlowNavigationCancelEvent();
        this.dispatchEvent(navigateEvent);
    }

    handleNext(){
        // check if NEXT is allowed on this screen
        // if (this.availableActions.find((action) => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        // }
    }

    handleInputChange(event){
        if(event.target.files.length > 0){
            const file = event.target.files[0];
            this.loading = true;
            Papa.parse(file, {
                quoteChar: '"',
                header: 'true',
                complete: (results) => {
                    this._rows = results.data;
                    this.loading = false;
                },
                error: (error) => {
                    console.error(error);
                    this.loading = false;
                }
            })
        }
    }

    // createAccounts(){
    //     const accountsToCreate = this.rows.map(row => {
    //         const fields = {};
    //         fields[NAME_FIELD.fieldApiName] = row.AccountName;
    //         fields[DESCRIPTION_FIELD.fieldApiName] = row.Description;
    //         const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };
    //         return createRecord(recordInput);
    //     });

    //     if(accountsToCreate.length){
    //         this.loading = true;
    //         Promise.allSettled(accountsToCreate)
    //             .then(results => this._results = results)
    //             .catch(error => console.error(error))
    //             .finally(() => this.loading = false);
    //     }
    // }

    cancel(){
        this._rows = undefined;
    }
}