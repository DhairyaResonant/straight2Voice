/*
* DESC: S2V PHONE BOOK APEX CLASS
*/

public class IOVoicemailDropBackend {
    
    public boolean noConversation {get;set;}
    
    //GET ACCOUNT DETAILS HTTP REQUEST
    public static IOVDAccount getAccountDetails(String username, String password){
        Http h = new Http();            
        HttpRequest req = new HttpRequest();
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        String contentType = 'application/x-www-form-urlencoded' ;
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/user/?format=json');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', contentType);
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        
        IOVDAccount acc = new IOVDAccount();
        
        if(res.getStatusCode() == 200){
            try{
                acc = (IOVDAccount)JSON.deserialize(res.getBody(), IOVDAccount.class);
                acc.isSuccess = true;
            }
            catch(Exception ex){
                acc.isSuccess = false;
                acc.errorMessage = 'Unexpected JSON response: '+res.getBody()+'---'+ex.getMessage()+'---'+ex.getStackTraceString();
            }
        }
        else{
            acc.isSuccess = false;
            acc.errorMessage = res.getStatusCode()+'-'+res.getBody();
        }
        return acc;
    }
    
    //VERIFYING CALLER ID BY VERIFYING USER'S CREDENTIALS SAVED IN CUSTOM SETTING.
    public static IOVDCallerID createCallerID(String callerIDNumber , String countryCode) {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        //HTTP REQUEST
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/callerID/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('POST'); 
        req.setBody('callerid='+callerIDNumber+'&country_code='+countryCode);
        HttpResponse res = h.send(req);
        
        
        IOVDCallerID callerID = (IOVDCallerID)JSON.deserialize(res.getBody(), IOVDCallerID.class);
        if(res.getStatusCode() >= 200 && res.getStatusCode() < 300){ 
            
            callerID.isSuccess = true;
        }
        else{ 
            callerID.isSuccess = false;
            
        }
        
        return callerID;
    }
    
    //AFTER SUBMITTING CALLER NUMBER FOR VERIFICATION 
    public static IOVDCallerID inputVerificationcode(String verificationCode , String CallerIDCode){
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        IOVDCallerID callerID= new IOVDCallerID() ;
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/callerID/'+CallerIDCode+'/?req=req_verify&code='+verificationCode);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET');  
        HttpResponse res = h.send(req);
        
        
        callerID = (IOVDCallerID)JSON.deserialize(res.getBody(), IOVDCallerID.class);
        if(res.getStatusCode()>=200 && res.getStatusCode() <=299 ){
            callerID.isSuccess = true;
        } else {
            callerID.isSuccess = false;
        } 
        
        return callerID;
    }
    
    //CALLER ID CODE METHOD
    public static IOVDCallerID requestCallerIDCode(String CallerIDCode ){
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        IOVDCallerID callerID;
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/callerID/'+CallerIDCode+'/?req=req_code');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET');  
        HttpResponse res = h.send(req);
        
        if(res.getStatusCode() == 200){
            callerID = (IOVDCallerID)JSON.deserialize(res.getBody(), IOVDCallerID.class);
            
            callerID.isSuccess = true;
        } else {
            callerID = (IOVDCallerID)JSON.deserialize(res.getBody(), IOVDCallerID.class);
            callerID.isSuccess = false;
            
        }
        
        return callerID;
    }
    
    //GET CALLER ID METHOD
    public static IOVDCallerID getCallerID() {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        IOVDAccount acc = new IOVDAccount();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/callerID/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        
        
        IOVDCallerID callerID;
        callerID = (IOVDCallerID)JSON.deserialize(res.getBody(), IOVDCallerID.class);
        if(res.getStatusCode() == 200){
            callerID.isSuccess = true;
            
        } else {
            callerID.isSuccess = false;
        }
        return callerID; 
    }
    
    //GET LIST OF VOICE MESSAGES 
    public static IORecording getVoiceMessages(String restUri){
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        IOVDAccount acc = new IOVDAccount();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+restUri);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        
        
        IORecording mRec;
        if(res.getStatusCode() == 200){
            mRec = (IORecording)JSON.deserialize(res.getBody(), IORecording.class);
            mRec.isSuccess = true;    
        } else if (res.getStatusCode() == 401) {
            mRec.isSuccess = false;//unauthorized redirect to login
        } else {
            mRec.isSuccess = false;
        }
        return mRec; 
    }
    
    //GET THE NUMBER OF RECORDINGS FROM S2V SITE
    public static IORecording getVoiceMessagesList() {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        System.debug(setting);
        IOVDAccount acc = new IOVDAccount();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/recording/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        
        System.debug(res.getBody());
        System.debug(res.getStatusCode());
        IORecording mRec;
        if(res.getStatusCode() == 200){
            mRec = (IORecording)JSON.deserialize(res.getBody(), IORecording.class);
            mRec.isSuccess = true;
            
        } else if (res.getStatusCode() == 401) {
            mRec.isSuccess = false;//unauthorized redirect to login
        } else {
            mRec.isSuccess = false;
        }
        System.debug(mRec);
        
        return mRec; 
    }
    
    //Created by Dhrudeep FOR THE NEW RECORDING AUTOMATION
    public static IORecording getVoiceMessagesList1(String usrname,String pasword,String urls){
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        System.debug(setting);
        IOVDAccount acc = new IOVDAccount();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = usrname;
        String password = pasword;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(urls+'/api/v1/recording/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        
        System.debug(res.getBody());
        System.debug(res.getStatusCode());
        IORecording mRec;
        if(res.getStatusCode() == 200){
            mRec = (IORecording)JSON.deserialize(res.getBody(), IORecording.class);
            mRec.isSuccess = true;
            
        } else if (res.getStatusCode() == 401) {
            mRec.isSuccess = false;//unauthorized redirect to login
        } else {
            mRec.isSuccess = false;
        }
        System.debug(mRec);
        
        return mRec; 
    }
    
    //FOR NEW SMS
    public static IOSMSHistory getSMS(String usrname, String pasword, String urls){
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());
        System.debug(setting);
        IOVDAccount acc = new IOVDAccount();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = usrname;
        String password = pasword;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(urls+'/api/v1/message/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        
        System.debug(res.getBody());
        System.debug(res.getStatusCode());
        IOSMSHistory mRec1;
        if(res.getStatusCode() == 200){
            mRec1 = (IOSMSHistory)JSON.deserialize(res.getBody(), IOSMSHistory.class);
            mRec1.isSuccess = true;
            
        } else if (res.getStatusCode() == 401) {
            mRec1.isSuccess = false;//unauthorized redirect to login
        } else {
            mRec1.isSuccess = false;
        }
        System.debug(mRec1);
        
        return mRec1; 
    }
    
    //GET CALL HISTORY METHOD
    public static IOCallHistory getCallHistory(String restOfUrl) {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        String endPoint = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+restOfUrl;
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        system.debug('res.getBody():::::::::::::::::'+res.getBody());
        IOCallHistory callHistory;
        if(res.getStatusCode() == 200){
            system.debug('res.getBody()in the if:::::::::::::::::'+res.getBody());
            callHistory = (IOCallHistory)JSON.deserialize(res.getBody(), IOCallHistory.class);
            callHistory.isSuccess = true; 
        } else {
            callHistory.isSuccess = false;
        }
        return callHistory;
    }
    
    //GET SMS HISTORY METHOD
    public static IOSMSHistory getSMSHistory(String restOfUrl){
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        String endPoint = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+restOfUrl;
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        system.debug('res.getBody():::::::::::::::::'+res.getBody());
        IOSMSHistory smsHistory;
        if(res.getStatusCode() == 200){
            system.debug('res.getBody()in the if:::::::::::::::::'+res.getBody());
            smsHistory = (IOSMSHistory)JSON.deserialize(res.getBody(), IOSMSHistory.class);
            smsHistory.isSuccess = true; 
        } else {
            smsHistory.isSuccess = false;
        }
        
        return smsHistory;
        
    }
   
    //GET SCHEDULED VOICEMAILS
    public static IOScheduleVoicemail getScheduledVoicemail(String restOfUrl)
    {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        system.debug('restOfUrl::::'+restOfUrl);
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        String endPoint = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+restOfUrl;
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        system.debug('res.getBody():::::::::::::::::'+res.getBody());
        IOScheduleVoicemail scheduleVoicemail;
        
        system.debug('res.getStatusCode:::::::'+res.getStatusCode());
        if(res.getStatusCode() == 200){
            system.debug('res.getBody()in the if:::::::::::::::::'+res.getBody());
            scheduleVoicemail = (IOScheduleVoicemail)JSON.deserialize(res.getBody(), IOScheduleVoicemail.class);
            scheduleVoicemail.isSuccess = true; 
        } else {
            scheduleVoicemail.isSuccess = false;
        }
        system.debug('scheduleVoicemail::::'+scheduleVoicemail);
        return scheduleVoicemail;
    }
    
    //GET PHONE BOOK NUMBER METHOD
    public static IOVDPhone inputPhonenumber(String name , String phoneNumber ,String phonebookID){
        IOVDPhone ioPhone = new IOVDPhone();
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        IOVDPhonebook phonebook = new IOVDPhonebook();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/phone/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('POST');
        req.setBody('name='+name+'&phone='+phoneNumber+'&number='+phoneNumber+'&phonebook=/api/v1/phonebook/'+phonebookID+'/');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 201){
            ioPhone.isSuccess=true;
        } else {
            ioPhone.isSuccess = false;
        }
        
        return ioPhone;
        
    }
    
    //CREATE CAMPAIGN METHOD IN S2V SITE
    public static IOVDCampaign createCampaign( String selectedCampId , String selectedVoice , String callerID){
        system.debug('createCampaign:::::::');
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        IOVDCampaign ioCamp = new IOVDCampaign();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/campaign/');
        system.debug('req.setEndpoint::::::::'+s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/campaign/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('POST'); 
        List<Campaign> camp = new List<Campaign>();
        
        //TRY CATCH STARTS HERE
        try{
            /*if(Schema.sObjectType.Campaign.fields.id.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Name.isAccessible() && 
               Schema.sObjectType.Campaign.fields.StartDate.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Status.isAccessible() && 
               Schema.sObjectType.Campaign.fields.type.isAccessible() && 
               Schema.sObjectType.Campaign.fields.S2V_Country_Codes__c.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Option_Schedule__c.isAccessible() && 
               Schema.sObjectType.Campaign.fields.Schedule_Frequency__c.isAccessible() && 
               Schema.sObjectType.Campaign.isAccessible()
              ){*/
                  camp  = [SELECT Name, StartDate, Status ,type ,S2V_Country_Codes__c, Option_Schedule__c , Schedule_Frequency__c,
                           (SELECT firstName,LastName,phone,MobilePhone FROM CampaignMembers WHERE phone != NULL or MobilePhone !=NULL)
                           FROM Campaign WHERE Id =: selectedCampId];
                  
              //}
            
        }
        catch(Exception ex){
            
        } 
        //TRY CATCH BLOCK ENDS
        
        String[] phoneList = New String[]{};
            String phoneListFinal; 
        
        //FOR LOOP ON CAMPAIGN MEMBERS
        for (CampaignMember cm : camp[0].CampaignMembers){     
            if(cm.phone != null){ 
                phoneList.add(cm.firstName+' ' + cm.LastName+' ' + cm.phone.deleteWhitespace());
            } else {
                phoneList.add(cm.firstName+' ' + cm.LastName+' ' + cm.MobilePhone.deleteWhitespace());
            }
        }
        
        phoneListFinal = string.join(phoneList,',');
        phoneListFinal = phoneListFinal.replace('(','');
        phoneListFinal = phoneListFinal.replace(')','');
        phoneListFinal = phoneListFinal.replace('-','');
        
        //GET PHONE AND NAME 
        Integer optionSchedual = 0;
        if(camp[0].Option_Schedule__c == 'Future call'){
            optionSchedual =1; 
        } else {
            optionSchedual = 0;
        }
        
        if(camp[0].S2V_Country_Codes__c == 'CA-US'){
            camp[0].S2V_Country_Codes__c = 'CA';
        }
        if(camp[0].StartDate == null ){
            req.setBody('name='+camp[0].Name+'&audio='+selectedVoice+'&phone_list='+phoneListFinal+'&phonecode='+camp[0].S2V_Country_Codes__c+'&callerID='+callerID+'&option_schedule='+optionSchedual+'&schedule_frequency='+camp[0].Schedule_Frequency__c);            
        } else {
            req.setBody('name='+camp[0].Name+'&audio='+selectedVoice+'&phone_list='+phoneListFinal+'&phonecode='+camp[0].S2V_Country_Codes__c+'&callerID='+callerID+'&option_schedule='+optionSchedual+'&schedule_frequency='+camp[0].Schedule_Frequency__c+'&schedule_date_to_start=00:00:00 '+camp[0].StartDate.day()+'/'+camp[0].StartDate.month()+'/'+camp[0].StartDate.year());
        }
        System.debug('request' + camp[0].Name+' '+selectedVoice+' '+phoneListFinal+' '+camp[0].S2V_Country_Codes__c+' '+callerID+' '+optionSchedual+' '+camp[0].Schedule_Frequency__c);
        //HTTP RESPONSE
        System.debug('req===='+req);
        HttpResponse res = h.send(req);
        System.debug('Response'+ res.getBody());
        
        ioCamp = (IOVDCampaign)JSON.deserialize(res.getBody(), IOVDCampaign.class); 
        if(res.getStatusCode() == 200){
            ioCamp.isSuccess = true;
        }else{
            ioCamp.isSuccess = false;
        } 
        return ioCamp;
    }
    
    //GET RECORDINGS METHOD
    public static String getRecording(String url){
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        req.setEndpoint(url);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('GET'); 
        HttpResponse res = h.send(req);
        String responseStr = null;
        
        if(res.getStatusCode() == 200){
            responseStr = EncodingUtil.base64Encode(res.getBodyAsBlob());
        } 
        return responseStr; 
    }
    
}