/*
 * App Name: Straight 2 voice
 * Desc: Inserting URL and username for demo purpose only on s2v setting (custom setting)
*/

@isTest
global with sharing class S2VPostInstallClassTest
{
    static testmethod void TestInstallScript()
    {
        S2VPostInstallClass postInstall = new S2VPostInstallClass();
        Test.testInstall(postInstall, null);
                
        
        List<CountryCode__c> listCC = [SELECT id,Name FROM CountryCode__c];
        system.assertEquals(3, listCC.size());
        
        List<S2V_Settings1__c> listSettings = [SELECT id,username__c,password__c,url__c FROM S2V_Settings1__c];
        system.assertEquals(1, listSettings.size()); 
       
        List<SMS_Template__c> listST = [SELECT id FROM SMS_Template__c];
        system.assertEquals(1, listST.size());
        
        List<s2vSMSDemo__S2V_Trigger_Handler__c> listTrgHandler = [SELECT id,Name FROM s2vSMSDemo__S2V_Trigger_Handler__c];
        system.assertEquals(1, listTrgHandler.size());
    }
}