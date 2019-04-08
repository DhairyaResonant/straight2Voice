/*
* Created By: Dhairya Shah
* Date: 25/09/2018
* Desc: Test class for the trigger called: S2VRestrictingCampaignMember,S2VTimeZoneContact,S2VTimeZoneLead,S2VTimeZoneTask 
* apex class called: S2VRestrictingCampaignMemberClass, S2VTimeZoneClass,s2vtimezonevalidation
*/

@isTest
public class S2VRestrictingCampaignMemberClassTest {
    
    
    
    @isTest
    static void S2VRestrictingMethod1(){
    
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
        
        RecordType objRT = [SELECT id,Name FROM RecordType WHERE sObjectType='Campaign' AND Name='AdHoc'];
        //custom setting
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        
        //COUNTRY CODE AU
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Active__c = TRUE;
        objCS.Country__c ='AU';
        
        //COUNTRY CODE CA-US
        CountryCode__c objCS1 = new CountryCode__c();
        objCS1.Name = 'CA-US';
        objCS1.Country__c = 'CA-US';
        objCS1.Active__c = FALSE;
        
        listCS.add(objCS);
        listCS.add(objCS1);
        insert listCS;
        
        //TIMEZONE INSERTION
        List<S2V_Time_Zones__c> listTZ = new List<S2V_Time_Zones__c>();
        S2V_Time_Zones__c objTZ = new S2V_Time_Zones__c();
        objTZ.Name = 'Australia/NSW';
        objTZ.Start_Time__c = Time.newInstance(11, 00, 2, 20);
        objTZ.Stop_Time__c =  Time.newInstance(15, 00, 2, 20);
        listTZ.add(objTZ);
        insert objTZ;
        
        //Account
        List<Account> listAcc = new List<Account>();
        Account objAc = new Account();
        objAc.Name = 'Testing Acc';
        listAcc.add(objAc);
        insert listAcc;
        
        //INSERTION CONTACT
        List<Contact> listContact = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCon.MobilePhone = '+61 451 439 429';
        objCon.MailingCountry ='AU';
        objCon.S2V_Batch_Record__c = true;
        listContact.add(objCon);
        insert listContact;

        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        objCamp.RecordTypeId = objRT.id;
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM = new CampaignMember();
        objCM.ContactId = objCon.id;
        objCM.CampaignId = objCamp.id;
        listCM.add(objCM);
        insert listCM;
        
        S2VRestrictingCampaignMemberClass.updateTimeZoneContact(objCM);
        
        //OPPORTUNITY INSERTION::
        List<Opportunity> listOpps = new List<Opportunity>();
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Testing opportunity';
        objOpp.AccountId = objAc.id;
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Prospecting';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.Referred_By__c = objCon.id;
        listOpps.add(objOpp);
        insert listOpps;
        
        //TASK INSERTION::
        List<Task> listTask = new List<Task>();
        Task objTask = new Task();
        objTask.WhoId = objCon.id;
        objTask.Subject = 'call';
        objTask.ActivityDate = system.today();
        listTask.add(objTask);
        insert listTask;
        
        //ACTIVE SCHEDULES::
        List<S2V_Send_Voicemail__c> listAS =  new List<S2V_Send_Voicemail__c>();
        S2V_Send_Voicemail__c objAS = new S2V_Send_Voicemail__c();
        objAS.Name = 'CampaignMember';
        objAS.Activity_History__c = true;
        objAS.Is_Active__c = TRUE;
        ObjAS.Query__c = 'CampaignMember objCampaignMember = [Select id FROM CampaignMember];';
        objAS.Object_Name__c = 'CampaignMember';
        objAS.Selected_Lookup__c = 'Contact';
        listAS.add(objAS);
        insert objAS;
            
        String objName = 'CampaignMember';
        String objId = objCM.id;
        String fieldType = 'ContactId';
        String fieldName = 'ContactId';
        String country = 'Australia/NSW';
        
        S2VTimezonevalidation.insertQueueRecords(objName, objId, fieldType, fieldName, Country);
        S2VTimezonevalidation.isItBatchContact('Contact', objCon);        
    }
    
