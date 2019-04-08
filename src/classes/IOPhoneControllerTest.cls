@isTest
public class IOPhoneControllerTest {
    static testMethod void TestingPhonecontroller() 
    {
        IOVDPhone ioPhone = new IOVDPhone();
        ioPhone.isSuccess =  true ; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IOPhoneControllerResponceTest()); 
        
        IOPhoneController phoneCon = new IOPhoneController();
        phoneCon.name = 'testing';
        phoneCon.phonebookID  = '111';
        phoneCon.phoneNumber = '111';
        phoneCon.insertPhoneNumber();
        Test.stopTest();
        System.assert(phoneCon != null);
        
    }
    
}