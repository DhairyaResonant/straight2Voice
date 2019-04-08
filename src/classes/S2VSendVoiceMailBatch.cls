global with sharing class S2VSendVoiceMailBatch implements Database.Batchable<SObject>  {
    private String finalQuery;
    private String voiceMailFile;
    private String fieldName;
    global S2VSendVoiceMailBatch(String finalQuery, String voiceMailFile, String fieldName){
        this.finalQuery = finalQuery;
        this.voiceMailFile = voiceMailFile;
        this.fieldName = fieldName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)  {
        return Database.getQueryLocator(finalQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope)  {
        System.debug(scope);
        List<String> lstCntIds = new List<String>();
         for(sObject obj : scope){
            System.debug(obj.get(fieldName));
             lstCntIds.add((String)obj.get(fieldName));
         }
        if(lstCntIds != null && lstCntIds.size() > 0){
            List<Contact> lstCnts = [Select Id, Email, Phone, MobilePhone From Contact where Id in: lstCntIds];
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    
    }
    
}