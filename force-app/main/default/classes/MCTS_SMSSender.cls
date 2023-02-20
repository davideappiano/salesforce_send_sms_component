public class MCTS_SMSSender {  

  public static void Send(List<MCTS_SMS.SMSRequest> tsrequests) {
  
    // Retrieve the details about the connection to be used
    MCTS_API_Setting__c connection = [SELECT Id,
                                             Name,
                                             Client_Id__c,
                                             Client_Secret__c,
                                             Authentication_Endpoint__c,
                                             SMS_Endpoint__c
                                        FROM MCTS_API_Setting__c
                                       WHERE Name= :tsrequests[0].X01_restApiSetting
                                       LIMIT 1 ];

    // Login to the MC REST API with the appropriate credentials
    String accessToken = MCTS_Connection.login(connection);
    
    List<String> phoneNumbers = new List<String>();
    List<String> countryCodes = new List<String>();
    
    // Iterate through the requests to extract phone numbers and country codes
    for(MCTS_SMS.SMSRequest tsrequest : tsrequests) {
      phoneNumbers.add(tsrequest.X04_subscriberMobile.removeStart('+'));
      countryCodes.add((tsrequest.X04b_countryCode!=null && tsrequest.X04b_countryCode!='NAN') ? tsrequest.X04b_countryCode : '');
    }

    for(MCTS_SMS.SMSRequest tsrequest : tsrequests) {
      
      // This builds up the API Request to post to Marketing Cloud
      Map<String, Object> requestMap = new Map<String, Object>();            
      requestMap.put('mobileNumbers', phoneNumbers);

      // Add override text and/or content
      requestMap.put('subscribe', true);
      requestMap.put('resubscribe', true);
      requestMap.put('Override', true);
      requestMap.put('messageText',tsrequest.X08_overrideText);
      requestMap.put('keyword',tsrequest.X03_mcKeyword);
      
      // Now create the HttpRequest
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      
      // SMS endpoint includes a wildcard %ID% which needs to be replaced with the API Trigger SMS ID
      String[] smsendpoint = connection.SMS_Endpoint__c.split('%ID%'); 
      String endPoint = smsendpoint[0] + tsrequest.X02_apiKey + smsendpoint[1];      
      req.setEndpoint(endPoint);
      req.setMethod('POST');
      req.setTimeout(60000);

      String body = JSON.serialize(requestMap);
      req.setBody(body);
      req.setHeader('Authorization', 'Bearer ' + accessToken);
      req.setHeader('Content-Type', 'application/json'); 

      HttpResponse res = http.send(req);
      String resBody = res.getBody();
    }

  }
    
}