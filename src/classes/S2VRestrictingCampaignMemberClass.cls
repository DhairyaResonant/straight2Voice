/*
* Desc: Restricting to add campaign members if campaign country is not same to campaign members country
*/
public class S2VRestrictingCampaignMemberClass {
    
    //BEFORE INSERT BEFORE UPDATE CAMPAIGN MEMBER FOR CONTACTS
    public static void updateTimeZoneContact(CampaignMember objCampaignMem){
        
        s2vSMSDemo__CountryCode__c customSetting = [SELECT id,Name,s2vSMSDemo__Active__c FROM s2vSMSDemo__CountryCode__c WHERE s2vSMSDemo__Active__c = TRUE];
        List<Contact> listOfContact = [SELECT id,Name,Country__c FROM Contact WHERE Country__c!=NULL AND ID=: objCampaignMem.ContactId];
        Map<String,String> mapOfContact = new Map<String,String>();
        
        //FOR LOOP STARTS
        for(Contact objContacts : listOfContact){
            if(objContacts.Country__c!=null && objContacts.Country__c!='')
                mapOfContact.put(objContacts.id, objContacts.Country__c);
        }
        
        //CONDITION  ONLY FOR AUSTRALIA CUSTOMERS ON CONTACTS
        if(customSetting.name== 'AU' && customSetting.active__C == TRUE){
            system.debug('AU is active');
            if(objCampaignMem.ContactId!=NULL){
                if(mapOfContact!=NULL && mapOfContact.containsKey(objCampaignMem.ContactId) && mapOfContact.get(objCampaignMem.ContactId)!=null && mapOfContact.get(objCampaignMem.ContactId)!=''){
                    system.debug('mapOfContact.get(objCampaignMem.ContactId)::::'+mapOfContact.get(objCampaignMem.ContactId));
                    Boolean countryFlag = false;
                    if(mapOfContact.get(objCampaignMem.ContactId) == 'Australia/Canberra'){ 
                        system.debug('in 1st');
                        countryFlag = true;
                    } else if(mapOfContact.get(objCampaignMem.ContactId)== 'Australia/North'){
                        system.debug('in 2nd');
                        countryFlag = true;
                    } else if(mapOfContact.get(objCampaignMem.ContactId)== 'Australia/NSW'){
                        system.debug('in 3rd');
                        countryFlag = true;
                    } 
                    
                    if(countryFlag == false){
                        //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                    }
                    else{
                        objCampaignMem.S2V_Customer_Time_Zone__c = mapOfContact.get(objCampaignMem.ContactId);
                        if(S2VTimezonevalidation.isValidForSendVM(mapOfContact.get(objCampaignMem.ContactId))){
                            objCampaignMem.S2V_Trigger_Status__c = 'Sent';
                        }else{
                            objCampaignMem.S2V_Trigger_Status__c = 'Queue';
                        }
                        system.debug('success');
                    }
                } else {
                    //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                }  
            }
            
        }
        
        //CONDITION  ONLY FOR AMERICA AND CANADA CUSTOMERS
        if(customSetting.name == 'CA-US' && customSetting.s2vSMSDemo__Active__c == TRUE){
            system.debug('US is active');
            if(objCampaignMem.ContactId!=NULL){
                if(mapOfContact!=NULL && mapOfContact.containsKey(objCampaignMem.ContactId) && mapOfContact.get(objCampaignMem.ContactId)!=null && mapOfContact.get(objCampaignMem.ContactId)!=''){
                    Boolean countryFlag = false;
                    if(mapOfContact.get(objCampaignMem.ContactId)== 'America/Anchorage'){
                        countryFlag = true;
                    } else if(mapOfContact.get(objCampaignMem.ContactId)== 'America/Chicago'){
                        countryFlag = true;
                    } 
                    
                    if(countryFlag == false){
                        //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                    } else {
                        objCampaignMem.S2V_Customer_Time_Zone__c = mapOfContact.get(objCampaignMem.ContactId);
                        if(S2VTimezonevalidation.isValidForSendVM(mapOfContact.get(objCampaignMem.ContactId))){
                            objCampaignMem.S2V_Trigger_Status__c = 'Sent';
                        }else{
                            objCampaignMem.S2V_Trigger_Status__c = 'Queue';
                        }
                        system.debug('success');
                    }
                }
                else{
                    //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                }
            }
        }
        
        //CUSTOMERS FOR NZ
        if(customSetting.Name == 'NZ' && customSetting.s2vSMSDemo__Active__c == TRUE){
            system.debug('in custom setting NZ');
            if(objCampaignMem.ContactId!=NULL){
                if(mapOfContact!=NULL && mapOfContact.containsKey(objCampaignMem.ContactId) && mapOfContact.get(objCampaignMem.ContactId)!=null && mapOfContact.get(objCampaignMem.ContactId)!=''){
                    Boolean countryFlag = false;
                    if(mapOfContact.get(objCampaignMem.ContactId)=='Pacific/Auckland'){
                        countryFlag = true;
                    } /*else if(mapOfContact.get(objCampaignMem.ContactId)=='Pacific/Chatham'){
                        countryFlag = true;
                    }*/
                    
                    if(countryFlag == false){
                        //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                    } else {
                        objCampaignMem.S2V_Customer_Time_Zone__c = mapOfContact.get(objCampaignMem.ContactId);
                        if(S2VTimezonevalidation.isValidForSendVM(mapOfContact.get(objCampaignMem.ContactId))){
                            objCampaignMem.S2V_Trigger_Status__c = 'Sent';
                        }else{
                            objCampaignMem.S2V_Trigger_Status__c = 'Queue';
                        }
                        system.debug('success:');
                    }
                } else {
                    //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                }
            }
            
        }  
    }
    
    //BEFORE INSERT BEFORE UPDATE CAMPAIGN MEMBER FOR LEADS
    public static void updateTimeZoneLead(CampaignMember objCampaignMem){
        
        s2vSMSDemo__CountryCode__c customSetting = [SELECT id,Name,s2vSMSDemo__Active__c FROM s2vSMSDemo__CountryCode__c WHERE s2vSMSDemo__Active__c = TRUE];
        List<Lead> listOfLeads = [SELECT id,Name,Customer_time_zone__c FROM Lead WHERE Customer_time_zone__c!=NULL and Id=:objCampaignMem.LeadId];
        
        Map<String,String> mapOfLead = new Map<String,String>();
        
        //FOR LOOP STARTS
        for(Lead objLeads : listOfLeads){
            if(objLeads.Customer_time_zone__c!=null && objLeads.Customer_time_zone__c!='')
                mapOfLead.put(objLeads.id, objLeads.Customer_time_zone__c);
        }
        
        //CONDITION  ONLY FOR AUSTRALIA CUSTOMERS ON CONTACTS
        if(customSetting.name== 'AU' && customSetting.s2vSMSDemo__active__c == TRUE){
            system.debug('AU is active');
            if(objCampaignMem.LeadId!=NULL){
                if(mapOfLead!=NULL && mapOfLead.containsKey(objCampaignMem.LeadId) && mapOfLead.get(objCampaignMem.LeadId)!=null && mapOfLead.get(objCampaignMem.LeadId)!=''){
                    Boolean countryFlag = false;
                    if(mapOfLead.get(objCampaignMem.LeadId) == 'Australia/Canberra'){ 
                        system.debug('in 1st');
                        countryFlag = true;
                    } else if(mapOfLead.get(objCampaignMem.LeadId)== 'Australia/North'){
                        system.debug('in 2nd');
                        countryFlag = true;
                    } else if(mapOfLead.get(objCampaignMem.LeadId)== 'Australia/NSW'){
                        system.debug('in 3rd');
                        countryFlag = true;
                    } 
                    
                    if(countryFlag == false){
                        //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                    }
                    else{
                        objCampaignMem.S2V_Customer_Time_Zone__c = mapOfLead.get(objCampaignMem.LeadId);
                        if(S2VTimezonevalidation.isValidForSendVM(mapOfLead.get(objCampaignMem.LeadId))){
                            objCampaignMem.S2V_Trigger_Status__c = 'Sent';
                        }else{
                            objCampaignMem.S2V_Trigger_Status__c = 'Queue';
                        }
                        system.debug('success');
                    }
                } else {
                    //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                }  
            }
            
        }
        
        //CONDITION  ONLY FOR AMERICA AND CANADA CUSTOMERS
        if(customSetting.name == 'CA-US' && customSetting.s2vSMSDemo__Active__c == TRUE){
            system.debug('US is active');
            if(objCampaignMem.LeadId!=NULL){
                if(mapOfLead!=NULL && mapOfLead.containsKey(objCampaignMem.LeadId) && mapOfLead.get(objCampaignMem.LeadId)!=null && mapOfLead.get(objCampaignMem.LeadId)!=''){
                    Boolean countryFlag = false;
                    if(mapOfLead.get(objCampaignMem.LeadId)== 'America/Anchorage'){
                        countryFlag = true;
                    } else if(mapOfLead.get(objCampaignMem.LeadId)== 'America/Chicago'){
                        countryFlag = true;
                    } 
                    if(countryFlag == false){
                        //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                    } else {
                        objCampaignMem.S2V_Customer_Time_Zone__c = mapOfLead.get(objCampaignMem.LeadId);
                        if(S2VTimezonevalidation.isValidForSendVM(mapOfLead.get(objCampaignMem.LeadId))){
                            objCampaignMem.S2V_Trigger_Status__c = 'Sent';
                        }else{
                            objCampaignMem.S2V_Trigger_Status__c = 'Queue';
                        }
                        system.debug('success');
                    }
                }
                else{
                    //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                }
            }
        }
        
        //CUSTOMERS FOR NZ
        if(customSetting.Name == 'NZ' && customSetting.s2vSMSDemo__Active__c == TRUE){
            system.debug('in custom setting NZ');
            if(objCampaignMem.LeadId!=NULL){
                if(mapOfLead!=NULL && mapOfLead.containsKey(objCampaignMem.LeadId) && mapOfLead.get(objCampaignMem.LeadId)!=null && mapOfLead.get(objCampaignMem.LeadId)!=''){
                    Boolean countryFlag = false;
                    if(mapOfLead.get(objCampaignMem.LeadId)=='Pacific/Auckland'){
                        countryFlag = true;
                    } /*else if(mapOfLead.get(objCampaignMem.LeadId)=='Pacific/Chatham'){
                        countryFlag = true;
                    }*/
                    
                    if(countryFlag == false){
                        //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                    } else {
                        objCampaignMem.S2V_Customer_Time_Zone__c = mapOfLead.get(objCampaignMem.LeadId);
                        if(S2VTimezonevalidation.isValidForSendVM(mapOfLead.get(objCampaignMem.LeadId))){
                            objCampaignMem.S2V_Trigger_Status__c = 'Sent';
                        }else{
                            objCampaignMem.S2V_Trigger_Status__c = 'Queue';
                        }
                        system.debug('success:');
                    }
                } else {
                    //objCampaignMem.addError('Error: There might be some customers which does not belong to this country code');
                }
            }
            
        }  
    }
}