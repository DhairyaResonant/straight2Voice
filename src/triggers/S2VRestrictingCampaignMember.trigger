/*
* CreadtedBy: Dhairya Shah
* Date: 11/9/2018  
* Desc: Restricting Campaign member insertion if timezone is different
*/ 
trigger S2VRestrictingCampaignMember on CampaignMember (before insert, before update) {
    
    s2vSMSDemo__S2V_Trigger_Handler__c trghandler = [SELECT id,name,s2vSMSDemo__S2VRestrictingCampaignMember__c  FROM s2vSMSDemo__S2V_Trigger_Handler__c where name = 'TriggerHandler'];
    if(trghandler.s2vSMSDemo__S2VRestrictingCampaignMember__c == true){
        //IS BEFORE
        for(CampaignMember objCampaignMem : Trigger.New){
            if(objCampaignMem.ContactId!=NULL){
                S2VRestrictingCampaignMemberClass.updateTimeZoneContact(objCampaignMem);  
            }
            
            if(objCampaignMem.LeadId!=NULL){
                S2VRestrictingCampaignMemberClass.updateTimeZoneLead(objCampaignMem);
            }
        }
    }
    
}