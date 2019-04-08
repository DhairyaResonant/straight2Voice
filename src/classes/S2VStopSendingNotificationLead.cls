/*
* Created By: Dhairya Shah
* Desc: Stop sending sms and voicemail on just a button click on Contact.
* Date: 1st march 2019
*/

public class S2VStopSendingNotificationLead
{
    public Lead objLead {get;set;}
    public id LeadId {get;set;}
    public boolean retValueLead {get;set;}
    public boolean stopSendingVM {get;set;}
    
    //CONSTRUCTOR STARTS***
    public S2VStopSendingNotificationLead(ApexPages.StandardController controller)
    {
        retValueLead = false;
        this.objLead = (Lead)controller.getRecord();
        
        if(objLead.id!=NULL)
        {
            Lead leadObj = [SELECT id,Name,s2vSMSDemo__S2V_Stop_Notifications__c FROM Lead WHERE id=:objLead.id LIMIT 1];
            
            if(leadObj.Id!=NULL)
            {
                LeadId = leadObj.id;   
            }
            
            if(leadObj.s2vSMSDemo__S2V_Stop_Notifications__c!=TRUE)
            {
                stopSendingVM = leadObj.s2vSMSDemo__S2V_Stop_Notifications__c;
            }
        }
        
        system.debug('LeadId::::'+LeadId);
        system.debug('stopSendingVM:::::'+stopSendingVM);
    }
    //CONSTRUCTOR ENDS***
    List<Lead> listToupdateLead = new List<Lead>();
    
    public pageReference stopSendingVM()
    {
        if(stopSendingVM == false && LeadId!=NULL)
        {
            lead updateLead = new lead (Id=LeadId);
            updateLead.s2vSMSDemo__S2V_Stop_Notifications__c = TRUE;
            listToupdateLead.add(updateLead);
        }
        
        if(listToupdateLead!=NULL && listToupdateLead.size()>0)
        {
            update listToupdateLead;
            retValueLead = true;
            return doRedirect();
        }
        
        return null;
    }
    
    public pageReference doRedirect()
    {
        pageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + LeadId);
        system.debug(':::'+pr);
        return pr;
    }
    
}