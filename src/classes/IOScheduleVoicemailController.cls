/*
* Created By: Dhairya Shah
* Desc: Scheduled History Data
*/

public with sharing class IOScheduleVoicemailController 
{    
    public IOScheduleVoicemail scheduleVoicemail {get;set;} 
    public Boolean loginFlag{get;set;}
    public IOVDAccount acc {get; set;}  
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String authorizationHeader{get; private set;}
    public String recrddltid{get;set;}
    public List<IOScheduleVoicemail.RObject> objects{get;set;}
    private static integer recsPerPage = 50;
    
    private void getRecords(String uri)
    {
        scheduleVoicemail =IOVoicemailDropBackend.getScheduledVoicemail(uri);
        next = scheduleVoicemail.meta.next;
        prev = scheduleVoicemail.meta.previous;
        
        if(scheduleVoicemail.isSuccess == true)
        {  
            objects =  scheduleVoicemail.objects;
        }
    }
    
    public string next{get;set;}
    public string prev{get;set;}
    
    public IOScheduleVoicemailController()
    {
        
    } 
    
    public void displayRecordList()
    {
        next = '/api/v1/campaign/?limit='+recsPerPage;
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
    
    public void deleteRecording(String recordId){
        System.debug(recrddltid);
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