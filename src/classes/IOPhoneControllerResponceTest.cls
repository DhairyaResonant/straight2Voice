@isTest
public class IOPhoneControllerResponceTest implements HttpCalloutMock 
{
     public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(201);
        res.setBody('j');
        System.assert(res.getStatusCode() != null);
        return res;  
    }
}