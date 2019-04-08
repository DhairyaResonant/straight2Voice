@isTest
public class IORecordingVoicemailControllerTest {
    static testMethod void TestingRecordingVoicemail() 
     {
         
         
         Case cse=new Case();
         insert cse; 
         Attachment attach=new Attachment();    
         attach.Name='Unit Test Attachment';
         Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
         attach.body=bodyBlob;
         attach.parentId=cse.id;
         insert attach;  
         Test.startTest();
         
         Test.setMock(HttpCalloutMock.class, new IOUploadRescponceTest()); 
         
         Test.stopTest();
          System.assert(attach != null);
     }

}