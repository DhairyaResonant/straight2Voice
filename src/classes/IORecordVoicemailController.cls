/**
* Created by Murtaza on 3/14/2017.
*/

public with sharing class IORecordVoicemailController {
    
    public List<IORecording.RObject> objects{get;set;}
    public Boolean loginFlag{get;set;}
    public IOVDAccount acc {get; set;} 
    public IORecording rec {get;set;}
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String authorizationHeader{get; private set;}
    public String phoneNumberVoice {get;set;}
    public String recName {get;set;}
    public String callerCodeOption {get;set;}
    
    public string next{get;set;}
    public string prev{get;set;}
    private static integer recsPerPage = 10;
    public IORecordVoicemailController()
    {   
        // displayRecording();  
      
     

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
            displayRecording();
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
    
    public void displayRecording()
    {
        next = '/api/v1/recording/?format=json&limit='+recsPerPage+'&offset=0';
        if(APexpages.currentPage().getParameters().get('name') != null)
        {
            next += '&name='+EncodingUtil.urlEncode(APexpages.currentPage().getParameters().get('name'),'utf-8');
        }
        getRecording(next);
    }
    
    public void next()
    {
        getRecording(next);
    }
    public void prev()
    {
        getRecording(prev);
    }
    
    public void getRecording(String uri)
    {
        IORecording mRec = IOVoicemailDropBackend.getVoiceMessages(uri);
        next = mRec.meta.next;
        prev = mRec.meta.previous;
        
        
        
        
        
        if(mRec.isSuccess== true)
        {   
            objects = mRec.objects;
            
        }
    }
    @RemoteAction
    public static String getRecBuffer(String url)
    {
        String data = IOVoicemailDropBackend.getRecording(url);
        return data;
    }
}