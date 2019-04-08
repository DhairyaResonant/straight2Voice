public class IOPhoneController {
    Public String phonebookID = System.currentPagereference().getParameters().get('id');
    public String name {get;set;}
    public String phoneNumber {get;set;}
    public IOVDPhone ioPhone = new IOVDPhone();
    public IOPhoneController()
    { 
        
    }
    public void insertPhoneNumber()
    {
        ioPhone =  IOVoicemailDropBackend.inputPhonenumber(name,phoneNumber,phonebookID);
        if(ioPhone.isSuccess==true)
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.CONFIRM,'Phone number added succesfully'  );
            ApexPages.addMessage(myMsg);
        }
        else
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Request failed. Please try again.'  );
            ApexPages.addMessage(myMsg);
        }
    }

}