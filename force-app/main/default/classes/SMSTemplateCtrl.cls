public with sharing class SMSTemplateCtrl {
    @AuraEnabled(cacheable = true)
    public static List<OptionWrapper> getSMSTemplateOptions() {
        List<OptionWrapper> options = new List<OptionWrapper>();
        options.add(new OptionWrapper('-- None --', ''));

        for(SMS_Template__c msg :  [SELECT Id, Message__c, Name
                                        FROM SMS_Template__c Order By Name]){
            OptionWrapper option = new OptionWrapper(msg.Name, msg.Id);    
            options.add(option);                               
        }

        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SMS_Template__c> getSMSTemplates(){
        return [SELECT Id, Message__c, Name FROM SMS_Template__c];
    }
}
