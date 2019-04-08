/*
 * Created By: Dhairya Shah
 * Date: 5th Jan 2019
 * Desc: Chat conversation on Lead page only available in lightning.
 */ 
global with sharing class S2V2WayConversationCtrlLead {
    
    public String objectName {get;set;}
    public String activeUserName {get;set;}
    public String activeUserMobile {get;set;}
    public String activeUserPhoto {get;set;}
    public DateTime lastLoginDateTime {get;set;}
    public Date lastLoginDate {get;set;}
    public Lead objLead {get;set;}
    public String LeadId {get;set;}
    public String LeadName {get;set;}
    public String LeadMobile {get;set;}
    public String message {get;set;}    
    public String allMessages {get;set;}
    public DateTime currentDateTime {get;set;}
    Integer count = 0;
    
    public IOSMSHistory smsHistory {get;set;} 
    public Boolean loginFlag{get;set;}
    public IOVDAccount acc {get; set;}  
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String authorizationHeader{get; private set;}
    public string next{get;set;}
    public String messageFromSMSobject{get;set;}
    public Boolean messageStatus {get;set;}
    public boolean messageValue {get;set;}
    
    //CONSTRUCTOR
    public S2V2WayConversationCtrlLead(ApexPages.StandardController controller){
        this.objLead = (Lead)controller.getRecord();
        objectName = 'Lead';
        Lead leadObj = [SELECT id,Name,MobilePhone FROM Lead WHERE id=:objLead.id LIMIT 1];
        
        if(leadObj.id!=NULL){
            LeadId = leadObj.id;
        }
        
        if(leadObj.Name!=NULL){
            LeadName = leadObj.Name;
        }
        
        if(leadObj.MobilePhone!=NULL){
            LeadMobile = leadObj.MobilePhone;
        }
        
        User userRecords = [SELECT id,Name,MobilePhone,SmallPhotoUrl,LastLoginDate FROM User where id =:UserInfo.getUserId() LIMIT 1];
        
        if(userRecords.Name!=NULL){
            activeUserName = userRecords.Name;
        }
        
        if(userRecords.MobilePhone!=NULL){
            activeUserMobile = userRecords.MobilePhone;
        }
        
        if(userRecords.SmallPhotoUrl!=NULL){
            activeUserPhoto = userRecords.SmallPhotoUrl;
        }
        
        currentDateTime = DateTime.Now();
    }
    
    public List<IOSMSHistory.RObject> objects{get;set;}
     
    
    //GET RECORDS 
    private void getRecords(String uri){
        smsHistory =IOVoicemailDropBackend.getSMSHistory(uri);
       
        if(smsHistory.isSuccess == true){  
            objects =  smsHistory.objects;
        }
        
    }
   
    
    //GET SMS RECORDS
    public void getSMSList(){
        if(activeUserMobile!=NULL && LeadMobile!=NULL){
            system.debug('LeadMobile:::::::::'+LeadMobile);
            next = '/api/v1/message/?from_number='+LeadMobile;
            
            if(next!=NULL){
                getRecords(next);  
            }  
            
        } 
        
        
        // Reverse list of objects
        List<IOSMSHistory.RObject> reversed = objects;
        objects = new List<IOSMSHistory.RObject>();
        if(reversed != null && reversed.size() > 0){
            for(Integer i = reversed.size() - 1; i >= 0; i--){
                objects.add(reversed[i]);
            }
        }
        
        system.debug(objects.size());
        if(objects != null && objects.size()>0){
            messageValue = false;
        } else {
            messageValue = true;
        }
        system.debug('messageValue::::'+messageValue);
    }
    
    /*public void getSMSFromSF(){
        List<SMS_Recieved__c> listSMSRec = [SELECT id,from_number__c,to_number__c,message__c,Message_Status__c,CreatedDate FROM SMS_Recieved__c 
                                            WHERE from_number__c =:LeadMobile AND Message_Status__c='Message reveived' ORDER BY CreatedDate ASC];
        
        for(SMS_Recieved__c objSMSRec : listSMSRec){
            if(objSMSRec.From_Number__c!=NULL && objSMSRec.To_Number__c!=NULL && objSMSRec.Message__c!=NULL &&objSMSRec.Message_Status__c=='Message reveived'){
                if(objSMSRec.From_Number__c == LeadMobile){
                    system.debug('objSMSRec.Message__c:::'+objSMSRec.Message__c);
                    messageFromSMSObject = objSMSRec.Message__c;
                    messageStatus = true;
                } else {
                    messageStatus = false;
                }
            }
        }
        system.debug('messageStatus:::::::'+messageStatus);
    }*/
   
    
    //PAGE ACTION TO CHECK THE CREDENTIALS
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
            getSMSList();
            //getSMSFromSF();
            SendSMS();
        }
        else {
            loginFlag = false; 
            return  doredirect();
        }
        return null;
    }
    
    //SEND SMS METHOD
    public pageReference SendSMS(){
        
        if(message!=NULL && message!='' && objectName!=NULL && activeUserMobile!=NULL && LeadMobile!=NULL && leadId!=NULL){
           // allMessages+= message;
            Boolean isSuccess = S2VVoiceMailSendPageController.sendSMSMethodSingle2Way (objectName, activeUserMobile, LeadMobile, message, leadId);
            if(isSuccess == true){
                getSMSList();
            }
            return null;
        } 
        return null;
    }
    
    
    public PageReference doredirect(){
        PageReference pr = new PageReference('/apex/S2V2WayErrorPage');
        pr.setRedirect(true);
        return pr; 
    }
    
    public PageReference incrementCounter() {
        count++;
        return null;
    }
			
    public Integer getCount() {
        return count;
    }
    
    @AuraEnabled
    public static String getOrganizationDomain(){
        return Url.getSalesforceBaseUrl().getHost();
    }
    
}