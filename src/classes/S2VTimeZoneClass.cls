/*
* Date: 11/9/2018  
* Desc: Populating the time zone for non s2vm customers and used this class in S2VTimeZoneLead trigger
*/
public class S2VTimeZoneClass {
    
    //*****************************CONTACT METHOD STARTS HERE *************************
    //BEFORE INSERT UPDATE METHOD STARTS
    public static void updateTimeZone(Contact objCon)
    {
        if(objCon.MobilePhone!=NULL && objCon.MailingCountry!=NULL && objCon.MailingCity!=NULL)
        {
            //CUSTOM SETTING FOR TIMEZONE***
            s2vSMSDemo__TimeZones__c objCTZCity = s2vSMSDemo__TimeZones__c.getValues(objCon.MailingCity);
            if(objCTZCity!=NULL)
            {
                objCon.s2vSMSDemo__Country__c = objCTZCity.s2vSMSDemo__Time_zone__c;
                system.debug('in citys');
            }
            
            if(objCTZCity == NULL)
            {
                s2vSMSDemo__TimeZones__c objCTZCountry = s2vSMSDemo__TimeZones__c.getValues(objCon.MailingCountry);
                if(objCTZCountry!=NULL)
                {
                    objCon.s2vSMSDemo__Country__c = objCTZCity.s2vSMSDemo__Time_zone__c;
                    system.debug('in country');
                }
            }
        }
        
        //S2V COUNTRY
        if(objCon.Country__c!=NULL)
        {
            Timezone tz = Timezone.getTimeZone(objCon.Country__c);
            objCon.S2VTimeZone__c = tz.getDisplayName();
        }
    }
    //BEFORE INSERT UPDATE METHOD ENDS
    
    //AFTER INSERT UPDATE METHOD ON CONTACT STARTS
    //INSERT THE NEW TIMEZONE FROM CONTACT TO THE CUSTOM OBJECT CALLED S2V_TIME_ZONE__C.
    public static void updateAfterTimeZone(Contact objCon)
    {
        if(objCon.s2vSMSDemo__Country__c!=NULL)
        {
            List<S2V_Time_Zones__c> listOfTimeZone = [SELECT id,Name FROM S2V_Time_Zones__c WHERE Name =:objCon.s2vSMSDemo__Country__c];
            
            List<S2V_Time_Zones__c> listTZ = new List<S2V_Time_Zones__c>();
            
            Map<String,S2V_Time_Zones__c>countryCodes = new Map<String,S2V_Time_Zones__c>();
            
            if(listOfTimeZone!=NULL && listOfTimeZone.size()>0)
            {
                for(S2V_Time_Zones__c objS2VTimeZone : listOfTimeZone)
                {
                    countryCodes.put(objS2VTimeZone.Name,objS2VTimeZone);
                }            
            }
            
            if(countryCodes!=NULL && !countryCodes.containskey(objCon.Country__c) && objCon.Country__c !=NULL)
            {
                S2V_Time_Zones__c objTZ = new S2V_Time_Zones__c();
                objTZ.Name = objCon.Country__c;
                objTZ.Start_Time__c = Time.newInstance(09, 00, 2, 20);
                objTZ.Stop_Time__c =  Time.newInstance(17, 00, 2, 20);
                listTZ.add(objTZ);
            }
            
            if(listTZ!=NULL && listTZ.size()>0)
            {
                system.debug('listTZ.size()::::'+listTZ.size());
                insert listTZ;
            }
        }
    }
    //AFTER INSERT UPDATE METHOD ON CONTACT ENDS
    //********************* CONTACT METHOD ENDS HERE *********************
    
    //********************* LEAD METHOD STARTS HERE **********************
    public static void updateTimeZone(Lead objlead)
    {
        if(objlead.MobilePhone!=NULL && objLead.City!=NULL && objLead.Country!=NULL)
        {
            //CUSTOM SETTING FOR TIMEZONE***
            s2vSMSDemo__TimeZones__c objCTZCity = s2vSMSDemo__TimeZones__c.getValues(objLead.City);
            if(objCTZCity!=NULL)
            {
                objlead.Customer_time_zone__c = objCTZCity.s2vSMSDemo__Time_zone__c;
                system.debug('in citys');
            }
            
            if(objCTZCity == NULL)
            {
                s2vSMSDemo__TimeZones__c objCTZCountry = s2vSMSDemo__TimeZones__c.getValues(objLead.Country);
                if(objCTZCountry!=NULL)
                {
                    objlead.Customer_time_zone__c = objCTZCity.s2vSMSDemo__Time_zone__c;
                    system.debug('in country');
                }
            }
        }
        
        //S2V COUNTRY
        if(objlead.Customer_time_zone__c!=NULL)
        {
            Timezone tz = Timezone.getTimeZone(objlead.Customer_time_zone__c);
            objlead.Time_Zone__c = tz.getDisplayName();
        }  
    }
    
    //AFTER INSERT UPDATE METHOD ON LEAD
    public static void updateAfterTimeZoneLead(Lead objLead)
    {
        if(objlead.Time_Zone__c!=NULL){
            List<S2V_Time_Zones__c> listOfTimeZone = [SELECT id,Name FROM S2V_Time_Zones__c WHERE Name =:objlead.Time_Zone__c];
            List<S2V_Time_Zones__c> listTZ = new List<S2V_Time_Zones__c>();
            
            Map<String,S2V_Time_Zones__c>countryCodes = new Map<String,S2V_Time_Zones__c>();
            
            if(listOfTimeZone!=NULL && listOfTimeZone.size()>0)
            {
                for(S2V_Time_Zones__c objS2VTimeZone : listOfTimeZone)
                {
                    countryCodes.put(objS2VTimeZone.Name,objS2VTimeZone);
                }   
            }
            
            if(countryCodes!=NULL && !countryCodes.containskey(objLead.Customer_time_zone__c) && objLead.Customer_time_zone__c!=NULL)
            {
                S2V_Time_Zones__c objTZ = new S2V_Time_Zones__c();
                objTZ.Name = objLead.Customer_time_zone__c;
                objTZ.Start_Time__c = Time.newInstance(09, 00, 2, 20);
                objTZ.Stop_Time__c =  Time.newInstance(17, 00, 2, 20);
                listTZ.add(objTZ);
            }
            
            if(listTZ!=NULL && listTZ.size()>0)
            {
                system.debug('listTZ.size()::::'+listTZ.size());
                insert listTZ;
            }
        }
        
    }
    
    //********************* LEAD METHOD ENDS HERE **********************
    
}