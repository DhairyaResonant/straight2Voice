/*
 * Edited By: Dhairya
 * Desc: Test class for IOCampaignEditController apex class
 */
@isTest
public class IOCampaignS2VTest{
     static testMethod void TestingCreateAccount(){
         RecordType objRT = [SELECT id,Name FROM RecordType WHERE sObjectType='Campaign' AND Name='AdHoc'];

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
                
         List<s2vSMSDemo__CountryCode__c> listC = new List<s2vSMSDemo__CountryCode__c>();
         s2vSMSDemo__CountryCode__c objCS = new s2vSMSDemo__CountryCode__c();
         objCS.Name = 'AU';
         objCS.s2vSMSDemo__Active__c = TRUE;
         objCS.s2vSMSDemo__Country__c = 'AU';
         listC.add(objCS);
         insert listC;
         
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
         //camp.Schedule_Frequency__c='Daily';
         insert camp;
         
         Contact con = New Contact();
         con.accounts__c = acc1.Id;
         con.LastName ='test';
         con.MobilePhone = '65783833';
         con.Email = 'd@d.com';
         con.MailingCountry = 'AU';
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
         
         Test.startTest();
         ApexPages.StandardController sc = new ApexPages.standardController(camp);
         IOCampaignEditController IOCampsEdit = new IOCampaignEditController(sc);
         IOCampsEdit.showOption = true;
         PageReference pageRef = Page.IOCampaignsS2V;
         Test.setCurrentPage(pageRef);
         IOCampsEdit.saveCampaign();
         System.assert(setting != null);
         
         IOVDAccount acc  = new IOVDAccount();           
         Test.setMock(HttpCalloutMock.class, new IOCampaignS2VResponceTest()); //responce from service
         
     } 
}