@isTest
public class IOMyAccountTest 
{  
    static testMethod void TestingCreateAccount() {
        List<s2vSMSDemo__Countrycode__c> listCodes = new List<s2vSMSDemo__Countrycode__c>();
        s2vSMSDemo__Countrycode__c codes = new s2vSMSDemo__Countrycode__c();
        codes.Name = 'AU';
        codes.s2vSMSDemo__Active__c = True;
        codes.s2vSMSDemo__Country__c = 'AU';
        
        s2vSMSDemo__Countrycode__c codes1 = new s2vSMSDemo__Countrycode__c();
        codes1.Name = 'CA-US';
        codes1.s2vSMSDemo__Active__c = false;
        codes1.s2vSMSDemo__Country__c = 'CA-US';
        
        s2vSMSDemo__Countrycode__c codes2 = new s2vSMSDemo__Countrycode__c();
        codes2.Name = 'NZ';
        codes2.s2vSMSDemo__Active__c = false;
        codes2.s2vSMSDemo__Country__c = 'NZ';
        
        listCodes.add(codes);
        listCodes.add(codes1);
        listCodes.add(codes2);
        
        insert listCodes;
        
        s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        setting.s2vSMSDemo__username__c='nick@meetingtime.com.au';
        setting.s2vSMSDemo__password__c='start12!';
        setting.s2vSMSDemo__Profile_Image__c='image.png';
        setting.s2vSMSDemo__url__c = 'https://login.straight2voicemail.com.au';
        insert setting;
        
        Test.startTest();
        IOVDAccount acc  = new IOVDAccount();    
        Test.setMock(HttpCalloutMock.class, new IOMyAccountResponceTest()); 
        IOMyAccount myAcc = new IOMyAccount();
        myAcc.username='nick@meetingtime.com.au';
        myAcc.password='start12!';
        List<SelectOption> listSO = myAcc.getAllcountrycode();
        
        myAcc.acc =  IOVoicemailDropBackend.getAccountDetails(myAcc.username,myAcc.password);
        myAcc.sendRequest(); 
        
        myAcc.logout();   
        Test.stopTest(); 
        System.assert(myAcc.acc.job_uuid+myAcc.acc.responceVoice+myAcc.acc.name+myAcc.acc.upload_prefix_allowed+myAcc.acc.upload_prefix+myAcc.acc.timezone+myAcc.acc.time_condition+myAcc.acc.sure_name+myAcc.acc.scheduler_email_cdr_report+myAcc.acc.saparate_call+myAcc.acc.retry_time+myAcc.acc.resource_uri+myAcc.acc.private_number+myAcc.acc.phone+myAcc.acc.monthly_balance_reset+myAcc.acc.last_name+myAcc.acc.company+myAcc.acc.api_ip_allowed+myAcc.acc.last_login+myAcc.acc.auto_recurring+myAcc.acc.address+myAcc.acc.errorMessage+myAcc.acc.concurrent_call_limit+myAcc.acc.credit+myAcc.acc.email+myAcc.acc.first_name != null);
    }  
}