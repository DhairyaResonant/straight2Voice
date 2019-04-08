/*
* CreatedBy: Dhairya Shah
* Date: 11/9/2018  
* Desc: S2VTimeZoneClass method used for this trigger.
*/ 
trigger S2VTimeZoneContact on Contact (before insert, before update, after insert, after update){
    
    s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = [SELECT id,Name,s2vSMSDemo__S2VTimeZoneContact__c FROM s2vSMSDemo__S2V_Trigger_Handler__c WHERE Name = 'TriggerHandler' LIMIT 1];
    system.debug('trgHandler:::::::::'+trgHandler);
    
    if(trgHandler.s2vSMSDemo__S2VTimeZoneContact__c == TRUE){
    
        //POPULATING S2VTIMEZONE BASED ON S2V COUNTRY FIELD
        List<Contact> updateCon =  new List<Contact>();
        List<String> updatedPhone = new List<String>();
        
        //IS BEFORE INSERT
        if(Trigger.isBefore && Trigger.isInsert){
            for(Contact objCon : TRIGGER.New){
                S2VTimeZoneClass.updateTimeZone(objCon);
            }
        }
        
        //IS BEFORE UPDATE
        if(Trigger.isBefore && Trigger.isUpdate){
            for(Contact objCon : TRIGGER.New){
                S2VTimeZoneClass.updateTimeZone(objCon);
            }  
        }
        
        //IS AFTER INSERT
        if(Trigger.isAfter && Trigger.isInsert){
            for(Contact objCon : TRIGGER.New){
                S2VTimeZoneClass.updateAfterTimeZone(objCon);
            }  
        }
        
        //IS AFTER UPDATE
        if(Trigger.isAfter && Trigger.isUpdate){
            for(Contact objCon : TRIGGER.New){
                S2VTimeZoneClass.updateAfterTimeZone(objCon);
            }  
        }
        
    }
    
}