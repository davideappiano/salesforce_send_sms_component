/* 
    This class defines the method that can be used to invoke Apex from Process Builder,
    as well as the variables to be completed for that method
*/

global class MCTS_SMS {
  
  // This is a helper class to capture the relevant information needed to successfully invoke from Process Builder
  global class SMSRequest {

    // Name of the Custom Setting Record storing the Client Id, Client Secret, and endpoint detail for the MC Rest API
    @InvocableVariable(label='API Custom Setting Name' description='Custom Setting Record (Name) for MCTS API Setting' required=true)
    public String X01_restApiSetting;

    // External Key for the SMS API Trigger Definition in Marketing Cloud
    @InvocableVariable(label='SMS API Key' required=true)
    public String X02_apiKey;
    
    // MC Keyword
    @InvocableVariable(label='SMS Keyword' description='MobileConnect Keyword' required=true)
    public String X03_mcKeyword;

    // Value to use for the Marketing Cloud MobileNumber
    // Usually a mobilephone field, can be on an ancestors record
    @InvocableVariable(label='To Mobile Number' required=true)
    public String X04_subscriberMobile;   
    
    // Format number prior to submitting to Marketing Cloud
    @InvocableVariable(label='Format Number' required=true)
    public Boolean X04a_formatNumber;

    // Country Code (US, AU, UK, etc) used for formatting phone numbers prior to submitting to Marketing Cloud
    // Leave blank or use 'NAN' to ignore country code (only do this if the number starts with + and includes international codes)
    @InvocableVariable(label='Subscriber Country' required=false)
    public String X04b_countryCode;
    
    
    // Value to use for the Marketing Cloud Subscriber Key
    // Usually the record Id for the customer
    @InvocableVariable(label='Subscriber Key' required=true)
    public String X05_subscriberKey;
    
    // MC Subscribe Flag - default = TRUE
    @InvocableVariable(label='Subscribe Flag' description='Flag to indicate a subscription should be created if none exist' required=false)
    public Boolean X06_subscribeFlag = true;

    // MC Resubscribe Flag - default = TRUE
    @InvocableVariable(label='ReSubscribe Flag' description='Flag to indicate a subscription should be reset if currently unsubscribed' required=false)
    public Boolean X07_reSubscribeFlag = true;
    
    // MC Override Text
    @InvocableVariable(label='Override Message Text' description='Set if you want to override the text' required=false)
    public String X08_overrideText;

    // MC Blackout UTC Offset
    @InvocableVariable(label='Blackout UTC Offset' description='Set UTC Offset' required=false)
    public String X09_utcOffset;

    // MC Blackout Windows Start
    @InvocableVariable(label='Blackout Window Start' description='Blackout Window Start' required=false)
    public String X10_blackoutStart;

    // MC Blackout Windows End
    @InvocableVariable(label='Blackout Window End' description='Blackout Window End' required=false)
    public String X11_blackoutEnd;

    // MC Send Time
    @InvocableVariable(label='Send Time' description='Send Time' required=false)
    public String X12_sendTime;

    // MC Content URL
    @InvocableVariable(label='Content URL' description='Content URL' required=false)
    public String X13_contentUrl;
       
  }  


  @InvocableMethod(label='Send SMS' description='Used to fire an API Trigger SMS through Marketing Cloud.')
  public static void SendSMS(List<SMSRequest> mctsRequests) {
    List<SMSRequest> mctsRequestsChunk = new List<SMSRequest>();    
    for(Integer i=0; i<mctsrequests.size(); i++) {    
      mctsRequestsChunk.add(mctsrequests[i]);
      if(mctsRequestsChunk.size()==90) {
        SendChunk(mctsRequestsChunk);  
        mctsRequestsChunk.clear();
      }
    }    
    if(mctsRequestsChunk.size() > 0) SendChunk(mctsRequestsChunk); 
  }
  

  private static void SendChunk(List<SMSRequest> mctsRequestsChunk) {
    MCTS_SMSSender.Send(mctsRequestsChunk);
  }
}