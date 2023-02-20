public class MCTS_Connection {

  public static String login(MCTS_API_Setting__c connection) {

    HttpRequest req = new HttpRequest();
   
    // Set endpoint as specified in the Custom Setting
    req.setEndpoint(connection.Authentication_Endpoint__c);

    req.setMethod('POST');
    req.setTimeout(60000);
   
    String body = JSON.serialize(new Auth(connection.Client_Id__c, connection.Client_Secret__c));

    req.setBody(body);
    req.setHeader('Content-Type', 'application/json'); 

    System.debug('*** AUTH REQ' + req);
    System.debug('*** AUTH REQ BODY' + body);

    Http http = new Http();
    HttpResponse res = http.send(req);

    String resBody = res.getbody();
    Map<String, Object> oauthMap = (Map<String, Object>)JSON.deserializeUntyped(resBody);

    System.debug('*** AUTH RESP' + resBody);
    return (String)oauthMap.get('access_token');        

  }
  
  class Auth {
    String client_id;
    String client_secret;
    String grant_type;

    Auth(String clientId, String clientSecret) {
      this.client_id = clientId;
      this.client_secret = clientSecret;
      this.grant_type = 'client_credentials';
    }
  }
}