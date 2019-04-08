trigger SendVoiceMail on S2V_Send_Voicemail__c (after insert) {

    s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = [SELECT id,name,s2vSMSDemo__SendVoiceMail__c  FROM s2vSMSDemo__S2V_Trigger_Handler__c where name = 'TriggerHandler'];
    
    if(trgHandler.s2vSMSDemo__SendVoiceMail__c == true){
            if(Trigger.isAfter && Trigger.isInsert){
            map<Id,String> mapS2VIdToQuery = new Map<Id,String>();
            map<Id,S2V_Send_Voicemail__c> mapS2VIdToS2V = new Map<Id,S2V_Send_Voicemail__c>();
            List<S2V_Send_Voicemail__c> lstNewSendVc = Trigger.New;
            for(S2V_Send_Voicemail__c s2v : lstNewSendVc){
                //if(s2v.Option_Schedule__c != null && s2v.Option_Schedule__c == 'Now'){
                    String tempQuery = 'Select id,' + s2v.Reference_Field__c  + ' from ' + s2v.Object_Name__c + ' where ' + s2v.Reference_Field__c + ' != Null';
                    system.debug(tempQuery);
                    mapS2VIdToQuery.put(s2v.Id,tempQuery);
                    mapS2VIdToS2V.put(s2v.Id,s2v);
                //}
            }
        
            if(mapS2VIdToQuery != null && mapS2VIdToQuery.size() > 0){
                for(String str : mapS2VIdToQuery.keySet()){
                    if(mapS2VIdToS2V != null && mapS2VIdToS2V.size() > 0 && mapS2VIdToS2V.containskey(str)){
                        String tempQuery = mapS2VIdToQuery.get(str);
                        String fldName = mapS2VIdToS2V.get(str).Reference_Field__c;
                        String objName = mapS2VIdToS2V.get(str).Object_Name__c;
                        String voiceName = mapS2VIdToS2V.get(str).Recording_Name__c;
                        String callerId = mapS2VIdToS2V.get(str).Caller_Id__c;
                        Date strtDate = mapS2VIdToS2V.get(str).Start_Date__c;
                        String scdleFreq = mapS2VIdToS2V.get(str).Schedule_Frequency__c;
                        Integer optionSchedule = 0;
                        if(mapS2VIdToS2V.get(str).Option_Schedule__c != null && mapS2VIdToS2V.get(str).Option_Schedule__c == 'Future Call'){
                            optionSchedule = 1;
                        }
                        S2VVoiceMailSendPageController.createCampaign(tempQuery,fldName,objName,voiceName,callerId,optionSchedule,strtDate,scdleFreq);
                        /*if(mapS2VIdToS2V.get(str).S2V__Option_Schedule__c != null && mapS2VIdToS2V.get(str).S2V__Option_Schedule__c == 'Now'){
                            S2VVoiceMailSendPageController.createCampaign(tempQuery,fldName,objName,voiceName,callerId,0,null,null);    
                        }else if(mapS2VIdToS2V.get(str).S2V__Option_Schedule__c != null && mapS2VIdToS2V.get(str).S2V__Option_Schedule__c == 'Future Call'){
                            S2VVoiceMailSendPageController.createCampaign(tempQuery,fldName,objName,voiceName,callerId,1,mapS2VIdToS2V.get(str).S2V__Start_Date__c,mapS2VIdToS2V.get(str).S2V__Schedule_Frequency__c);
                        }*/
                    }
                }
            }
        }
    }
    
}