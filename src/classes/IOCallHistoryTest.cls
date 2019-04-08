/*
 * DESC: S2V CALL HISTORY APEX CLASS
 */
@isTest
public class IOCallHistoryTest {
    static testMethod void TestingGetCallHistory() 
     {
          s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
         setting.s2vSMSDemo__username__c='test@gmail.com';
         setting.s2vSMSDemo__password__c='password';
         setting.s2vSMSDemo__Profile_Image__c='image.png';
         insert setting;
         
         Test.startTest();
         IOCallHistory cHistory = new IOCallHistory(); 
        
         Test.setMock(HttpCalloutMock.class, new IOCallHistoryResponceTest());
           
         IOCallHistoryController callHistory = new IOCallHistoryController();
         callHistory.displayRecordList();
         callHistory.prev='10'; 
         callHistory.prev();
         callHistory.next();
         callHistory.pageAction();
         callHistory.doredirect();
         
         
         cHistory.isSuccess=true; 
        cHistory = IOVoicemailDropBackend.getCallHistory('10');
         Test.stopTest();
         System.assert(cHistory.objects[0].call_start != null);
         System.debug(cHistory.objects[0].country);
         System.debug(cHistory.objects[0].duration);
         System.debug(cHistory.objects[0].ph_number);
         System.debug(cHistory.objects[0].recipient);
         System.debug(cHistory.objects[0].resource_uri);
         System.debug(cHistory.objects[0].result);
         
         
     }

}