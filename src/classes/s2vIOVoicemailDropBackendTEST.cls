@isTest
public class s2vIOVoicemailDropBackendTEST {
	@isTest
    static void getSuperAccountDetailsTEST(){
        s2vIOVoicemailDropBackend.statuscode = 200;
        String username = 'thanhtruong217@gmail.com';
        String pass ='admin12!';
        String limitText = 'temp';
        SingleRequestMock fakeResponse = new SingleRequestMock();
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        s2vIOVoicemailDropBackend.getSuperAccountDetails(username,pass);
        s2vIOVoicemailDropBackend.getMoreSuperAccountDetails(username,pass,limitText);
        Test.stopTest();
    }
    
}