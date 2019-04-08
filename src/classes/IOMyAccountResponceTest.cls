@isTest
global class IOMyAccountResponceTest  implements HttpCalloutMock 
{          
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"address":"","api_ip_allowed":null,"auto_recurring":false,"avatar":null,"company":"","concurrent_call_limit":8,"credit":"20.0000","email":"android.test@gmail.com","first_name":"Murtaza","last_login":"2017-03-21T17:03:00.917981","last_name":"Ashraf","monthly_balance_reset":false,"phone":"3455323592","private_number":false,"resource_uri":"/api/v1/user/440/","retry_time":1,"saparate_call":false,"scheduler_email_cdr_report":"","sure_name":"","time_condition":true,"timezone":"Australia/Sydney","upload_prefix":"0","upload_prefix_allowed":""}');
        System.assert(res.getStatusCode() != null);
        return res; 
    }

}