    @isTest
    static void S2VRestrictingMethod2(){
        
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
        
        RecordType objRT = [SELECT id,Name FROM RecordType WHERE sObjectType='Campaign' AND Name='AdHoc'];
        //custom setting
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        
        //COUNTRY CODE AU
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Active__c = FALSE;
        objCS.Country__c ='AU';
        
        //COUNTRY CODE CA-US
        CountryCode__c objCS1 = new CountryCode__c();
        objCS1.Name = 'CA-US';
        objCS1.Country__c = 'CA-US';
        objCS1.Active__c = TRUE;
        
        listCS.add(objCS);
        listCS.add(objCS1);
        insert listCS;
        
        //Account
        List<Account> listAcc = new List<Account>();
        Account objAc = new Account();
        objAc.Name = 'Testing Acc';
        listAcc.add(objAc);
        insert listAcc;
        
        //INSERTION CONTACT
        List<Contact> listContact = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCon.MobilePhone = '+61 451 439 429';
        objCon.MailingCountry ='CA-US';
        listContact.add(objCon);
        insert listContact;

        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        objCamp.RecordTypeId = objRT.id;
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM1 = new CampaignMember();
        objCM1.ContactId = objCon.id;
        objCM1.CampaignId = objCamp.id;
        listCM.add(objCM1);
        insert listCM;
        
        S2VRestrictingCampaignMemberClass.updateTimeZoneContact(objCM1);
        
        //OPPORTUNITY INSERTION::
        List<Opportunity> listOpps = new List<Opportunity>();
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Testing opportunity';
        objOpp.AccountId = objAc.id;
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Prospecting';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.Primary_Contact__c = objCon.id;
        listOpps.add(objOpp);
        insert listOpps;
    }
    
    @isTest
    static void S2VRestrictingMethod3(){
    
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
        
        RecordType objRT = [SELECT id,Name FROM RecordType WHERE sObjectType='Campaign' AND Name='AdHoc'];
        //custom setting
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        
        //COUNTRY CODE AU
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Active__c = FALSE;
        objCS.Country__c ='AU';
        
        //COUNTRY CODE CA-US
        CountryCode__c objCS1 = new CountryCode__c();
        objCS1.Name = 'NZ';
        objCS1.Country__c = 'NZ';
        objCS1.Active__c = TRUE;
        
        listCS.add(objCS);
        listCS.add(objCS1);
        insert listCS;
        
        //Account
        List<Account> listAcc = new List<Account>();
        Account objAc = new Account();
        objAc.Name = 'Testing Acc';
        listAcc.add(objAc);
        insert listAcc;
        
        //INSERTION CONTACT
        List<Contact> listContact = new List<Contact>();
        Contact objCon = new Contact();
        objCon.FirstName = 'Dhairya';
        objCon.LastName = 'Shah';
        objCon.MobilePhone = '+61 451 439 429';
        objCon.MailingCountry ='NZ';
        listContact.add(objCon);
        insert listContact;

        objCon.MobilePhone = '+61 451 439 424';
        objCon.MailingCountry = 'NZ';
        update objCon;
        
        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        objCamp.RecordTypeId = objRT.id;
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM2 = new CampaignMember();
        objCM2.ContactId = objCon.id;
        objCM2.CampaignId = objCamp.id;
        listCM.add(objCM2);
        insert listCM;
        
        S2VRestrictingCampaignMemberClass.updateTimeZoneContact(objCM2);
        
        
        //OPPORTUNITY INSERTION::
        List<Opportunity> listOpps = new List<Opportunity>();
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Testing opportunity';
        objOpp.AccountId = objAc.id;
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Prospecting';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.Witness_Signatory__c = objCon.id;
        listOpps.add(objOpp);
        insert listOpps;

    }

    //TEST METHOD FOR LEAD STARTS HERE    
    @isTest
    static void S2VRestrictingMethod4(){
    
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
        
        RecordType objRT = [SELECT id,Name FROM RecordType WHERE sObjectType='Campaign' AND Name='AdHoc'];
        //custom setting
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        
        //COUNTRY CODE AU
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Active__c = TRUE;
        objCS.Country__c ='AU';
        
        //COUNTRY CODE CA-US
        CountryCode__c objCS1 = new CountryCode__c();
        objCS1.Name = 'NZ';
        objCS1.Country__c = 'NZ';
        objCS1.Active__c = FALSE;
        
        listCS.add(objCS);
        listCS.add(objCS1);
        insert listCS;
        
        
        //INSERTION LEAD
        List<Lead> listLead = new List<Lead>();
        Lead objLead = new Lead();
        objLead.FirstName = 'Dhairya';
        objLead.LastName = 'Shah';
        objLead.Email = 'd@d.com';
        objLead.LeadSource = 'Web';
        objLead.Status = 'New';
        objLead.Company = 'Resonant';
        objLead.MobilePhone = '+61 451 439 429';
        objLead.Country = 'AU';
        listLead.add(objlead);
        insert listLead;
        
        objLead.MobilePhone = '+61 451 439 421';
        objLead.Country = 'AU';
        update objLead;
        
        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        objCamp.RecordTypeId = objRT.id; 
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM = new CampaignMember();
        objCM.LeadId = objLead.id;
        objCM.CampaignId = objCamp.id;
        listCM.add(objCM);
        insert listCM;
        
        S2VRestrictingCampaignMemberClass.updateTimeZoneLead(objCM);
        
        //TASK INSERTION::
        List<Task> listTask = new List<Task>();
        Task objTask = new Task();
        objTask.WhoId = objLead.id;
        objTask.Subject = 'call';
        objTask.ActivityDate = system.today();
        listTask.add(objTask);
        insert listTask;
        
    }
    
