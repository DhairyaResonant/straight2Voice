/*
* Created By: Dhairya Shah
* Desc: Stop sending sms and voicemail on just a button click on Contact.
* Date: 1st march 2019
*/

public class S2VStopSendingNotificationContact
{
    public Contact objContact {get;set;}
    public id ContactId {get;set;}
    public boolean retValueContact {get;set;}
    public boolean stopSendingVM {get;set;}
    
    //CONSTRUCTOR STARTS***
    public S2VStopSendingNotificationContact(ApexPages.StandardController controller)
    {
        retValueContact = false;
        this.objContact = (Contact)controller.getRecord();
        
        if(objContact.id!=NULL)
        {
            Contact contactObj = [SELECT id,Name,s2vSMSDemo__S2V_Stop_Notifications__c FROM Contact WHERE id=:objContact.id LIMIT 1];
            
            if(contactObj.Id!=NULL)
            {
                ContactId = contactObj.id;   
            }
            
            if(contactObj.s2vSMSDemo__S2V_Stop_Notifications__c!=TRUE)
            {
                stopSendingVM = contactObj.s2vSMSDemo__S2V_Stop_Notifications__c;
            }
        }
        
        system.debug('contactid::::'+contactId);
        system.debug('stopSendingVM:::::'+stopSendingVM);
    }
    //CONSTRUCTOR ENDS***
    List<Contact> listToUpdateCon = new List<Contact>();
    
    public pageReference stopSendingVM()
    {
        if(stopSendingVM == false && contactId!=NULL)
        {
            Contact updateCon = new Contact (Id=contactId);
            updateCon.s2vSMSDemo__S2V_Stop_Notifications__c = TRUE;
            listToUpdateCon.add(updateCon);
        }
        
        if(listToUpdateCon!=NULL && listToUpdateCon.size()>0)
        {
            update listToUpdateCon;
            retValueContact = true;
            return doRedirect();
        }
        
        return null;
    }
    
    public pageReference doRedirect()
    {
        pageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + contactId);
        system.debug(':::'+pr);
        return pr;
    }
    
}