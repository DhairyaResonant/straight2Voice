
//adding for gitbut
@IsTest
private class CampaignMemberObjTriggerTest
{
    @IsTest
    private static void testTrigger()
    {
s2vSMSDemo__S2V_Trigger_Handler__c objCS = new s2vSMSDemo__S2V_Trigger_Handler__c();
objCS.Name = 'TriggerHandler';
objCS.s2vSMSDemo__S2VRestrictingCampaignMember__c = true;
objCS.s2vSMSDemo__S2VTimeZoneContact__c = true;
objCS.s2vSMSDemo__S2VTimeZoneLead__c = true;
objCS.s2vSMSDemo__S2VTimeZoneOpp__c = true;
objCS.s2vSMSDemo__S2VTimeZoneTask__c = true;
objCS.s2vSMSDemo__SameRecordNumber__c = true;
objCS.s2vSMSDemo__SendVoiceMail__c = true;
insert objCS;
  CountryCode__c cs = new CountryCode__c();
  cs.Name = 'AU';
  cs.Country__c = 'AU';
  cs.Active__c = TRUE;
  insert cs;

  CountryCode__c cs1 = new CountryCode__c();
  cs1.Name = 'CA-US';
  cs1.Country__c = 'CA-US';
  cs1.Active__c = FALSE;
  insert cs1;

  CountryCode__c cs2 = new CountryCode__c();
  cs2.Name = 'NZ';
  cs2.Country__c = 'NZ';
  cs2.Active__c = FALSE;
  insert cs2;

List<Contact> listCon = new List<Contact>();
  Contact objCon = new Contact();
  objCon.lastName = 'test';
  objCon.Email = 'd@d.com';
  objCon.Country__c = 'Australia/NSW';
  objCon.MailingCountry = 'AU';
  objCon.S2V_Batch_Record__c = true;
  objCon.s2vSMSDemo__S2V_Stop_Notifications__c = false;
  Contact objCon1 = new Contact();
  objCon1.lastName = 'test';
  objCon1.Email = 'd@d.com';
  objCon1.Country__c = 'Australia/NSW';
  objCon1.MailingCountry = 'AU';
  objCon1.S2V_Batch_Record__c = false;
  objCon1.s2vSMSDemo__S2V_Stop_Notifications__c = false;
  listCon.add(objCon);
  listCon.add(objCon1);
  insert listCon;


         Campaign Campaignobj2 = new Campaign();
         Campaignobj2.Name = 'test';
         insert Campaignobj2;

RecursiveTriggerHandler.isFirstTime  =true; 
 CampaignMember CampaignMemberobj = new CampaignMember();
         CampaignMemberobj.CampaignId = Campaignobj2.Id;
         CampaignMemberobj.ContactId = objCon.Id;
         CampaignMemberobj.S2V_Customer_Time_Zone__c = 'Australia/NSW';
         insert CampaignMemberobj;
    }
}