/*
 * Created By: Dhairya Shah
 * Desc: Call History Data
*/

public with sharing class IOCallHistoryController 
{
    public IOCallHistory callHistory {get;set;} 
    public Boolean loginFlag{get;set;}
    public IOVDAccount acc {get; set;}  
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String authorizationHeader{get; private set;}
    
    public List<IOCallHistory.RObject> objects{get;set;}
    private static integer recsPerPage = 100;
    
    private void getRecords(String uri)
    {
        callHistory =IOVoicemailDropBackend.getCallHistory(uri);
        next = callHistory.meta.next;
        prev = callHistory.meta.previous;
        
        if(callHistory.isSuccess == true)
        {  
            objects =  callHistory.objects;
            
        }
    }
    
    public string next{get;set;}
    public string prev{get;set;}
    public IOCallHistoryController()
    {
       
    } 
    public void displayRecordList()
    {
        next = '/api/v1/cdr/?limit='+recsPerPage+'&offset=0';
        if(APexpages.currentPage().getParameters().get('campaign_name') != null)
        {
            next += '&campaign_name='+EncodingUtil.urlEncode(APexpages.currentPage().getParameters().get('campaign_name'),'utf-8');
        }
        getRecords(next);
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
             displayRecordList();
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
        
    public void next()
    {
        getRecords(next);
    }
    public void prev()
    {
        getRecords(prev);
    }
}