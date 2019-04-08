@isTest
public class IOPhonebooksResponceTest implements HttpCalloutMock 
{
     public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"meta":{"limit":20,"next":"/api/v1/phonebook/?limit=20&offset=20","offset":0,"previous":null,"total_count":273},"objects":[{"created_at":"2017-04-03 17:13:48.448610+00:00","id":4611,"name":"iopyime","resource_uri":"/api/v1/phonebook/4611/"},{"created_at":"2016-11-16 14:34:22+00:00","id":4504,"name":"QQVGBTUJMHO4875LCKVCYJWGMO1MTT","resource_uri":"/api/v1/phonebook/4504/"}]}');
        System.assert(res.getStatusCode() != null);
        return res;  
    }
}