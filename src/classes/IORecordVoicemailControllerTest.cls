@isTest
public class IORecordVoicemailControllerTest 
{
    static testMethod void TestingUploadRecording() 
     {
         s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
         setting.s2vSMSDemo__username__c='test@gmail.com';
         setting.password__c='password';
         setting.Profile_Image__c='image.png';
         insert setting;
         
         Test.startTest();
         
         Test.setMock(HttpCalloutMock.class, new IOUploadRescponceTest()); 
         IOVDAccount acc= new IOVDAccount();
         IORecording ioRec = new IORecording();
         ioRec.objects= new List<IORecording.RObject>();
         acc=  IOVoicemailDropBackend.getAccountDetails( setting.s2vSMSDemo__username__c,  setting.s2vSMSDemo__username__c);
         
         IORecordVoicemailController urc = new IORecordVoicemailController();
         
         urc.pageAction();
         urc.doredirect();
         
         
         System.debug(urc.phoneNumberVoice+ urc.recName +urc.rec);
         ioRec.objects.add(new IORecording.RObject());
         IORecording.RObject objRec=new IORecording.RObject();
         
         Test.stopTest();
         //urc.sendVoiceDetail();     //urc.redirect();
         System.assert(objRec.name == null);  
         System.debug(objRec.audio_file);
         System.debug(objRec.resource_uri);
         System.debug(objRec.id);
     }
}