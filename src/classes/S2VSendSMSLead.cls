/*
* Created By: Dhairya Shah
* Desc: Sending SMS on just a button click from Lead page layout
* Date: 3rd Jan 2019
*/ 

global with sharing class S2VSendSMSLead {
    
    public Lead objLead {get;set;}
    public String objectName {get;set;}
    public String Leadid {get;set;}
    public String LeadName {get;set;}
    public String LeadMobile {get;set;}
    public String smsTemplateId {get;set;}
    public String smstemplateName {get;set;}
    public String smstemplateBody {get;set;}
    public String userMobile {get;set;}
    public Boolean retVal {get;set;}
    public Boolean isLoggedin {get;set;}
    
    public S2VSendSMSLead(ApexPages.StandardController controller){
        retVal = false;
        this.objLead = (Lead)controller.getRecord();
        Lead leadobj = [SELECT id,Name,MobilePhone FROM Lead WHERE id=:objLead.id LIMIT 1];
        objectName = 'Lead';
        
        if(leadobj.id!=NULL){
            Leadid = leadobj.id;
        }
        
        if(leadobj.Name!=NULL){
            LeadName = leadobj.Name;
        }
        
        if(leadobj.MobilePhone!=NULL){
            LeadMobile = leadobj.MobilePhone;
        }
        
        User loggedInUser = [SELECT id,Name,MobilePhone FROM User WHERE id=:userInfo.getUserId() LIMIT 1];
        userMobile = loggedInUser.MobilePhone;
        
        isLoggedin =true;
        s2vSMSDemo__S2V_Settings1__c customsetting = s2vSMSDemo__S2V_Settings1__c.getOrgDefaults();
        
        if(customsetting.s2vSMSDemo__password__c != Null && customsetting.s2vSMSDemo__username__c != ''){
            isLoggedin = false;
        }
        
    }
    
    public List<SelectOption> getSmsTemplates(){
        try{ 
            
            List<SelectOption> options = new List<SelectOption>();
            List<SMS_Template__c> objListSMStemplates = [Select id,Template_Name__c,Template_Body__c from SMS_Template__c where Template_Name__c!=NULL];
            
            options.add(new SelectOption('none','Select the SMS Template'));
            if((objListSMStemplates!=null) && (!objListSMStemplates.isEmpty())){
                for(SMS_Template__c objEmailTemp : objListSMStemplates){
                    options.add(new SelectOption(objEmailTemp.id,objEmailTemp.Template_Name__c));
                    system.debug('7th Debug Email templates:'+options);
                }
            }
            return options;
        }
        catch(QueryException e){
            ApexPages.addMessages(e);
            return null;  
        }
        
    }
    
    public PageReference AllSmsTemplate(){
        try{
            SMS_Template__c objSMSTemplate = [Select id,Template_Name__c,Template_Body__c from SMS_Template__c where id=:smstemplateID limit 1];
            smstemplateName = objSMSTemplate.Template_Name__c;
            smstemplateBody = objSMSTemplate.Template_Body__c;
            system.debug('smstemplateID::::'+smstemplateID);
            system.debug('smstemplateBody:::::'+smstemplateBody);
            return null;            
        }
        catch(QueryException e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Error');
            ApexPages.addMessage(myMsg); 
            return null;
        }
        
    }
    
    public pageReference SendSMS(){
        
        try{
            
            if(objectName!=NULL && Leadid!=NULL && (smstemplateBody!=NULL || smstemplateBody!='') && userMobile!=NULL && LeadMobile!=NULL){
                S2VVoiceMailSendPageController.singleSMSSending(objectName, Leadid, smstemplateName, smstemplateBody, userMobile, LeadMobile);
                retVal = true;  
            }
            System.debug('retVal --> ' + retVal);
            if(retVal == true){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,+''+'Your message has been sent successfully.Thank you!'));
            } else {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+''+'Something went wrong. Please contact to your system admin!'));
                
            }
            
            
        }
        catch(Exception e){
            system.debug('exception:::'+e.getMessage());
        }
        
        return null;

    }
    
    
}