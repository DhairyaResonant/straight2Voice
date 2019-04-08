@isTest
public class IOCampaignS2VResponceTest  implements HttpCalloutMock 
{
     public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
         res.setBody('{"message":"success to send request to S2V","status":"success","meta":{"limit":20,"next":null,"offset":0,"previous":null,"total_count":1},"objects":[{"audio_file":"https://login.straight2voicemail.com.au/media/audio/4RR6C8PPEN_TapBasin_01.mp3","id":987,"name":"faddee8","resource_uri":"/api/v1/recording/987/"}]}');
        System.assert(res.getStatusCode() != null);
        return res;  
    }
}