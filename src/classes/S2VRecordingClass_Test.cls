@isTest
public class S2VRecordingClass_Test
{ 

    static testmethod void S2VRecordingClass()
    {  
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
                
        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.Full_Name__c='s2v';
        s2vsettings.password__c='mnbvh';
        s2vsettings.username__c='xyz@gmail.com';
        s2vsettings.url__c='www.gmail.com';
        insert s2vsettings;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        S2V_Send_Voicemail__c sendvoicemail=new S2V_Send_Voicemail__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        sendvoicemail.Recording_Name__c='aakriti';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Reference_Field__c='kjj';
        sendvoicemail.Start_Date__c=system.today();
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(acc.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        
         Test.startTest();
        
         Test.setMock(HttpCalloutMock.class, new IORecordingResponceTest()); 
         System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
         System.assertEquals(lstid.size(),1);
         System.currentPageReference().getParameters().put('name', 'Dhrudeep');
         S2VRecordingClass rec = new S2VRecordingClass();
         rec.deleteRecording();
         rec.pageAction();
         rec.doredirect();
         rec.displayRecording();
         rec.next();
         rec.prev();
         rec.getRecording('http');
         rec.RedirectoHome();
         S2VRecordingClass.getRecBuffer('http');
         
         Test.stopTest();
         
    }
    
}