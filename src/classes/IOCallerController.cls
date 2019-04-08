public class IOCallerController {
    
    IOVDCallerID callerID = new IOVDCallerID();
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String callerIDNumber{get;set;}
    public String callerCodeOption {get;set;}
    public Boolean loginFlag{get;set;} 
    public String authorizationHeader{get; private set;}
    public IOVDAccount acc {get; set;}
    public String CallerIDCode {get;set;}
    public Boolean verficationCodecheck {get;set;}
    public String  verificationCodeNumber{get;set;}
    public List<IOVDCallerID.RObject> objects{get;set;}
    
    public IOCallerController()
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
                //acc.errormessage
            } 
            getCallerIDS2V();
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
    
    
    public void inputVerificationcode()
    {
        
        callerID = IOVoicemailDropBackend.inputVerificationcode(verificationCodeNumber , callerID.id);
        
        if(callerID.isSuccess == true)
        {  
            verficationCodecheck = false;
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.CONFIRM,'Successfully verified.'  );
            ApexPages.addMessage(myMsg); 
        }
        else
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,callerID.error  );
            ApexPages.addMessage(myMsg); 
        }
    }
    
    public void createCallerID()
    {
        if(callerCodeOption == 'CA-US'){
            callerCodeOption = 'CA';
        } 
        
        System.debug('callerCodeOption---------->'+callerCodeOption);
        callerID = IOVoicemailDropBackend.createCallerID(callerIDNumber, callerCodeOption );
        if(callerID.isSuccess == true)
        {
            CallerIDCode = callerID.id;
            
            getCallerIDS2V();
        }
        else
        {
            
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,callerID.error  );
            ApexPages.addMessage(myMsg); 
        }
    }
    
    public void requestCallerIDCode()
    {
        callerID = IOVoicemailDropBackend.requestCallerIDCode(CallerIDCode);
        if(callerID.isSuccess == true)
        { 
            verficationCodecheck = true;
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.CONFIRM,'Succesfully added.'  );
            ApexPages.addMessage(myMsg); 
        }
        else
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,callerID.error  );
            ApexPages.addMessage(myMsg); 
        }
    }
    
    public void getCallerIDS2V()
    {
        callerID = IOVoicemailDropBackend.getCallerID();
        if(callerID.isSuccess == true)
        {  
            objects =  callerID.objects;
            
        }
        else
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Error occured please try again.'  );
            ApexPages.addMessage(myMsg);  
        } 
    } 
    
    public List<SelectOption> getAllcountrycode()
    {
        List<s2vSMSDemo__Countrycode__c> rec = [select Name,s2vSMSDemo__Active__c from s2vSMSDemo__Countrycode__c where s2vSMSDemo__Active__c =: True];
        List<SelectOption> result = new List<SelectOption>();
        result.clear();
        if(rec != Null && rec.size()>0){
            for(s2vSMSDemo__Countrycode__c rec1 : rec) {
                result.add(new selectoption(rec1.Name,rec1.Name));
            }
            System.debug(result);
        }
        return result;      
    }
}