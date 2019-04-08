/*
 * Created By: Dhairya Shah
 * Date: 26th sept 2018
 * Desc: Test class for S2VTriggerDeploymentController apex class
 */
@isTest
public class S2VTriggerDeploymentController_Test{ 
    
    static testmethod void S2VTriggerDeploymentController(){  
    
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
        
        Test.setMock(HttpCalloutMock.class, new IORecordingResponceTest()); 
        
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
        
        test.startTest();
        
        System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
        System.assertEquals(lstid.size(),1);
        
        
        System.currentPageReference().getParameters().put('objName', 'Contact');
        System.currentPageReference().getParameters().put('SId', sendvoicemail.Id);
        S2VTriggerDeploymentController deploy = new S2VTriggerDeploymentController();
        deploy.getPackageXml();
        deploy.getPathTriggerTestCodeMetadata();
        deploy.getTriggerTestCodeMetadata();
        deploy.getPathTriggerTestCode();
        deploy.getTriggerTestCode();
        deploy.getPathTriggerCodeMetadata();
        deploy.getTriggerCodeMetadata();
        deploy.getPathTriggerCode();
        deploy.getTriggerCode();
        deploy.sendToListPage();
        deploy.deployZip();
        
        //S2VTriggerDeploymentController.createService();
        test.stopTest();
    }
    
}