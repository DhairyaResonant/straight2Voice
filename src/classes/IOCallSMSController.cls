/*
 * DESC: S2V SMS HISTORY CONTROLLER WHERE YOU CAN SEE LIST OF SMS SENT
 */

public with sharing class IOCallSMSController{

	public IOSMSHistory smsHistory {get;set;} 
    public Boolean loginFlag{get;set;}
    public IOVDAccount acc {get; set;}  
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String authorizationHeader{get; private set;}
    public String smsStatus{get;set;}
    public List<IOSMSHistory.RObject> objects{get;set;}
    private static integer recsPerPage = 100;
    
    //GET RECORDS
    private void getRecords(String uri){
        smsHistory =IOVoicemailDropBackend.getSMSHistory(uri);
        next = smsHistory.meta.next;
        prev = smsHistory.meta.previous;
        
        if(smsHistory.isSuccess == true){  
            objects =  smsHistory.objects;
        }
    }
    public string next{get;set;}
    public string prev{get;set;}
    
    //CONSTRUCTOR
    public IOCallSMSController(){
       
    } 
    
    //DISPLAY LIST OF RECORDS IN S2V CALL HISTORY
    public void displayRecordList(){
        next = '/api/v1/message/?limit='+recsPerPage+'&offset=0';

        system.debug('smsStatus::::::'+smsStatus);
        if(APexpages.currentPage().getParameters().get('campaign_name') != null){
            next += '&campaign_name='+EncodingUtil.urlEncode(APexpages.currentPage().getParameters().get('campaign_name'),'utf-8');
        }
        getRecords(next);
    }
    
    public PageReference pageAction(){
        setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        loginFlag=setting.s2vSMSDemo__password__c != null && setting.s2vSMSDemo__username__c != null;
        
        if(loginFlag == true){
            authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(Blob.valueOf( setting.s2vSMSDemo__username__c + ':' + setting.s2vSMSDemo__password__c));
            acc = IOVoicemailDropBackend.getAccountDetails(setting.s2vSMSDemo__username__c, setting.s2vSMSDemo__password__c);
            
            if(acc.isSuccess == false){
                loginFlag = false; 
                 return  doredirect();
            }  
             displayRecordList();
        }
        else {
            loginFlag = false; 
         	return  doredirect();
        }
        return null;
    }
    
    public PageReference doredirect(){
        PageReference pr = new PageReference('/apex/IOMyAccount');
        pr.setRedirect(true);
        return pr; 
    }
    
    //PAGINATION
    public void next(){
        getRecords(next);
    }
    
    public void prev(){
        getRecords(prev);
    }
}