/*
 * DESC: S2V TEST CLASS FOR IOCALLERVERIFICATION
 */
@isTest
public class IOcallerVerificationTest {
    
     static testMethod void TestingGetVerfication(){
         s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
         setting.s2vSMSDemo__username__c='test@gmail.com';
         setting.s2vSMSDemo__password__c='password';
         setting.s2vSMSDemo__Profile_Image__c='image.png';
         insert setting;
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new IOcallerControllerResponceTest());  
         IOCallerVerification callVerify = new IOCallerVerification();
         callVerify.pageAction();
         callVerify.doredirect();
         
         callVerify.CallerIDCode='11';
         callVerify.requestCallerIDCode();
         callVerify.inputVerificationcode();
         Test.stopTest();
         system.assertEquals(callVerify.objects,null);
          
     } 
}