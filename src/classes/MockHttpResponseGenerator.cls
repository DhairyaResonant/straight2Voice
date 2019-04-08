@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock
{ 
    global  HTTPResponse respond(HTTPRequest req)
    {

        system.assertEquals(s2vSMSDemo__S2V_Settings1__c.getInstance().url__c+'/api/v1/campaign/', req.getEndpoint());
        
        string jsonrecording = '{"name":"Voicemail_Recording_1",  "phone": 61280063522}';
        string jsasoncampaign = '{"name":"Voicemail Campaign 1", "audio": "Voicemail_Recording_1", "phone_list": [“0410781725”,”0409752398”], “phonecode”: “AU”, “callerID”: “0280063522”}';
               
        Httpresponse response=new Httpresponse();
        response.setStatusCode(200);
        
        if(req.getBody().contains('recording'))
            response.setBody(jsonrecording);
        else if(req.getBody().contains('campaign'))
            response.setBody(jsasoncampaign);      
        
        return response;
    }    
}