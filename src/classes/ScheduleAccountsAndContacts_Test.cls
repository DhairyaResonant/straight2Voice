/*
* Created By: Dhairya Shah
* Date: 24/08/2018
* Desc: Test class Scheduling Accounts and Contacts
*/

@isTest
public class ScheduleAccountsAndContacts_Test {
    
    @testSetup static void methodName(){
        
        //CUSTOM SETTING INSERTION
        List<Xero_Settings_Super_Admin__c> listSetting = new List<Xero_Settings_Super_Admin__c>();
        Xero_Settings_Super_Admin__c setting = new Xero_Settings_Super_Admin__c();
        setting.username__c = 'test';
        setting.password__c = 'test';
        setting.url__c = 'https://testusername.com';
        listSetting.add(setting);
        insert listSetting;
        
    }
    static testmethod void schedulingmethod1(){
        SingleRequestMock fakeResponse = new SingleRequestMock();
        Test.setMock(HttpCalloutMock.class, fakeResponse); 
        ScheduleAccountsAndContacts.firstname = 'test';
        ScheduleAccountsAndContacts.lastname = 'test';
        ScheduleAccountsAndContacts.username = 'test';
        ScheduleAccountsAndContacts.password = 'test';
        ScheduleAccountsAndContacts.url = 'test';
        
        Test.StartTest();
        ScheduleAccountsAndContacts sh1 = new ScheduleAccountsAndContacts();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
		Test.stopTest();
        
    }
    
}