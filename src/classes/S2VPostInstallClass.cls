/*
 * App Name: Straight 2 voice
 * Desc: Inserting URL and username for demo purpose only on s2v setting (custom setting)
*/
global with sharing class S2VPostInstallClass implements InstallHandler
{
    global void onInstall(InstallContext context)
    { 
        try
        {
            if(context.previousVersion() == null)
            {            
                List<CountryCode__c> listCC = new List<CountryCode__c>();
                
                //INSERTING AU
                CountryCode__c objCC = new CountryCode__c();
                objCC.Country__c = 'AU';
                objCC.Name = 'AU';
                objCC.Active__c = TRUE;
                listCC.add(objCC);
                
                //INSERTING CA-US
                CountryCode__c objCC1 = new CountryCode__c();
                objCC1.Country__c = 'CA-US';
                objCC1.Name = 'CA-US';
                objCC1.Active__c = FALSE;
                listCC.add(objCC1);
                
                //INSERTING NZ
                CountryCode__c objCC2 = new CountryCode__c();
                objCC2.Country__c = 'NZ';
                objCC2.Name = 'NZ';
                objCC2.Active__c = FALSE;
                listCC.add(objCC2);
                
                insert listCC;
                
                
                //CUSTOM SETTINGS
                List<S2V_Settings1__c> listS2V = new List<S2V_Settings1__c>();
                S2V_Settings1__c objSettings = new S2V_Settings1__c();
                objSettings.username__c = 'thanhtruong217@gmail.com';
                objSettings.password__c = 'admin12!';
                objSettings.url__c = 'https://dev2.straight2voicemail.com.au';
                listS2V.add(objSettings);
                insert listS2V;
                
                List<SMS_Template__c> listSMSTemp = new List<SMS_Template__c>();
                SMS_Template__c objSMSTemp = new SMS_Template__c();
                objSMSTemp.Template_Body__c = 'Hello, This is testing sms from Straight 2 voice Application';
                objSMSTemp.Template_Name__c = 'Test SMS Template';
                objSMSTemp.Object_Name__c = 'Contact';
                
                listSMSTemp.add(objSMSTemp);
                insert listSMSTemp;
                
                List<s2vSMSDemo__S2V_Trigger_Handler__c> listTrgHandler = new List<s2vSMSDemo__S2V_Trigger_Handler__c>();
                s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = new s2vSMSDemo__S2V_Trigger_Handler__c();
                trgHandler.Name = 'TriggerHandler';
                trgHandler.s2vSMSDemo__S2VRestrictingCampaignMember__c = true;
                trgHandler.s2vSMSDemo__S2VTimeZoneContact__c = true;
                trgHandler.s2vSMSDemo__S2VTimeZoneLead__c = true;
                trgHandler.s2vSMSDemo__S2VTimeZoneOpp__c = true;
                trgHandler.s2vSMSDemo__S2VTimeZoneTask__c = true;
                trgHandler.s2vSMSDemo__SameRecordNumber__c = true;
                trgHandler.s2vSMSDemo__SendVoiceMail__c = true;
                listTrgHandler.add(trgHandler);
                insert listTrgHandler;
            }
        }
        
        catch(Exception ex)
        {  
           
        }
    }
}