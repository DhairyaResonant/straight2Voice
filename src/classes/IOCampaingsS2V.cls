public with sharing class IOCampaingsS2V {
    
    public ApexPages.StandardSetController stdCntrlr {get; set;}
    public IOVDCampaign ioCamp {get; set;}    
    public id selectedCampId {get;set;} 
    public List<SelectOption> selectVoiceMessages {get;set;}
    public Boolean loginFlag{get;set;}
    public IOVDAccount acc {get; set;} 
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String authorizationHeader{get; private set;} 
    public List<SelectOption> selectCaller {get;set;}
    public String selectedVoice {get;set;}
    public String callerID {get;set;}
    Savepoint sp ;
    public List<SelectOption> countryNames { get; set; }
    
    public List<Campaign> campaigns {
        get{
            if(campaigns==null ){
                if(Schema.sObjectType.Campaign.fields.id.isAccessible() && 
                   Schema.sObjectType.Campaign.fields.Status.isAccessible() && 
                   Schema.sObjectType.Campaign.fields.Type.isAccessible() && 
                   Schema.sObjectType.Campaign.fields.Name.isAccessible() && 
                   Schema.sObjectType.Campaign.fields.Recording_Name__c.isAccessible() && 
                   Schema.sObjectType.Campaign.fields.Straight2Voicemail__c.isAccessible() && 
                   Schema.sObjectType.Campaign.isAccessible()
                  ){
                    campaigns = [Select id, Status, Type, Name, Recording_Name__c,s2vSMSDemo__S2V_campRollUp__c 
                                 from Campaign
                                 Where 
                                 Straight2Voicemail__c = true limit 999];
                }
            }
            return campaigns;
        }
        private set;
    }
    
    
    //CONSTRUCTOR
    public IOCampaingsS2V(){   
    }
    
    public void getCountryNames() {
        system.debug('in this method');
        countryNames = new List<SelectOption>();
        
        List<s2vSMSDemo__CountryCode__c> allCountries = new List<s2vSMSDemo__CountryCode__c>();
        
        allCountries = [ SELECT  Name, s2vSMSDemo__Active__c FROM s2vSMSDemo__CountryCode__c];
        
        for(s2vSMSDemo__CountryCode__c country : allCountries ) {
            countryNames.add( new SelectOption( country.Id, country.Name ) );
        }
    }
    
    public void getDropDownCallerList(){
        error = false;
        selectVoiceMessages = new List<SelectOption>(); 
        selectCaller = new List<selectOption>();
        IOVDCallerID callerID =  IOVoicemailDropBackend.getCallerID();
        if(callerID.isSuccess == true){  
            for(IOVDCallerID.RObject r : callerID.objects){
                if(r.verified == true)
                    selectCaller.add(new SelectOption(r.callerid,r.callerid));
                
            }
        }
        IORecording mRec = IOVoicemailDropBackend.getVoiceMessagesList();
        
        if(mRec.isSuccess== true){   
            for (IORecording.RObject r : mRec.objects ) {
                selectVoiceMessages.add(new SelectOption(r.name,r.name));
            }
        }       
        
    }
    
    public PageReference pageAction(){
        setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        loginFlag=setting.s2vSMSDemo__password__c != null && setting.s2vSMSDemo__username__c != null;
        
        if(loginFlag == true){
            authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(Blob.valueOf( setting.s2vSMSDemo__username__c + ':' + setting.s2vSMSDemo__password__c));
            acc = IOVoicemailDropBackend.getAccountDetails(setting.s2vSMSDemo__username__c, setting.s2vSMSDemo__password__c);
            
            if( acc.isSuccess == false){
                loginFlag = false; 
                return  doredirect();
                //acc.errormessage
            }   
            getDropDownCallerList();
        } else {
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
    
    public boolean error{get;set;}
    
    public void creatNewCampaign(){
        
        try{
            if(Schema.sObjectType.Campaign.fields.id.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Status.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Type.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Name.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Recording_Name__c.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Straight2Voicemail__c.isAccessible() && 
               Schema.sObjectType.Campaign.isAccessible()
              ){
                // sp = Database.setSavepoint();  Not Serializable: System.Savepoint error received
                Campaign camp = [select status from Campaign where id=: selectedCampId ];
                camp.Status='Completed'; 
                camp.Recording_Name__c = selectedVoice;
                if(Schema.SObjectType.Campaign.Fields.Recording_Name__c.isUpdateable() &&
                   Schema.SObjectType.Campaign.Fields.Status.isUpdateable() ){
                    update camp;//update campaign status  
                }
                error = false;
            } else {
                error = true;
            }
        }
        
        catch(DmlException ex) {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)  );
            ApexPages.addMessage(myMsg);
            error = true;
        }           
    }  
    
    public void syncNewCampaign(){
        system.debug('system.debug');
        ioCamp = IOVoicemailDropBackend.createCampaign(selectedCampId , selectedVoice , callerID);        
        if(ioCamp.isSuccess == true){
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.CONFIRM,ioCamp.message  );
            ApexPages.addMessage(myMsg);
            campaigns = null;
        } else {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,ioCamp.message  );
            ApexPages.addMessage(myMsg);
            Database.rollback(sp);
            
        } 
    }
    
}