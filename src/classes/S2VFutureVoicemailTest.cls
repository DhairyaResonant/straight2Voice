@isTest
public class S2VFutureVoicemailTest {
    
    static testMethod void myTest() {
        
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
                
        //CUSTOM SETTING
        List<s2vSMSDemo__CountryCode__c> listCS = new List<s2vSMSDemo__CountryCode__c>();
        s2vSMSDemo__CountryCode__c objCS = new s2vSMSDemo__CountryCode__c();
        objCS.Name = 'AU';
        objCS.s2vSMSDemo__Country__c = 'AU';
        objCS.s2vSMSDemo__Active__c = TRUE;
        listCS.add(objCS);
        insert listCS;
        
        //TIMEZONE
        S2V_Time_Zones__c objTMZ = new S2V_Time_Zones__c();
        objTMZ.Name = 'Australia/NSW';
        objTMZ.Start_Time__c = Time.newInstance(01, 00, 2, 20);
        objTMZ.Stop_Time__c  = Time.newInstance(23, 59, 2, 20);
        insert objTMZ;
  
        //CONTACT INSERTION
        List<Contact> listCon = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCOn.MobilePhone = '121211';
        objCon.MailingCountry = 'AU';
        listCon.add(objCon);
        insert listCon;
        
        //FUTURE VMS
        Future_Voicemails__c objFM = new Future_Voicemails__c();
        objFM.ContactId__c = objCon.id;
        objFM.Sobject_Name__c = 'Contact';
        objFM.Status__c = 'Queue';
        objFM.Timezone__c = objTMZ.Name;
        objFM.Record_Id__c = objCon.id;
        insert objFM;
        
        String soql = 'SELECT Id, Record_Id__c, Sobject_Name__c,Status__c,Timezone__c ';
        soql += 'FROM Future_Voicemails__c ';
        soql += 'WHERE (Status__c = '+ '\''+ CommonConstant.status + '\' AND Record_Id__c != NULL) ';
       
        Test.StartTest();
        S2VFutureVoicemailBatch uca = new S2VFutureVoicemailBatch(soql);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
    }
}