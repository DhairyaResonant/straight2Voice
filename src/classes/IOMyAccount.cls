/*
 * Edited By: Dhairya Shah
 * Desc: s2v Account page information
 */ 
public  with sharing class IOMyAccount{
    
    public String username {get; set;}
    public String FullName {get;set;}
    public String password {get; set;}
    public String avatar {get; set;} 
    public boolean loginFlag {get; set;}
    public String signupUrl {get;set;}
    public IOVDAccount acc {get; set;}
    public String selectedcountrycode {get;set;}
    
    
    //MY ACCOUNT
    public IOMyAccount(){
        s2vSMSDemo__S2V_Settings1__c  setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        signupUrl = setting.s2vSMSDemo__url__c + '/accounts/register/';
        loginFlag=setting.s2vSMSDemo__password__c != null && setting.s2vSMSDemo__username__c != null;
       
        if(loginFlag == true){ 
            acc = IOVoicemailDropBackend.getAccountDetails(setting.s2vSMSDemo__username__c, setting.s2vSMSDemo__password__c);
           
            s2vSMSDemo__Countrycode__c codes= [select Name,s2vSMSDemo__Active__c from Countrycode__c where s2vSMSDemo__Active__c =: True limit 1];
            selectedcountrycode = codes.Name;
            System.debug(acc);
            if(acc.avatar == null){
                avatar = setting.s2vSMSDemo__Profile_Image__c;
            }
            else{
                avatar = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/'+acc.avatar;
            }
            if( acc.isSuccess == false){ 
                loginFlag = false; 
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Wrong credential. Please try again.'  );
                ApexPages.addMessage(myMsg);  
            } 
        }
    }
    
    //LOGOUT
    public void logout(){
        s2vSMSDemo__S2V_Settings1__c setting = s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        setting.s2vSMSDemo__username__c='';
        setting.s2vSMSDemo__password__c='';
        upsert setting;
        loginFlag = false; 
        
        List<s2vSMSDemo__CountryCode__C> updateCC = new List<s2vSMSDemo__CountryCode__c>();
        List<s2vSMSDemo__Countrycode__c> listCC = [SELECT id,Name,s2vSMSDemo__Active__c FROM s2vSMSDemo__Countrycode__c WHERE Name!=NULL];
        for(s2vSMSDemo__Countrycode__c objC : listCC){
            if(objC.Name!=NULL && objC.s2vSMSDemo__Active__c == FALSE){
                objC.s2vSMSDemo__Active__c = TRUE;
                updateCC.add(objC);
            }
        }
        
        if(updateCC!=NULL && updateCC.size()>0){
            system.debug('success');
            update updateCC;
        }
        
    }
    
    //SEND REQUEST
    public void sendRequest(){ 
            
        //IOLoginS2V(username,password);
        acc = IOVoicemailDropBackend.getAccountDetails(username, password);
        System.debug(username+' '+password);
        System.debug(acc);
        if( acc.isSuccess == true){
            if(acc.avatar == null){
                avatar = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__Profile_Image__c;
            } else {
                avatar =s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c +'/'+ acc.avatar;
            } 
            loginFlag = true;
            s2vSMSDemo__S2V_Settings1__c setting =   s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
            setting.s2vSMSDemo__username__c=username;
            setting.s2vSMSDemo__password__c=password;
            
            upsert setting;
            
            if(selectedcountrycode != Null && selectedcountrycode != ''){

                List<s2vSMSDemo__Countrycode__c> rec = [select Name,s2vSMSDemo__Active__c from s2vSMSDemo__Countrycode__c where Name !=NULL];
                
                if(rec != Null && rec.size()>0){
                    for(s2vSMSDemo__Countrycode__c code : rec){
                        code.Active__c = False;
                    }
                    update rec;
                }
                
                s2vSMSDemo__Countrycode__c cod = s2vSMSDemo__Countrycode__c.getInstance(selectedcountrycode);
                cod.Active__c = True;
                update cod;
            }
            
        }    
        else{ 
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Wrong credential. Please try again.'  );
            ApexPages.addMessage(myMsg);  
        } 
    } 
    
    //COUNTRY CODE
    public List<SelectOption> getAllcountrycode(){
        List<s2vSMSDemo__Countrycode__c> rec = [select Name,s2vSMSDemo__Active__c from s2vSMSDemo__Countrycode__c where active__c = true];
        List<SelectOption> result = new List<SelectOption>();
        result.clear();
        for(s2vSMSDemo__Countrycode__c rec1 : rec) {
            result.add(new selectoption(rec1.Name,rec1.Name));
        }
        System.debug(result);
        return result;      
    }
}