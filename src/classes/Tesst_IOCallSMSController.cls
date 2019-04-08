/*
* CREATED BY: AAKRITI GOYAL
* DATE: 16/01/2019
* DESC: TEST CLASS FOR IOCallSMSController APEX CLASS
*/ 
@isTest
public class Tesst_IOCallSMSController {
    @testSetup public static void testData(){
        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.Full_Name__c='s2v';
        s2vsettings.s2vSMSDemo__password__c='mnbvh';
        s2vsettings.s2vSMSDemo__username__c='xyz@gmail.com';
        s2vsettings.url__c='www.gmail.com';
        insert s2vsettings;
    } 
     
    static testMethod void testSMSController(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_IOVoicemailDropBackend()); 
        
        PageReference myVfPage = Page.IOSMSHistory;
        Test.setCurrentPage(myVfPage);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('campaign_name','Test Campaign');
        
        IOCallSMSController cntrl = new IOCallSMSController();
        cntrl.displayRecordList();
        
        Test.stopTest();
    }
    
    
    static testMethod void testpageAction(){
        test.starttest();
        IOSMSHistory history = new IOSMSHistory();
        
        Test.setMock(HttpCalloutMock.class, new Test_IOVoicemailDropBackend()); 
        IOCallSMSController ctrl = new IOCallSMSController();
        ctrl.pageAction();
        ctrl.doredirect();
        ctrl.next();
        ctrl.prev();
        
        ctrl.prev = '10';
        history.isSuccess=true; 
        history = IOVoicemailDropBackend.getSMSHistory('10');
        System.debug('history ---> ' + history);
        
        test.stopTest();
        System.assert(history.objects[0].from_number != null);
         System.debug(history.objects[0].to_number);
         System.debug(history.objects[0].message);
         System.debug(history.objects[0].submit_date);
         System.debug(history.objects[0].recipient);
         System.debug(history.objects[0].submit_status);
         System.debug(history.objects[0].name);
       
    }
    
    static testMethod void testNegative(){
        s2vSMSDemo__S2V_Settings1__c settings = [Select ID, s2vSMSDemo__password__c, s2vSMSDemo__username__c from s2vSMSDemo__S2V_Settings1__c LIMIT 1];
        settings.s2vSMSDemo__username__c = null;
        update settings;
        test.starttest();
        IOCallSMSController ctrl = new IOCallSMSController();
        ctrl.pageAction();
        test.stopTest();
    }
}