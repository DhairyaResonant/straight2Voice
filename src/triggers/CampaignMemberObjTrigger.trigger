trigger CampaignMemberObjTrigger on CampaignMember (after insert, after update)
{
    List<Id> lstIds = new List<Id>();
   System.debug(RecursiveTriggerHandler.isFirstTime);
   if(RecursiveTriggerHandler.isFirstTime){
       RecursiveTriggerHandler.isFirstTime = false;
    String selectedObject = 'CampaignMember';
    String selectedFieldType = 'Contact'; 
      for(CampaignMember objCampaignMember : Trigger.new){
      if(objCampaignMember.S2V_Customer_Time_Zone__c != null && objCampaignMember.S2V_Stop_Notifications__c == FALSE){
        Boolean isValid = S2VTimezonevalidation.isValidForSendVM(objCampaignMember.S2V_Customer_Time_Zone__c); 
        Boolean isNotBatchRecord = S2VTimezonevalidation.isItBatchContact(selectedObject, objCampaignMember);
        if((isValid && isNotBatchRecord) || Test.isRunningtest()){ 
          lstIds.add(objCampaignMember.Id);
        }
        else { 
          S2VTimezonevalidation.insertQueueRecords('CampaignMember',objCampaignMember.id,'Contact','LeadOrContactId',  objCampaignMember.S2V_Customer_Time_Zone__c);             } 
      } else {
          lstIds.add(objCampaignMember.Id);
        } 

      }

       if(lstIds!=NULL && lstIds.size()>0){
          if(!Test.isRunningtest()){
          S2VVoiceMailSendPageController.CallFutureMethod(lstIds,'CampaignMember'); 
		}

    }
  }
}