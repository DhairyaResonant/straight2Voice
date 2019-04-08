/*
* CREATED BY: AAKRITI GOYAL
* DATE: 16/01/2019
* DESC: TEST CLASS FOR S2V2WayConversationCtrlContact APEX CLASS
*/ 
@isTest
public class Test_S2V2WayConversationCtrlContact {
    @testsetup public static void testData(){
    
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
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User usr=new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = uniqueName + '@test' + orgId + '.org', 
                          Username = uniqueName + '@test' + orgId + '.org', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = uniqueName.substring(18, 23), 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = pf.Id,
                          MobilePhone = '123456789'
                         ); 
        insert usr;
        
        Contact con = new Contact(LastName = 'Con Last Name',
                                  MobilePhone = '123456789');
        
        insert con;
        
        
        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.Full_Name__c='s2v';
        s2vsettings.password__c='mnbvh';
        s2vsettings.username__c='xyz@gmail.com';
        s2vsettings.url__c='www.gmail.com';
        insert s2vsettings;
        
    }
    
    
    static testmethod void testGetRecords(){
        
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
        
        Contact con = [Select Id, Name, MobilePhone From Contact limit 1];
        User usr = [Select Id, MobilePhone From User where MobilePhone != null limit 1];
        
        test.starttest();
        
        Test.setMock(HttpCalloutMock.class, new Test_IOVoicemailDropBackend()); 
        S2V2WayConversationCtrlContact ctrlCon = new S2V2WayConversationCtrlContact(new ApexPages.StandardController(con));
        System.debug('usr ---> ' + usr);
        ctrlCon.getSMSList();
        test.stopTest();
    }
    
    
    static testMethod void testpageAction(){
    
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
        
        Contact con = [Select Id, Name, MobilePhone From Contact limit 1];
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new Test_IOVoicemailDropBackend()); 
        S2V2WayConversationCtrlContact ctrlCon = new S2V2WayConversationCtrlContact(new ApexPages.StandardController(con));
        ctrlCon.message = 'Test message';
        ctrlCon.pageAction();
        test.stopTest();
        
    }
    
    static testMethod void testpageActionExtras(){
        
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
        
        Contact con = [Select Id, Name, MobilePhone From Contact limit 1];
        
        User usr = [Select Id, MobilePhone From User where MobilePhone != null limit 1];
        
        test.starttest();
        S2V2WayConversationCtrlContact ctrlCon = new S2V2WayConversationCtrlContact(new ApexPages.StandardController(con));
        ctrlCon.message = 'Test message';
        System.debug('usr ---> ' + usr);
        ctrlCon.lastLoginDateTime = datetime.newInstance(2019, 01, 16, 12, 30, 0);
        ctrlCon.lastLoginDate = Date.newInstance(2019, 01, 16);
        ctrlCon.allMessages = 'Testing';
        ctrlCon.messageStatus = false;
        ctrlCon.messageFromSMSobject = 'Testing';
        ctrlCon.doredirect();
        ctrlCon.incrementCounter();
        ctrlCon.getCount();
        test.stopTest();
        
    }
}