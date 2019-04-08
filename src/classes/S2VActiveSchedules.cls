/*CREATED BY: DHAIRYA & DHRUDEEP
 *DATED: 28TH JUNE 2018
 *DESC: THIS CLASS IS USED FOR GETTING THE ACTIVE SCHEDULES PART.
*/
Global class S2VActiveSchedules{
    public String recId {get;set;}
    public List<S2V_Send_Voicemail__c> lstS2VVoiceMails {get;set;}
    
    public S2VActiveSchedules(){
        lstS2VVoiceMails = new List<S2V_Send_Voicemail__c>();
        lstS2VVoiceMails = [Select Id,Object_Name__c,Reference_Field_Lable__c,Option_Schedule__c,Recording_Name__c,Reference_Field__c,Schedule_Frequency__c,Start_Date__c,CreatedById,CreatedBy.Name from S2V_Send_Voicemail__c limit 50000];
    }
    
    //DELETING THE RECORDS
    public PageReference deleteRecord(){
        if(recId != null && recId.trim() != ''){
            S2V_Send_Voicemail__c tempObj = new S2V_Send_Voicemail__c(Id=recId);
            
            if(Schema.sObjectType.S2V_Send_Voicemail__c.isDeletable()){
                delete tempObj;
            }
            
        }
        
        PageReference pr = new PageReference('/apex/AllS2VVoiceMailsPage');
        pr.setRedirect(true);
        return pr;
    }
}