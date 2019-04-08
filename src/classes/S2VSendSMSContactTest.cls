@isTest
public class S2VSendSMSContactTest {

    static testmethod void method1(){
    
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
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];

        Contact objCon = new Contact();
        objCon.LastName = 'Test';
        objCon.firstName = 'Test';
        objCon.MobilePhone = '8978787';
        objCon.ownerId = u.id;
        insert objCon;


        
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;

        Test.startTest();

            ApexPages.StandardController sc = new ApexPages.standardController(objCon);
            S2VSendSMSContact  controller = new S2VSendSMSContact(sc);

            controller.smsTemplateId = objSMSTemp.id;
            controller.smstemplateName = objSMSTemp.Template_Name__c;
            controller.smstemplateBody = objSMSTemp.Template_Body__c;

            List<SelectOption> options = new List<SelectOption>();
            options = controller.getSmsTemplates();

            PageReference pageRef = Page.S2VSendSMSContactVF;
            pageRef.getParameters().put('Id',objCon.id);
            PageReference objPageRef = controller.AllSmsTemplate();
            PageReference objPageRef1 = controller.SendSMS();

            Test.setMock(HttpCalloutMock.class, new Test_IOVoicemailDropBackend()); 

            //List<SelectOption> options = S2VSendSMSContact.getSmsTemplates();
        Test.stopTest();

    }

}