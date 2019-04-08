/*
 * Created By: Dhairya Shah
 * Desc: pull the data from Contact or lead.
 */
trigger S2VTimeZoneTask on Task (before insert, before update) {

    s2vSMSDemo__S2V_Trigger_Handler__c trghandler = [SELECT id,Name,s2vSMSDemo__S2VTimeZoneTask__c FROM s2vSMSDemo__S2V_Trigger_Handler__c where name = 'TriggerHandler'];
    
    if(trghandler.s2vSMSDemo__S2VTimeZoneTask__c == true){
            // Goal: Pull any fields to display on task from the related contact or lead
        
        // If related to an Opportunity, query to find out the Opportunity number
        
        // Create collection of tasks that are related to an opp (where the opp is listed only once)
        Set<Id> myIds = new Set<Id>();
        for(Task t : trigger.new){
            String wId = t.WhoId;
            if(wId!=null && (wId.startsWith('003') || wId.startsWith('00Q'))  && !myIds.contains(t.WhoId)){
                myIds.add(t.WhoId);
            }
        }
        
        // Pull in lead ids and related field to populate task record
       
        List<Lead> taskLead = [Select Id, Name, Email, Company,Customer_time_zone__c from Lead where Id in :myIds];
        Map<Id, Lead> opMap = new Map<Id, Lead>();
        for(Lead l : taskLead){
            opMap.put(l.Id,l);
        }
        // Pull in contact ids and related field to populate task record
      
        List<Contact> taskContact = [Select Id, Name, Email,Country__c from Contact where Id in :myIds];
        Map<Id, Contact> conMap = new Map<Id, Contact>();
        for(Contact c : taskContact){
            conMap.put(c.Id,c);
         }
        
        // Update custom task field with custom lead field
        for(Task t : trigger.new){
            String wId = t.WhoId;
            if(wId!=null && wId.startswith('00Q')){
                Lead thisLead = opMap.get(t.WhoId);
                if(thisLead!=null){
                t.Description = thisLead.Name;
                t.S2V_Customer_Time_zone__c = thisLead.Customer_time_zone__c;
                } 
             }   
            else if (wId!=null && wId.startswith('003')){
                Contact thisContact = conMap.get(t.WhoId);
                if(thisContact !=null){
                t.Description = thisContact.Name;
                t.S2V_Customer_Time_zone__c = thisContact.Country__c;
                }
                
            }
        }
    }
    
}