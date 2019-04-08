/*
* Created By: Dhairya Shah
* Desc: Creating dynamic query to execute records in future voicemails tab.
*/ 
public class S2VFutureVoicemail implements S2VFutureVoicemailBase.IS2VFutureVoicemailBase{
    
    public void Execute(SchedulableContext sc){
        
        String soql = 'SELECT Id, Record_Id__c, Sobject_Name__c,Status__c,Timezone__c ';
        soql += 'FROM Future_Voicemails__c ';
        soql += 'WHERE (Status__c = '+ '\''+ CommonConstant.status + '\' AND Record_Id__c != NULL) ';
        
        
        S2VFutureVoicemailBatch batch = new S2VFutureVoicemailBatch(soql);
        List<AsyncApexJob> listAsyncApex = [SELECT Id,Apexclass.name,Status FROM AsyncApexJob Where Status ='Processing' AND Apexclass.name = 'S2VFutureVoicemailBatch'];
        if(listAsyncApex!=Null && listAsyncApex.size() == 0){
            Database.executebatch(batch, 1);   
        }
        
    }
    
}