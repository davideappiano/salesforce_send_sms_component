public with sharing class OptionWrapper {
    
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}

        public OptionWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    
}