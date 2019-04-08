/**
* Created by Murtaza on 3/14/2017.
*/

Global class S2VRecordingClass{
    
    public List<IORecording.RObject> objects{get;set;}
    public List<Integer> numbers {get;set;}
    
    public List<String> rcrdings {get;set;}
   
    public Boolean loginFlag{get;set;}
    public IOVDAccount acc {get; set;} 
    public IORecording rec {get;set;}
    public s2vSMSDemo__S2V_Settings1__c setting{get; private set;}
    public String authorizationHeader{get; private set;}
    public String phoneNumberVoice {get;set;}
    public String recName {get;set;}
    public String callerCodeOption {get;set;}
    public String recrddltid{get;set;}
    public string next{get;set;}
    public string prev{get;set;}
    public map<String,IORecording.RObject> avairecordid {get;set;}
    private static integer recsPerPage = 10;
    public Map<String,String> discriptionmap {get;set;}

    public S2VRecordingClass()
    {   
        discriptionmap = new Map<String,String>();
        avairecordid = new map<String,IORecording.RObject>();
      
        rcrdings = new List<String>();
        
        s2vSMSDemo__S2V_Settings1__c mc = s2vSMSDemo__S2V_Settings1__c.getOrgDefaults();
         
        if(mc.s2vSMSDemo__username__c != Null && mc.s2vSMSDemo__username__c != ''){
       
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        IORecording mRec = IOVoicemailDropBackend.getVoiceMessagesList1(setting.s2vSMSDemo__username__c ,setting.s2vSMSDemo__password__c,setting.url__c );
        List<Recording__c> lstdiscription = [SELECT Id,Description__c,Recording_Number__c FROM Recording__c WHERE Recording_Number__c!=NULL];
        // GETTING ALL RECORDINGS AND FETCHING ONLY THOSE WHICH HASE USER ID OF LOGED IN USER 
        if(mRec.isSuccess== true){   
            for (IORecording.RObject r : mRec.objects){
                    if( r.recording_number != '' && r.saleslforce_user_id == UserInfo.getUserId() ){
                        IORecording.RObject objIo = new IORecording.RObject();
                        objIo.Id = r.Id;
                        objIo.recording_number = r.recording_number;
                        objIo.audio_file = r.audio_file;
                        objIo.description = r.description;
                        rcrdings.add(r.recording_number);
                     
                        avairecordid.put(r.recording_number,objIo);

                    }
                }
            }

            //PULLING DESCRIPTIONS FROM FESCRIPTION OBJECT AND SHOWING IN THE RECORDING PAGE BASED ON THE NUMBERS
            for(Recording__c s2vdisc : lstdiscription){
                if(s2vdisc.Description__c != Null && s2vdisc.Description__c != ''){
                    discriptionmap.put(String.valueOf(s2vdisc.Recording_Number__c),s2vdisc.Description__c);
                }
            }

            //PULLING DESCRIPTIONS FROM FESCRIPTION OBJECT , IF DESCRIPTION IS BLANK REPLACE IT WITH SPACE TO AVOIDE NULL ERROR
                IORecording.RObject objIo1 = new IORecording.RObject();
                 for(Integer i=1;i<11;i++){
                    
                    if(avairecordid.containsKey(String.valueOf(i))){
                        
                    } else {
                        avairecordid.put(String.valueof(i),objIo1);
                    }

                    if(discriptionmap.containsKey(String.valueOf(i))){
                        
                    } else {
                        discriptionmap.put(String.valueof(i),'');
                    }
                    
                 }

              
            //FOR REPEATER TO SHOW 1 TO 10 RECORDINGS           
            numbers = new List<Integer>();
            for(Integer i=1;i<11;i++)
            {
                numbers.add(i);

            }
        }else{
            doredirect();
        }


    }

    public void deleteRecording(){
        System.debug(recrddltid);
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
        System.debug(data);
        return data;
    }

    public Pagereference RedirectoHome()
    {
        PageReference pr = new PageReference(System.URL.getSalesforceBaseUrl().toExternalForm()+'/home/home.jsp');
        pr.setRedirect(true);
        return pr;    
    }
}