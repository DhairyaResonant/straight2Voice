@isTest
public class IOcallerControllerResponceTest  implements HttpCalloutMock 
{
     public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "callerid": "010232", "country_code": "AU", "id": 298, "resource_uri": "/api/v1/callerID/298/", "verified": false,"meta":{"limit":20,"next":"/api/v1/callerID/?limit=20&offset=20","offset":0,"previous":null,"total_count":43},"objects":[{"callerid":"5454","id":291,"resource_uri":"/api/v1/callerID/291/","verified":false}]}');
        System.assert(res.getStatusCode() != null);
        return res;  
    }
}