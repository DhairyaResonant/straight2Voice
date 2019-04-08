//RESTRIC USER TO USE SAME RECORDING NUMBER IN THE OBJECT 
//CREATED BY DHRUDEEP
trigger SameRecordNumber on Recording__c (before insert) {

    s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = [SELECT id,Name,s2vSMSDemo__SameRecordNumber__c  FROM s2vSMSDemo__S2V_Trigger_Handler__c where Name = 'TriggerHandler'];
    
    if(trgHandler.s2vSMSDemo__SameRecordNumber__c == true){
    
        //STORING RECORDING NUMBER OF NEWLY INSERTED DESCRIPTION
        List<Decimal> mps = new List<Decimal>();
        if(Trigger.isInsert && Trigger.isBefore){
            for(Recording__c rcd : Trigger.new){
                mps.add(rcd.Recording_Number__c);
            }
        
            //CHECKING WHETHER SAME NUMBER IS FOUND OR NOT IN EXISTING RECORDS
            List<Recording__c> rcding = [select Id,Recording_Number__c from Recording__c 
                                        where Recording_Number__c In : mps];
            
            String errorMsg='You can not use same recording number';
            
            //IF SAME RECORDING NUMBER IS FOUND IN ABOVE LIST THEN SHOWING ERROR ON STANDARD PAGE
            if(rcding != Null && rcding.size()>0){
                for(Recording__c rcd : Trigger.new){
                    rcd.addError(errorMsg);
                } 
            }
        
        }
    }
    
}