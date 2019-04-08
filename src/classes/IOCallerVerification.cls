public class IOCallerVerification {
    
    IOVDCallerID callerID = new IOVDCallerID();
    Public String CallerIDCode = System.currentPagereference().getParameters().get('id');
    public Boolean verficationCodecheck{get;set;}
    public String verificationCodeNumber{get;set;}
    public List<IOVDCallerID.RObject> objects{get;set;}
    public Boolean loginFlag{get;set;} 
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;} 
    public String authorizationHeader{get; private set;}
    public IOVDAccount acc {get; set;}
    
    public IOCallerVerification()
    {
         
    }
    
     public PageReference pageAction()
    {
         setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        loginFlag=setting.s2vSMSDemo__password__c != null && setting.s2vSMSDemo__username__c != null;
        
        if(loginFlag == true)
        {
            authorizationHeader = 'Basic ' +
                EncodingUtil.base64Encode(Blob.valueOf( setting.s2vSMSDemo__username__c + ':' + setting.s2vSMSDemo__password__c));
            acc = IOVoicemailDropBackend.getAccountDetails(setting.s2vSMSDemo__username__c, setting.s2vSMSDemo__password__c);
            if( acc.isSuccess == false)
            {
                loginFlag = false; 
                 return  doredirect(); 
            }   
            requestCallerIDCode();
        }
        else
        {
            
            loginFlag = false; 
         return  doredirect();
        }
        return null;
    } 
    
    public PageReference doredirect()
    {
        PageReference pr = new PageReference('/apex/S2V__IOMyAccount');
        pr.setRedirect(true);
        return pr;
        
    }
    
    public void requestCallerIDCode()
    {
        callerID = IOVoicemailDropBackend.requestCallerIDCode(CallerIDCode);
        if(callerID.isSuccess == true)
        { 
            verficationCodecheck = true;
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.CONFIRM,'Verification Code Succesfully Sent.'  );
            ApexPages.addMessage(myMsg); 
        }
        else
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,callerID.error  );
            ApexPages.addMessage(myMsg); 
        }
    }
    
    public PageReference  inputVerificationcode()
    {
        
        callerID = IOVoicemailDropBackend.inputVerificationcode(verificationCodeNumber , CallerIDCode );
        
        if(callerID.isSuccess == true)
        {  
            verficationCodecheck = false;
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.CONFIRM,'Successfully verified.'  );
            ApexPages.addMessage(myMsg); 
            PageReference reference=new PageReference('/apex/S2V__IOCallerID');
            reference.setRedirect(true);
            return reference;
            
        }
        else
        {
              
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,callerID.error  );
            ApexPages.addMessage(myMsg); 
            return null;
        }
    }
    
    
    
}