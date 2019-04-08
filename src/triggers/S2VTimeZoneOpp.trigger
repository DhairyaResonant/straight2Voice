/*
 * Created By: Dhairya Shah
 * Desc: pull the data from Contact.
 */
trigger S2VTimeZoneOpp on Opportunity (before insert, before update) {
    
    s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = [SELECT id,name,s2vSMSDemo__S2VTimeZoneOpp__c  FROM s2vSMSDemo__S2V_Trigger_Handler__c where Name = 'TriggerHandler'];
    
    if(trgHandler.s2vSMSDemo__S2VTimeZoneOpp__c == true){
        
        // Goal: Pull any fields to display on task from the related contact or lead
        
        // If related to an Opportunity, query to find out the Opportunity number
        
        // Create collection of tasks that are related to an opp (where the opp is listed only once)
        List<Id> Rids = new List<Id>();
        List<Id> Pids = new List<Id>();
        List<Id> Wids = new List<Id>();
        
        
        for(Opportunity opp : trigger.new){
            String Rid = opp.Referred_By__c;
            String Pid = opp.Primary_Contact__c;
            String Wid = opp.Witness_Signatory__c;
            if(RId!=null){
                Rids.add(Rid);
            }
            
            if(Pid!=null){
                Pids.add(Pid);
            }
            
            if(Wid!=null){
                Wids.add(Wid);
            }
        }
        
        List<Contact> listOfContacts = [SELECT id,Name,Country__c FROM Contact WHERE Id in: Rids OR Id in: Pids OR Id in: Wids];
        Map<Id,Contact> mapOfContact = new Map<Id,Contact>();
        for(Contact objCons : listOfContacts){
            mapOfContact.put(objCons.id,objCons);
        }
        
        for(Opportunity objOpportunity : Trigger.NEW){
            if(mapOfContact!=NULL && mapOfContact.containsKey(objOpportunity.Referred_By__c) && objOpportunity.Referred_By__c!=NULL){
                Contact thisContact = mapOfContact.get(objOpportunity.Referred_By__c);
                objOpportunity.S2V_Customer_Time_zone__c = thisContact.Country__c;
            }
            
            if(mapOfContact!=NULL && mapOfContact.containsKey(objOpportunity.Primary_Contact__c) && objOpportunity.Primary_Contact__c!=NULL){
                Contact thisContact = mapOfContact.get(objOpportunity.Primary_Contact__c);
                system.debug('thisContact.Country__c;::::'+thisContact.Country__c);
                objOpportunity.S2V_Customer_Time_zone__c = thisContact.Country__c;
            }
            
            if(mapOfContact!=NULL && mapOfContact.containsKey(objOpportunity.Witness_Signatory__c) && objOpportunity.Witness_Signatory__c!=NUll){
                Contact thisContact = mapOfContact.get(objOpportunity.Witness_Signatory__c);
                objOpportunity.S2V_Customer_Time_zone__c = thisContact.Country__c;
            }
            
            if(objOpportunity.Primary_Contact__c!=NULL && objOpportunity.Referred_By__c!=NULL && objOpportunity.Witness_Signatory__c!=NULL){
                Contact thisContact = mapOfContact.get(objOpportunity.Primary_Contact__c);
                objOpportunity.S2V_Customer_Time_zone__c = thisContact.Country__c;
            }
            
        }
    }
    
}