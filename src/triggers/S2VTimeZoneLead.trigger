/*
* CreatedBy: Dhairya Shah
* Date: 11/9/2018  
* Desc: S2VTimeZoneClass method used for this trigger.
*/ 
trigger S2VTimeZoneLead on Lead(before insert, before update, after insert, after update){
    
    s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = [SELECT id,Name,s2vSMSDemo__S2VTimeZoneLead__c  FROM s2vSMSDemo__S2V_Trigger_Handler__c where name = 'TriggerHandler'];
    
    if(trgHandler.s2vSMSDemo__S2VTimeZoneLead__c == true){
        //POPULATING S2VTIMEZONE BASED ON S2V COUNTRY FIELD
        List<Lead> updateCon =  new List<Lead>();
        List<String> updatedPhone = new List<String>();
        
        //IS BEFORE INSERT
        if(Trigger.isBefore && Trigger.isInsert){
            for(Lead objLead: TRIGGER.New){
                S2VTimeZoneClass.updateTimeZone(objLead);
            }
        }
        
        //IS BEFORE UPDATE
        if(Trigger.isBefore && Trigger.isUpdate){
            for(Lead objLead: TRIGGER.New){
                S2VTimeZoneClass.updateTimeZone(objLead);
            }  
        }
        
        //IS AFTER INSERT
        if(Trigger.isAfter && Trigger.isInsert){
            for(Lead objLead: TRIGGER.New){
                S2VTimeZoneClass.updateAfterTimeZoneLead(objLead);
            }  
        }
        
        //IS AFTER UPDATE
        if(Trigger.isAfter && Trigger.isUpdate){
            for(Lead objLead: TRIGGER.New){
                S2VTimeZoneClass.updateAfterTimeZoneLead(objLead);
            }  
        }
    }
    
}