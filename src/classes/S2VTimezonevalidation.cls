/*
* Created by: Dhairya Shah
* Date: 25/09/2018
* Desc: Validating timezones of given countries in timezone tab.
*/

public class S2VTimezonevalidation {
    
    //CHECKING TIMEZONE OF RECORDS.
    public static Boolean isValidForSendVM(String timeZoneName){
        Boolean retVal = false;
        system.debug('timeZoneName:::::'+timeZoneName);
        if(timeZoneName != null && timeZoneName.trim() != ''){
            
            DateTime todaysTime = system.now();
            system.debug('todaysTime::::'+todaysTime);
                        
            TimeZone customerTimeZone = TimeZone.getTimeZone(timeZoneName);
            integer offsetToCustomersTimeZone = customerTimeZone.getOffset(todaysTime); //TIMEZONE METHOD
                        
            Datetime currUserTime = todaysTime.addHours(offsetToCustomersTimeZone/ (1000 * 60 *60));
            String dayofWeek = currUserTime.format('EEEE');
            system.debug('dayofWeek:::'+dayofWeek); //PRINT DAY OF WEEK MONDAY OR TUESDAY OR ...
            
            List<S2V_Time_Zones__c> lstTimeZone = [Select Id,Start_Time__c,Stop_Time__c from S2V_Time_Zones__c where Name != null AND Name =: timeZoneName];
            
            if(dayOfWeek!='Saturday' && dayOfWeek!='Sunday'){
                if(lstTimeZone != null && lstTimeZone.size() > 0 && lstTimeZone[0].Start_Time__c != null && lstTimeZone[0].Stop_Time__c != null){
                    system.debug('lstTimeZone[0].Start_Time__c::::'+lstTimeZone[0].Start_Time__c);
                    system.debug('lstTimeZone[0].Stop_Time__c:::::'+lstTimeZone[0].Stop_Time__c);
                    system.debug('currUserTime.timeGmt():::'+currUserTime.timeGmt());
                    if(lstTimeZone[0].Start_Time__c <= currUserTime.timeGmt() && lstTimeZone[0].Stop_Time__c >= currUserTime.timeGmt()){
                        retVal = true;
                    }
                }
            }
            
        }
        system.debug('retVal:::'+retVal);
        return retVal;
    }
    
    //INSERTING RECORDS IN FUTURE VM TAB
    public static void insertQueueRecords(String objName,String objId, String fieldType, String fieldName, String Country){
        Boolean isValidRcrd = false;
        List<S2V_Send_Voicemail__c> lstSndVcmail = [Select Id,Query__c from S2V_Send_Voicemail__c where Object_Name__c != null AND Object_Name__c =: objName AND Is_Active__c = TRUE limit 100];
        system.debug([Select Id,Query__c from S2V_Send_Voicemail__c where Object_Name__c != null AND Object_Name__c =: objName AND Is_Active__c = TRUE limit 100]);
        system.debug('lstSndVcmail::::'+lstSndVcmail.size());
        if(lstSndVcmail != null && lstSndVcmail.size() > 0 && lstSndVcmail.size() < 100){
            for(S2V_Send_Voicemail__c svc : lstSndVcmail){
                if(svc.Query__c != null){
                    String lstQuery = svc.Query__c.substring(svc.Query__c.indexOf('[')+1);
                    String newquery1 = lstQuery.replace(']','');
                    String newquery = newquery1.replace(';','');
                    
                    String tempQuery = newquery;
                    if(tempQuery.contains('WHERE')){
                        tempQuery += ' and id= \'' + objId + '\'';
                    }else{
                        tempQuery += ' where id= \'' + objId + '\'';
                    }
                    System.debug(tempQuery);
                    List<sObject> sobjList = Database.query(tempQuery);
                    if(sobjList != null && sobjList.size() > 0){
                        isValidRcrd = true;
                        break;
                    }
                }
            }
        }
        if(isValidRcrd){
            List<Future_Voicemails__c> lstFtrVcMail = [Select Id,Record_Id__c from Future_Voicemails__c where Record_Id__c != null AND Record_Id__c=:objId];
            if(lstFtrVcMail == null || lstFtrVcMail.size() == 0){
                String senderId = '';
                String query = 'Select Id ';
                if(fieldType != null && fieldType != 'null' && fieldName != null && fieldName != 'null'){
                    query += ',' + fieldName + ' ';
                }
                system.debug('fieldname:::'+fieldName);
                system.debug('fieldtype:::'+fieldType);
                system.debug('country":::::'+country);
                query += 'from ' + objName + ' where Id=\'' + objId + '\'';
                system.debug('query:::::'+query);
                List<SObject> lstObjects = Database.query(query);
                if(lstObjects != null && lstObjects.size() > 0 && objName != 'Contact' && objName != 'Lead'){
                    if(lstObjects[0] != null && lstObjects[0].get(fieldName) != null){
                        senderId = (String)lstObjects[0].get(fieldName);
                    }
                }
                
                Future_Voicemails__c fvObj = new Future_Voicemails__c();
                fvObj.Record_Id__c = objId;
                fvObj.Sobject_Name__c = objName;
                fvObj.Status__c = 'Queue';
                fvObj.Timezone__c = Country;
                if(objName != 'Contact' && objName != 'Lead'){
                    if(fieldType != null && fieldType != 'null' && fieldType == 'Contact' && senderId != ''){
                        fvObj.ContactId__c = senderId;
                    }else if(fieldType != null && fieldType != 'null' && fieldType == 'Lead' && senderId != ''){
                        fvObj.LeadId__c = senderId;
                    }
                }else if(objName == 'Contact'){
                    fvObj.ContactId__c = objId;
                }else if(objName == 'Lead'){
                    fvObj.LeadId__c = objId;
                }
                insert fvObj;
            }
            
        }
        
    }
    
    public static boolean isItBatchContact(String selectedObject, Sobject obj){
        Boolean isNotBatchRecord = true;
        Contact newCon = new Contact();
        if(selectedObject == 'Contact'){
            newCon = (Contact)obj;
        }
        if(selectedObject == 'Contact' && newCon.S2V_Batch_Record__c == true){
            system.debug('in if conditon');
            isNotBatchRecord = false;
        }
        
        return isNotBatchRecord;
    }
    
}