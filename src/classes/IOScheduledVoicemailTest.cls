/*
* DESC: S2V CALL HISTORY APEX CLASS
*/
@isTest
public class IOScheduledVoicemailTest {
    static testMethod void TestingGetCallHistory() 
    {
        s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        setting.s2vSMSDemo__username__c='test@gmail.com';
        setting.s2vSMSDemo__password__c='password';
        setting.s2vSMSDemo__Profile_Image__c='image.png';
        insert setting;
        
        Test.startTest();
        IOScheduleVoicemail cHistory = new IOScheduleVoicemail(); 
        
        Test.setMock(HttpCalloutMock.class, new IOScheduledVoicemailResponseTest());
        
        IOScheduleVoicemailController callHistory = new IOScheduleVoicemailController();
        callHistory.displayRecordList();
        callHistory.prev='10'; 
        callHistory.prev();
        callHistory.next();
        callHistory.pageAction();
        callHistory.doredirect();
        
        
        cHistory.isSuccess=true; 
        cHistory = IOVoicemailDropBackend.getScheduledVoicemail('10');
        Test.stopTest();
        //System.assert(cHistory.objects[0].name!=null);
        
        
    }
    
}