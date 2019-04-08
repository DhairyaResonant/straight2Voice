@isTest
public class IOCampaignRecordingGetTest {
    
    static testMethod void TestingGetRecodedVoice(){
       
        RecordType objRT = [select id,DeveloperName from RecordType where SobjectType ='Campaign' and DeveloperName = 'AdHoc'];
        
        s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = new s2vSMSDemo__S2V_Trigger_Handler__c();
        trgHandler.Name = 'TriggerHandler';
        trgHandler.s2vSMSDemo__S2VRestrictingCampaignMember__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneContact__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneLead__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneOpp__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneTask__c = true;
        trgHandler.s2vSMSDemo__SameRecordNumber__c = true;
        trgHandler.s2vSMSDemo__SendVoiceMail__c = true;
        insert trgHandler;
        
        s2vSMSDemo__CountryCode__c objCS = new s2vSMSDemo__CountryCode__c();
        objCS.Name = 'AU';
        objCS.s2vSMSDemo__Country__c = 'AU';
        objCS.s2vSMSDemo__Active__c = true;
        insert objCS;
        
        Account acc1 = new Account();
        acc1.Name = 'test';
        insert acc1;
        
        Campaign camp = new Campaign();
        camp.RecordTypeId = objRT.id;
        camp.Name='testCampaign';
        camp.Type='Straight2Voicemail';
        camp.Status='Pending';
        camp.StartDate= date.parse(system.today().format());
        camp.EndDate= date.parse(system.today().format());
        camp.ExpectedRevenue=33;
        camp.BudgetedCost=45;
        camp.ActualCost=85;
        camp.ExpectedResponse=64;
        camp.NumberSent=4;
        camp.Country_code__c='AU'; 
        camp.Option_Schedule__c='Now';
        camp.Schedule_Frequency__c='Daily';
        insert camp;
        
        system.debug('camp::::'+camp);
        Contact con = New Contact();
        con.accounts__c = acc1.Id;
        con.LastName ='test';
        con.MailingCountry ='AU';
        con.MobilePhone = '7878';
        insert con;  
        
        CampaignMember cm= New CampaignMember();
        cm.CampaignId=camp.Id;
        cm.ContactId= con.Id; 
        cm.Status='Sent';
        insert cm; 
        
        s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        setting.username__c='test@gmail.com';
        setting.password__c='password';
        setting.Profile_Image__c='image.png';
        insert setting;
        
        
        IOVDAccount acc  = new IOVDAccount(); 
        IOVDCampaign ioCamp = new IOVDCampaign();
        ioCamp.isSuccess = true;
        System.debug(ioCamp.errorMessage + ioCamp.job_uuid + ioCamp.name +ioCamp.responceVoice );
        
        Test.setMock(HttpCalloutMock.class, new IOCampaignS2VResponceTest()); //responce from service       
        
        IOCampaingsS2V camps = new IOCampaingsS2V(); 
        Test.startTest();
        camps.pageAction();
        camps.doredirect();
        User activeUser = [Select id,MobilePhone FROM User where id=: UserInfo.getUserId()];
        
        camps.selectedCampId = camp.Id;
        camps.selectedVoice = 'Testing voicemail';
        camps.callerID = activeUser.mobilePhone;
        camps.syncNewCampaign();
        camps.creatNewCampaign();   
        //camps.acc =  IOVoicemailDropBackend.getAccountDetails('test@gmail.com','password');
        
        Test.stopTest();
        System.assert(camps.campaigns!= null);
        System.debug(camps.stdCntrlr);
        
    }
}