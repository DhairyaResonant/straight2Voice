/*
 * Created By: Dhairya Shah
 * Desc: Inserting the records in future voicemails tab when records are not in valid timezone
 */
global class S2VFutureVoicemailBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    private String query;
    
    global S2VFutureVoicemailBatch (String soql){
        query = soql;
        System.debug('Query is :::' + soql);
    }
    
    global Database.Querylocator start(Database.BatchableContext bc){
        //System.debug('>>>> start ' + query);      
        return Database.getQuerylocator(query);
    } 
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug('Query size :::::' + scope.size());
        map<string,list<id>> map_SObjectTypeRecordId = new map<string,list<id>>();
        Map<String,Id> mapObjNameToId = new Map<String,Id>();
        for(sObject obj : scope){
            Future_Voicemails__c obj_FV = (Future_Voicemails__c)obj;
            Boolean isValid = S2VTimezonevalidation.isValidForSendVM(obj_FV.Timezone__c);
            system.debug(':::::::::::::::::::'+S2VTimezonevalidation.isValidForSendVM(obj_FV.Timezone__c));
            if(isValid == true){
                mapObjNameToId.put(obj_FV.Sobject_Name__c ,obj_FV.Id);
                list<id> temp_lst = new list<id>();
                if(map_SObjectTypeRecordId.containskey(obj_FV.Sobject_Name__c)){
                    temp_lst = map_SObjectTypeRecordId.get(obj_FV.Sobject_Name__c);
                    temp_lst.add(obj_FV.Record_Id__c);
                    map_SObjectTypeRecordId.put(obj_FV.Sobject_Name__c ,temp_lst);
                }else{
                   temp_lst.add(obj_FV.Record_Id__c);
                   map_SObjectTypeRecordId.put(obj_FV.Sobject_Name__c ,temp_lst); 
                }
                
            }            
        }
       
        List<Future_Voicemails__c> updateFutrLst = new List<Future_Voicemails__c>();
        if(map_SObjectTypeRecordId.size() > 0){
            for(string str : map_SObjectTypeRecordId.keyset()){
                Boolean retValGet = S2VVoiceMailSendPageController.CallFutureMethodBatch(map_SObjectTypeRecordId.get(str) , str);
                System.debug('Return value ::::' + retValGet);
                system.debug('mapObjNameToId:::::'+mapObjNameToId);
                system.debug(' mapObjNameToId.containskey(str)::::'+ mapObjNameToId.containskey(str));
                if(retValGet && mapObjNameToId.containskey(str) && mapObjNameToId.get(str) != null){
                    Future_Voicemails__c fvc = new Future_Voicemails__c(Id=mapObjNameToId.get(str));
                    system.debug('its true::::::');
                    fvc.Status__c = 'Sent';
                    updateFutrLst.add(fvc);
                } else {
                    Future_Voicemails__c fvc = new Future_Voicemails__c(Id=mapObjNameToId.get(str));
                    fvc.Status__c = 'Failed';
                    updateFutrLst.add(fvc);
                }
            }
            if(updateFutrLst != null && updateFutrLst.size() > 0){
                system.debug('updateFutrLst::::::'+updateFutrLst);
                update updateFutrLst;
            }
            
        }
       
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('>>>> finish ' + job.Status);
    }
}