/*
 * DESC: TEST CLASS FOR IOCALLERCONTROLLER
 */
@isTest
public class IOCallerControllerTest {
    
    static testMethod void TestingGetCallerID() {
        s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        setting.username__c='test@gmail.com';
        setting.password__c='password';
        setting.Profile_Image__c='image.png';
        insert setting;
        
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new IOcallerControllerResponceTest());  
        IOCallerController callCon = new IOCallerController();
        
        IOVDCallerID callerID = new IOVDCallerID();
        callerID.id='111';
        callCon.verificationCodeNumber='11'; 
        callCon.CallerIDCode='11';
        callCon.callerIDNumber='11';
        callCon.callerCodeOption='AU';
        
        callCon.pageAction();
        callCon.doredirect();
        
        callCon.getCallerIDS2V();
        callCon.inputVerificationcode();
        callCon.requestCallerIDCode();
        
        IOVDCallerID callID= new IOVDCallerID();
        callID.objects = new List<IOVDCallerID.RObject>();
        callID.objects.add(new IOVDCallerID.RObject());
        IOVDCallerID.RObject objCall=new IOVDCallerID.RObject();
        
        System.assert(objCall.callerid == null);  
        System.debug(objCall.id);         
        System.debug(objCall.verified);  
        System.debug(objCall.resource_uri);
        System.debug(callID.callerBoolean); 
        System.debug(callID.error);
        
        callCon.createCallerID();
        
        Test.stopTest();
        
    } 
}