@isTest
global class IOCallHistoryResponceTest implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"meta":{"limit":20,"next":"/api/v1/cdr/?limit=20&offset=20","offset":0,"previous":null,"total_count":81},"objects":[{"call_start":"2017-03-17 01:00:58.455185+00:00","country":"Australia","duration":0,"ph_number":"618506444200","recipient":"Bertha Boxer ","resource_uri":"/api/v1/cdr/517911/","result":"no vm detected, no charge"},{"call_start":"2017-03-17 01:00:58.458492+00:00","country":"Australia","duration":0,"ph_number":"6102659100","recipient":"Betty Bair ","resource_uri":"/api/v1/cdr/517910/","result":"no vm detected, no charge"}]}');
        System.assert(res.getStatusCode() != null);
        return res; 
    }
}