    @isTest
    static void S2VRestrictingMethod5(){
    
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
        
        
        RecordType objRT = [SELECT id,Name FROM RecordType WHERE sObjectType='Campaign' AND Name='AdHoc'];
        //custom setting
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        
        //COUNTRY CODE AU
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Active__c = FALSE;
        objCS.Country__c ='AU';
        
        //COUNTRY CODE CA-US
        CountryCode__c objCS1 = new CountryCode__c();
        objCS1.Name = 'CA-US';
        objCS1.Country__c = 'CA-US';
        objCS1.Active__c = TRUE;
        
        listCS.add(objCS);
        listCS.add(objCS1);
        insert listCS;
        
        //INSERTION LEAD
        List<Lead> listLead = new List<Lead>();
        Lead objLead = new Lead();
        objLead.FirstName = 'Dhairya';
        objLead.LastName = 'Shah';
        objLead.Email = 'd@d.com';
        objLead.LeadSource = 'Web';
        objLead.Status = 'New';
        objLead.Company = 'Resonant';
        objLead.MobilePhone = '+61 451 439 429';
        objLead.Country = 'CA-US';
        listLead.add(objlead);
        insert listLead;
        S2VTimeZoneClass.updateTimeZone(objLead);
        
        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        objCamp.RecordTypeId = objRT.id;
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM = new CampaignMember();
        objCM.LeadId = objLead.id;
        objCM.CampaignId = objCamp.id;
        listCM.add(objCM);
        insert listCM;
        
        S2VRestrictingCampaignMemberClass.updateTimeZoneLead(objCM);
        
    }
    
    @isTest
    static void S2VRestrictingMethod6(){
    
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
        
        RecordType objRT = [SELECT id,Name FROM RecordType WHERE sObjectType='Campaign' AND Name='AdHoc'];
        //custom setting
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        
        //COUNTRY CODE AU
        CountryCode__c objCS = new CountryCode__c();
        objCS.Name = 'AU';
        objCS.Active__c = FALSE;
        objCS.Country__c ='AU';
        
        //COUNTRY CODE CA-US
        CountryCode__c objCS1 = new CountryCode__c();
        objCS1.Name = 'NZ';
        objCS1.Country__c = 'NZ';
        objCS1.Active__c = TRUE;
        
        listCS.add(objCS);
        listCS.add(objCS1);
        insert listCS;
        
        //INSERTION LEAD
        List<Lead> listLead = new List<Lead>();
        Lead objLead = new Lead();
        objLead.FirstName = 'Dhairya';
        objLead.LastName = 'Shah';
        objLead.Email = 'd@d.com';
        objLead.LeadSource = 'Web';
        objLead.Status = 'New';
        objLead.Company = 'Resonant';
        objLead.MobilePhone = '+61 451 439 429';
        objLead.Country = 'NZ';
        listLead.add(objlead);
        insert listLead;
        
        //CAMPAIGN INSERTION
        List<Campaign> listCamps = new List<Campaign>();
        Campaign objCamp = new Campaign();
        objCamp.RecordTypeId = objRT.id;
        objCamp.Name = 'Testing Australia';
        objCamp.Option_Schedule__c = 'Now';
        listCamps.add(objCamp);
        insert listCamps;
        
        //campaign member
        List<CampaignMember> listCM = new List<CampaignMember>();
        CampaignMember objCM = new CampaignMember();
        objCM.LeadId = objLead.id;
        objCM.CampaignId = objCamp.id;
        listCM.add(objCM);
        insert listCM;
        
        S2VRestrictingCampaignMemberClass.updateTimeZoneLead(objCM);
        
    }
}