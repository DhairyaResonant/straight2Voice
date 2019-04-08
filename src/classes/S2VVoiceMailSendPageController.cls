/*
* CREATED BY: DHAIRYA SHAH
* DATE: 20/09/2018
* DESC: CLASS WHERE VOICEMAIL REQUEST IS SENT AND RESPONSE IS RECIEVED
*/ 

Global class S2VVoiceMailSendPageController 
{    
    public String selectedObject {get;set;} //SELECTED OBJECT FROM OBJECT'S DROPDOWN
    public String selectedField {get;set;} //SELECTED FIELD FROM OBJECT'S DROPDOWN
    public String selectedRecordingName {get;set;} // SELECTED RECORDING NUMBER 4A
    public Date selectedDate {get;set;} // SELECTED DATE FOR FUTURE CALL
    public String selectedOptionschedule{get;set;} //SCHEDULING TYPE NOW OR FUTURE CALL
    public String selectedFreq {get;set;} // FREQUENCY OF FUTURE CALL
    public boolean enabletime {get;set;} // BOOLEAN TO SHOW FREQUENCY, TIME AND TIME FOR FUTURE CALL
    public Integer numberOfDays;
    List<SelectOption> options {get;set;}
    List<SelectOption> optionSchedule{get;set;}
    public List<SelectOption> lstObjNames {get;set;} // LIST OF OBJECTS
    public List<SelectOption> lstObjFields {get;set;} // LIST OF FIELD RELATED TO SELECTED OBJECT
    public map<String,String> mapObjAPINameToLable {get;set;} 
    private map<String,String> mapFieldAPINameToLable;
    private String tempS2VId; 
    public Boolean isEditMode {get;set;}
    public Boolean isBooleanField {get;set;}
    //NEW FIELDS NEED TO BE SHOWN START HERE
    
    public String fieldsneed{get;set;} 
    public String userfields{get;set;}
    public String recOperators{get;set;}
    public String diffUsers{get;set;}
    // END HERE
    
    //DATE SECTION
    public String onceFinalDate;
    public String EveryFinalDate;
    public String WeeklyFinalDate;
    public String MontlhyFinalDate;
    public String YearlyFinalDate;
    
    //FILTER VALUES FOR FIELD NAMES
    public String filterValue1{get;set;}
    public String filterValue2{get;set;}
    public String filterValue3{get;set;}
    public String filterValue4{get;set;}
    public String filterValue5{get;set;}
    public String filterValue6{get;set;}
    
    //FILTER VALUES FOR OPERATORS
    public String filterop1{get;set;}
    public String filterop2{get;set;}
    public String filterop3{get;set;}
    public String filterop4{get;set;}
    public String filterop5{get;set;}
    public String filterop6{get;set;}
    
    //FILTER VALUES FOR TEXT FIELD
    public String filtertext1{get;set;}
    public String filtertext2{get;set;}
    public String filtertext3{get;set;}
    public String filtertext4{get;set;}
    public String filtertext5{get;set;}
    public String filtertext6{get;set;}
    
    //FILTER VALUES FOR TEXT FIELD
    public String newfiltertext1{get;set;}
    public String newfiltertext2{get;set;}
    public String newfiltertext3{get;set;}
    public String newfiltertext4{get;set;}
    public String newfiltertext5{get;set;}
    public String newfiltertext6{get;set;}
    
    //QUERY PART
    public String querycreating {get;set;}
    public String queryFinal{get;set;}
    public String selectedUser{get;set;} //SELECTED USER FROM DROP DOWN TO FILTER RECORDINGS
    public List<SelectOption> lstAllusr {get;set;} //LIST OF ALL USER
    public List<SelectOption> lstAlllookuprelated {get;set;} // LOOKUP FIELDS FOR SELECTED OBJECT IN 3RD OPTION
    public List<SelectOption> lstAllObjoner {get;set;} //OWNER LIST
    public String selectedTime {get;set;} // SELECTED TIME FOR FUTURE CALL
    public String selectedLookup {get;set;}  //SELECTED LOOKUP TO SEND EMAIL 
    public String Recordingnumbers{get;set;} //SELECTED RECORDING NUMBER TO SEND TO THE CONTACT OR LEAD
    public Boolean isActivityhistory {get;set;}
    public Boolean isLoggedin {get;set;} //CHECKING WHETHER USER IS LOGGED IN OR NOT IN THE S2V ACCOUNT
    
    
    //SMS TEMPLATE
    public String smstemplateID {get;set;}
    public String smstemplateName {get;set;}
    public String smstemplateBody {get;set;}
    //public String smsradio {get;set;}
    //public String voicemailradio {get;set;}
    public String radioValues;
    public boolean voicemailvalue {get;set;}
    public boolean sms {get;set;}
    
    public S2VVoiceMailSendPageController()
    {
        
        lstAllObjoner = new List<SelectOption>();
        options = new List<SelectOption>();
        optionSchedule = new List<SelectOption>();
        isLoggedin =true;
        //Voicemail = true;
        //CUSTOM SETTING CHECKING
        s2vSMSDemo__S2V_Settings1__c customsetting = s2vSMSDemo__S2V_Settings1__c.getOrgDefaults();
        
        if(customsetting.s2vSMSDemo__username__c != Null && customsetting.s2vSMSDemo__username__c != '')
        {
            isLoggedin = false;
        }
        
        lstAlllookuprelated = new List<SelectOption>();
        lstAllusr = new List<SelectOption>();
        lstAllusr.add(new SelectOption('0','-- None --'));
        isEditMode = false;
        enabletime = false;
        querycreating='';  
        
        mapObjAPINameToLable = new Map<String,String>();
        mapFieldAPINameToLable = new map<String,String>();
        List<String> lstobjName = new List<String>();
        lstObjNames = new List<SelectOption>();
        lstObjNames.add(new SelectOption('0','-- None --'));
        lstObjFields = new List<SelectOption>();
        lstObjFields.add(new SelectOption('0','-- None --'));
        
        if(apexpages.currentpage().getparameters().get('sid') != null && apexpages.currentpage().getparameters().get('sid').trim() != '')
        {
            isEditMode = true;
            tempS2VId = apexpages.currentpage().getparameters().get('sid').trim();
            
            
            List<S2V_Send_Voicemail__c> lstVoiceMail = [SELECT Id,Object_Name__c,Reference_Field_Lable__c,Recording_Name__c, Option_Schedule__c,Schedule_Frequency__c,Reference_Field__c,Start_Date__c 
                                                        FROM S2V_Send_Voicemail__c WHERE Id =: tempS2VId];
            
            if(lstVoiceMail != null && lstVoiceMail.size() > 0)
            {
                if(lstVoiceMail[0].Object_Name__c != null)
                {
                    selectedObject = lstVoiceMail[0].Object_Name__c;
                }
                else
                {
                    selectedObject = '0';
                }
                
                if(lstVoiceMail[0].Reference_Field__c != null)
                {
                    selectedField = lstVoiceMail[0].Reference_Field__c;
                }
                else
                {
                    selectedField = '0';
                }
                
                if(lstVoiceMail[0].Recording_Name__c != null)
                {
                    selectedRecordingName = lstVoiceMail[0].Recording_Name__c;
                }
                else
                {
                    selectedRecordingName = '0';
                }
                
            }
        }
        
        //FILLING LIST OF ALL OBJECT NAMES
        list<schema.sobjecttype> gd= schema.getglobaldescribe().values();
        for(schema.sobjecttype gh:gd)
        {
            if(!gh.getdescribe().isCustomSetting())
            {
                mapObjAPINameToLable.put(gh.getdescribe().getname(), gh.getdescribe().getLabel());
            }
        }
        
        
        //TO FILL THE LIST OF OBJECT FROM WHICH VOICE MAIL WILL SEND
        List<String> lstobjnamenotused = new List<String>();
        lstObjNames.add(new selectoption('Contact','Contact'));
        lstObjNames.add(new selectoption('Lead','Lead'));
        lstObjNames.add(new selectoption('Opportunity','Opportunity'));
        lstObjNames.add(new selectoption('CampaignMember','CampaignMember'));
        lstObjNames.add(new selectoption('Task','Task'));
        
        Set<SelectOption> setObjNames = new set<SelectOption>();
        setObjNames.addAll(lstObjNames);
        lstObjNames.clear();
        lstObjNames.addAll(setObjNames);
        lstObjNames.sort();
        
    }
    
    public PageReference doredirect()
    {
        PageReference pr = new PageReference('/apex/IOMyAccount');
        pr.setRedirect(true);
        return pr;
        
    }
    
    //GETTING FIELDS OF SELECTED OBJECT INTO FILTER CRITERIA'S DROP DOWN
    public List<SelectOption> getAllFieldNames()
    {
        lstAlllookuprelated.clear();
        if(selectedObject != Null && selectedObject != '0')
        {
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            for(Schema.SObjectField sobjectFields : fieldMap.Values())
            {
                if(sobjectFields.getDescribe().getType() != Schema.DisplayType.REFERENCE && sobjectFields.getDescribe().getType() != Schema.DisplayType.TEXTAREA)
                {
                    lstAlllookuprelated.add(new selectoption(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel()));
                }
            }
            return lstAlllookuprelated;
        }
        return null;
    }
    
    //GETTING REFERENCE FIELD LIKE OWNER,MODIFY BY FIELDS WHICH ARE RELATED TO USER
    public List<SelectOption> getSobjectFieldNames()
    {
        if(mapObjAPINameToLable != null && mapObjAPINameToLable.size() > 0 && selectedObject != null && selectedObject.trim() != '' && selectedObject != '0')
        {
            mapFieldAPINameToLable.clear();
            lstObjFields.clear();
            lstObjFields.add(new SelectOption('0','-- None --'));
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            for(Schema.SObjectField sobjectFields : fieldMap.Values())
            {
                mapFieldAPINameToLable.put(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel());
                if(sobjectFields.getDescribe().getType() == Schema.DisplayType.REFERENCE)
                {
                    List<Schema.sObjectType> temp = sobjectFields.getDescribe().getReferenceTo();
                    if(temp != null && temp.size() > 0 && temp.size() == 1){
                        for(Schema.sObjectType s : temp)
                        {
                            if(String.valueOf(s) == 'User')
                            {
                                lstObjFields.add(new selectoption(sobjectFields.getDescribe().getName(), sobjectFields.getDescribe().getLabel()));
                            }
                        }
                    }
                }
            }
            
        }
        // SELECTEDOBJECT CD = [SELECT ID,NAME FROM SELECTEDOBJECT];
        return lstObjFields;
    }
    
    //FETCH ALL USERS OF CURRENT ORG AND ADD IT IN TO DROP DOWN
    public List<SelectOption> SobjectUserNames1
    {
        
        get{
            lstAllusr.clear();
            List<User> usr = [select Id,Name from User limit 50000];
            lstAllusr.add(new SelectOption('0','-- None --'));
            
            for(User usrs : usr)
            {
                lstAllusr.add(new SelectOption(usrs.Id ,usrs.Name));
            }
            return lstAllusr;
        }
        set;
    }
    
    
    public List<SelectOption> getScheduleList()
    {
        optionSchedule.clear();
        Schema.DescribeFieldResult fieldResult = S2V_Send_Voicemail__c.s2vSMSDemo__Option_Schedule__c.getDescribe();
        List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry sp : pickList)
        {
            optionSchedule.add(new SelectOption(sp.getLabel(), sp.getValue()));
        }
        system.debug(optionSchedule);
        return optionSchedule;
    }
    
    
    //FREQUENCIES FOR FUTURE CALL TO IDENTIFY WHEN USER WANT TO SCHEDULE AND SEND VOICE MAIL
    public List<SelectOption> getScheduleFreqList()
    {
        Schema.DescribeFieldResult fieldResult = S2V_Send_Voicemail__c.Schedule_Frequency__c.getDescribe();
        List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry sp : pickList)
        {
            options.add(new SelectOption(sp.getLabel(), sp.getValue()));
        }
        return options;
    }
    
    //ENABLING DATE FREQUENCY AND TIME FIELD TO SCHEDULE IN FURURE
    public void enableFutureCallFields()
    {
        
        if(selectedOptionschedule != null && selectedOptionschedule != '0' && selectedOptionschedule == 'Future Call')
        {
            enabletime = True;
        }
        else
        {
            enabletime = False;
        }
        system.debug(enabletime);
    }
    
    
    
    //SAVE ALL SELECTED DATA IN TO S2V__S2V_SEND_VOICEMAIL__C OBJECT AS A RECORD
    public PageReference saveData()
    {
        S2V_Send_Voicemail__c svcObj;
        
        if(selectedObject!=NULL && selectedField!=NULL && !isEditMode)
        {
            List<S2V_Send_Voicemail__c> lstS2V = [SELECT Id FROM S2V_Send_Voicemail__c WHERE Object_Name__c != null AND Object_Name__c =: selectedObject AND Reference_Field__c != null AND Reference_Field__c =: selectedField];  
        }
        
        if(isEditMode != true)
        {
            svcObj = new S2V_Send_Voicemail__c();
        }
        else if(isEditMode == true)
        {
            svcObj = new S2V_Send_Voicemail__c(id=tempS2VId);
        }
        
        //OBJECT SELECTED
        if(selectedObject != null && selectedObject.trim() != '' && selectedObject.trim() != '0')
        {
            svcObj.Name = selectedObject;
            svcObj.Object_Name__c = selectedObject;
        }
        
        //FIELD SELECTED
        if(selectedField != null && selectedField.trim() != '' && selectedField.trim() != '0')
        {
            svcObj.Reference_Field__c = selectedField;
            svcObj.Reference_Field_Lable__c = mapFieldAPINameToLable.get(selectedField);
        }
        
        //RECORDING SELECTED
        if(selectedRecordingName != null && selectedRecordingName.trim() != '' && selectedRecordingName.trim() != '0')
        {
            svcObj.Recording_Name__c = selectedRecordingName;
        }
        
        //SCHEDULING SELECTING
        if(selectedOptionschedule != null && selectedOptionschedule.trim() != '' && selectedOptionschedule.trim()!= '0')
        {
            svcObj.Option_Schedule__c = selectedOptionschedule;            
        }
        
        //USER SELECTED
        if(selectedUser != '0' && selectedUser != Null && selectedUser != '')
        {
            svcObj.Voice_mail_1_User__c = selectedUser;
        } 
        
        if(selectedRecordingName != '0' && selectedRecordingName != Null && selectedRecordingName != '')
        {
            svcObj.Recording_By_1_User__c = selectedRecordingName;
        }
        
        if(Recordingnumbers != Null && Recordingnumbers != '0' && Recordingnumbers != '')
        {
            svcObj.Recording_Name__c = Recordingnumbers;
        }
        
        if(selectedLookup != Null && selectedLookup != '' && selectedLookup != '0')
        {
            svcObj.Selected_Lookup__c = selectedLookup;
        }
        
        if(voicemailvalue ==  true)
        {
            svcObj.Sending_Method__c = 'Voicemail';
        }
        
        if(sms == true)
        {
            svcObj.Sending_Method__c = 'SMS';
            
            if(smstemplateBody!=NULL)
            {
                svcObj.SMS_Template_Body__c = smstemplateBody;
            }
            
            if(smstemplateName!=NULL)
            {
                svcObj.SMS_Template_Name__c = smstemplateName;
            }
        }
        
        svcObj.Is_Active__c = True;
        
        svcObj.Activity_History__c= True;
        
        if(fieldsneed!=null)
        {
            svcObj.SMS_Object__c =  fieldsneed;
        }
        
        //::::: FOR OPTION SCHEDULE FUTURE STARTS HERE (VOICEMAIL && SMS) :::::
        if(selectedOptionschedule!=NULL && selectedOptionschedule.trim()!='' && selectedOptionschedule.trim()!='Now')
        {
            svcObj.Option_Schedule__c = selectedOptionschedule;
            
            if(selectedFreq!=NULL)
            {
                svcObj.s2vSMSDemo__Schedule_Frequency__c = selectedFreq;
            }
            
            if(selectedDate!=NULL)
            {
                svcObj.s2vSMSDemo__Start_Date__c = selectedDate;
            }
            
            //:::: MODIFYING THE DATE AS PER SALESFORCE FORMAT STARTS HERE ::::
            List<String> listOfDateVariables;
            
            if(selectedDate!=NULL && selectedDate.day()!=NULL && selectedDate.month()!=NULL && selectedDate.year()!=NULL)
            {
                listOfDateVariables = new List<String>{String.valueOf(selectedDate.day()), String.valueOf(selectedDate.month()), String.valueOf(selectedDate.year())};                
            }
            
            String separator= '/';
            String finalDate;
            if(listOfDateVariables!=NULL)
            {
                finalDate = String.join(listOfDateVariables, separator);        
            }
            
            if(selectedTime != Null && selectedTime != '' && selectedTime != '0')
            {
                svcObj.Start_Time__c= selectedTime+' '+finalDate;
            }
            
            if(selectedTime!=NULL)
            {
                svcObj.s2vSMSDemo__Only_time__c = selectedTime;
            }
            
            if(selectedDate!=NULL)
            {
                Date newOnceAddDate = selectedDate;
                Date newEveryAddDate = selectedDate.addDays(1); //DAILY
                Date newWeeklyAdddate = selectedDate.addDays(7); //WEEKLY
                Date newMontlyAddDate = selectedDate.addMonths(1); // MONTHLY
                Date newYearlyAddDate = selectedDate.addYears(1); // YEARLY
                
                //ONCE DATE
                List<String> listOfOnceDateVariables = new List<String>{String.valueOf(newOnceAddDate.day()), String.valueOf(newOnceAddDate.month()), String.valueOf(newOnceAddDate.year())};
                    OnceFinalDate = String.join(listOfOnceDateVariables, separator);        
                system.debug('OnceFinalDate:::::'+OnceFinalDate);
                
                //DAILY DATE
                List<String> listOfEverydayDateVariables = new List<String>{String.valueOf(newEveryAddDate.day()), String.valueOf(newEveryAddDate.month()), String.valueOf(newEveryAddDate.year())};
                    EveryFinalDate = String.join(listOfEverydayDateVariables, separator);        
                system.debug('EverydayFinalDate:::::'+EveryFinalDate);
                
                //WEEKLY DATE
                List<String> listOfWeeklyDateVariables = new List<String>{String.valueOf(newWeeklyAdddate.day()), String.valueOf(newWeeklyAdddate.month()), String.valueOf(newWeeklyAdddate.year())};
                    WeeklyFinalDate = String.join(listOfWeeklyDateVariables, separator);        
                system.debug('WeeklyFinalDate:::::'+WeeklyFinalDate);
                
                //MONTHLY DATE
                List<String> listOfMonthlyDateVariables = new List<String>{String.valueOf(newMontlyAddDate.day()), String.valueOf(newMontlyAddDate.month()), String.valueOf(newMontlyAddDate.year())};
                    MontlhyFinalDate = String.join(listOfMonthlyDateVariables, separator);        
                system.debug('MontlhyFinalDate:::::'+MontlhyFinalDate);
                
                //YEARLY DATE
                List<String> listOfYearlyDateVariables = new List<String>{String.valueOf(newYearlyAddDate.day()), String.valueOf(newYearlyAddDate.month()), String.valueOf(newYearlyAddDate.year())};
                    YearlyFinalDate = String.join(listOfYearlyDateVariables, separator);        
                system.debug('YearlyFinalDate:::::'+YearlyFinalDate);
            }
            
            if(selectedFreq == 'Once')
            {
                svcObj.s2vSMSDemo__Next_Date__c = OnceFinalDate;  
            }
            
            if(selectedFreq == 'Daily')
            {
                svcObj.s2vSMSDemo__Next_Date__c = EveryFinalDate;
            }
            
            if(selectedFreq == 'Weekly')
            {
                svcObj.s2vSMSDemo__Next_Date__c = WeeklyFinalDate;
            }
            
            if(selectedFreq == 'Monthly')
            {
                svcObj.s2vSMSDemo__Next_Date__c = MontlhyFinalDate;
            }
            
            if(selectedFreq == 'Yearly')
            {
                svcObj.s2vSMSDemo__Next_Date__c = YearlyFinalDate;
            }
            
            //:::: MODIFYING THE DATE AS PER SALESFORCE FORMAT ENDS HERE ::::
        }
        //::::: FOR OPTION SCHEDULE FUTURE ENDS HERE (VOICEMAIL && SMS) :::::
        
        //************************************ GOLDEN CODE FOR FILTER CRITERIA STARTS HERE****************************
        newFilterText1 = '\''+String.escapeSingleQuotes(filterText1)+ '\'';
        newFilterText2 = '\''+String.escapeSingleQuotes(filterText2)+ '\'';
        newFilterText3 = '\''+String.escapeSingleQuotes(filterText3)+ '\'';
        newFilterText4 = '\''+String.escapeSingleQuotes(filterText4)+ '\'';
        newFilterText5 = '\''+String.escapeSingleQuotes(filterText5)+ '\'';
        newFilterText6 = '\''+String.escapeSingleQuotes(filterText6)+ '\'';
        
        if(filterText1!=NULL && (filterText1.toLowerCase() == 'true' || filterText1.toLowerCase() == 'false'))
        {
            newFilterText1 = filterText1;
        }
        
        if(filterText2!=NULL && (filterText2.toLowerCase() == 'true' || filterText2.toLowerCase() == 'false'))
        {
            newFilterText2 = filterText2;
        }
        
        if(filterText3!=NULL && (filterText3.toLowerCase() == 'true' || filterText3.toLowerCase() == 'false'))
        {
            newFilterText3 = filterText3;
        }
        
        if(filterText4!=NULL && (filterText4.toLowerCase() == 'true' || filterText4.toLowerCase() == 'false'))
        {
            newFilterText4 = filterText4;
        }
        
        if(filterText5!=NULL && (filterText5.toLowerCase() == 'true' || filterText5.toLowerCase() == 'false'))
        {
            newFilterText5 = filterText5;
        }
        
        if(filterText6!=NULL && (filterText6.toLowerCase() == 'true' || filterText6.toLowerCase() == 'false'))
        {
            newFilterText6 = filterText6;
        }
        
        String querycommanpart;
        
        System.debug(filterText1+' '+filterText2+' '+filterText3+' '+filterText4+' '+filterText5+' '+filterText6);
        
        if(filterText1 != '' || filterText2 != '' || filterText3 != '' || filterText4 != '' || filterText5 != '' || filterText6 != '')
        {
            
            if(selectedField != '0' && selectedField != Null && selectedField != '' 
               && selectedLookup != '0' && selectedLookup != Null && selectedLookup != '')
            {
                querycommanpart = '['+'SELECT'+' Id,'+selectedField+','+selectedLookup+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
            }
            else if(selectedField != '0' && selectedField != Null && selectedField != '')
            {
                querycommanpart = '['+'SELECT'+' Id,'+selectedField+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
            }
            else if(selectedLookup != '0' && selectedLookup != Null && selectedLookup != '')
            {
                querycommanpart = '['+'SELECT'+' Id,'+selectedLookup+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
            }
            else 
            {
                querycommanpart = '['+'SELECT'+' '+'Id'+' '+'FROM'+' '+selectedObject+' '+'WHERE'+' ';
            } 
            
        } 
        else 
        {
            if(selectedField != '0' && selectedField != Null && selectedField != '' 
               && selectedLookup != '0' && selectedLookup != Null && selectedLookup != '')
            {
                querycreating = '['+'SELECT'+' Id,'+selectedField+','+selectedLookup+' '+'FROM'+' '+selectedObject+'];';
            }
            else if(selectedField != '0' && selectedField != Null && selectedField != '')
            {
                querycreating = '['+'SELECT'+' Id,'+selectedField+' '+'FROM'+' '+selectedObject+'];';
            } 
            else if(selectedLookup != '0' && selectedLookup != Null && selectedLookup != '')
            {
                querycreating = '['+'SELECT'+' Id,'+selectedLookup+' '+'FROM'+' '+selectedObject+'];';
            }
            else 
            {
                querycreating = '['+'SELECT'+' '+'Id'+' '+'FROM'+' '+selectedObject+'];';
            } 
        }
        
        String operator1 ='';
        String operator2 ='';
        String operator3 ='';
        String operator4 ='';
        String operator5 ='';
        String operator6 ='';
        
        if(filterop1!=NULL)
        {
            if(filterop1=='Equals')
            {
                operator1 = '=';
            }
            if(filterop1=='Not Equals to')
            {
                operator1 = '!=';
            }
            if(filterop1=='Less than')
            {
                operator1 = '<';
            }
            if(filterop1 == 'Greater than')
            {
                operator1 = '>';
            }
            if(filterop1 == 'Less or equal')
            {
                operator1 = '<=';
            }
            if(filterop1 == 'Greater or equal')
            {
                operator1 = '>=';
            }
        }
        
        if(filterop2!=NULL)
        {
            if(filterop2=='Equals')
            {
                operator2 = '=';
            }
            if(filterop2=='Not Equals to')
            {
                operator2 = '!=';
            }
            if(filterop2=='Less than')
            {
                operator2 = '<';
            }
            if(filterop2 == 'Greater than')
            {
                operator2 = '>';
            }
            if(filterop2 == 'Less or equal')
            {
                operator2 = '<=';
            }
            if(filterop2 == 'Greater or equal')
            {
                operator2 = '>=';
            }
        }
        
        if(filterop3!=NULL)
        {
            if(filterop3=='Equals')
            {
                operator3 = '=';
            }
            if(filterop3=='Not Equals to')
            {
                operator3 = '!=';
            }
            if(filterop3=='Less than')
            {
                operator3 = '<';
            }
            if(filterop3 == 'Greater than')
            {
                operator3 = '>';
            }
            if(filterop3 == 'Less or equal')
            {
                operator3 = '<=';
            }
            if(filterop3 == 'Greater or equal')
            {
                operator3 = '>=';
            }
        }
        
        if(filterop4!=NULL)
        {
            if(filterop4=='Equals')
            {                
                operator4 = '=';
            }
            if(filterop4=='Not Equals to')
            {
                operator4 = '!=';
            }
            if(filterop4=='Less than')
            {
                operator4 = '<';
            }
            if(filterop4 == 'Greater than')
            {
                operator4 = '>';
            }
            if(filterop4 == 'Less or equal')
            {
                operator4 = '<=';
            }
            if(filterop4 == 'Greater or equal')
            {
                operator4 = '>=';
            }
        }
        
        if(filterop5!=NULL)
        {
            if(filterop5=='Equals')
            {
                operator5 = '=';
            }
            if(filterop5=='Not Equals to')
            {
                operator5 = '!=';
            }
            if(filterop5=='Less than')
            {
                operator5 = '<';
            }
            if(filterop5 == 'Greater than')
            {
                operator5 = '>';
            }
            if(filterop5 == 'Less or equal')
            {
                operator5 = '<=';
            }
            if(filterop5 == 'Greater or equal')
            {
                operator5 = '>=';
            }
        }
        
        if(filterop6!=NULL)
        {
            if(filterop6=='Equals')
            {
                operator6 = '=';
            }
            if(filterop6=='Not Equals to')
            {
                operator6 = '!=';
            }
            if(filterop6=='Less than')
            {
                operator6 = '<';
            }
            if(filterop6 == 'Greater than')
            {
                operator6 = '>';
            }
            if(filterop6 == 'Less or equal')
            {
                operator6 = '<=';
            }
            if(filterop6 == 'Greater or equal')
            {
                operator6 = '>=';
            }
        }
        
        // TEXT BOX VALUE 1 IS PRESENT WITHOUT BOOLEAN
        if(filterValue1!=NULL && filterValue1!='' && filterValue1!='0')
        {
            if(filterText1!=NULL && filterText1!=' ' && !String.isBlank(filterText1))
            {
                querycreating = querycommanpart + filterValue1 +' '+operator1+' '+newFilterText1 +']'+';' ; 
            }
        }    
        
        // TEXT BOX VALUE 1 IS PRESENT WITH BOOLEAN
        if(filterValue1!=NULL && filterValue1!='' && filterValue1!='0')
        {
            if(filterText1!=NULL && filterText1!=' ' && !String.isBlank(filterText1))
            {
                querycreating = querycommanpart + filterValue1 +' '+operator1+' '+newFilterText1 +']'+';' ; 
            }
        }
        
        // IF TEXT BOX 1 VALUE IS TRUE:
        if(filterText1!=NULL && filterText1!=' ' && !String.isBlank(filterText1))
        {
            if((filterValue2!=NULL && filterValue2!='' && filterValue2!='0')
               && (filterText2!=NULL && filtertext2!=' ' && !String.isBlank(filterText2)))
            {
                querycreating = querycommanpart + filterValue1 +' '+operator1+' '+newFilterText1
                    +' '+ 'AND' +' '+ filterValue2 +' '+operator2+' '+newFilterText2 +']'+';';
            }
        }      
        
        //IF TEXT BOX 1 AND 2 VALUE IS TRUE:
        if((filterText1!=NULL && filtertext1!='' && !String.isEmpty(filterText1))
           &&(filterText2!=NULL && filterText2!='' && !String.isEmpty(filterText2)))
        {
            if((filterValue3!=NULL && filterValue3!='' && filterValue3!='0')
               &&(filterText3!=NULL && filtertext3!=' ' && !String.isBlank(filterText3)))
            {
                querycreating = querycommanpart + filterValue1 +' '+operator1+' '+newFilterText1
                    +' '+ 'AND' +' '+ filterValue2 +' '+operator2+' '+newFilterText2
                    +' '+ 'AND' +' '+ filterValue3 +' '+operator3+' '+newFilterText3 +']'+';';
            }
        }
        
        
        //IF TEXTBOX 1 2 AND 3 VALUE IS TRUE
        if((filterText1!=NULL && filtertext1!='' && !String.isEmpty(filterText1))
           &&(filterText2!=NULL && filterText2!='' && !String.isEmpty(filterText2))
           &&(filtertext3!=NULL && filterText3!='' && !String.isEmpty(filterText3)))
        {
            if((filterValue4!=NULL && filterValue4!='' && filterValue4!='0')
               &&(filtertext4!=NULL && filterText4!=' ' && !String.isBlank(filterText4)))
            {
                querycreating = querycommanpart + filterValue1 +' '+operator1+' '+newFilterText1
                    +' '+ 'AND' +' '+ filterValue2 +' '+operator2+' '+newFilterText2
                    +' '+ 'AND' +' '+ filterValue3 +' '+operator3+' '+newFilterText3
                    +' '+ 'AND' +' '+ filterValue4 +' '+operator4+' '+newFilterText4 +']'+';';
            }
        }    
        
        //IF TEXT 1 2 3 AND 4 VALUE IS TRUE
        if((filterText1!=NULL && filtertext1!='' && !String.isEmpty(filterText1))
           &&(filterText2!=NULL && filterText2!='' && !String.isEmpty(filterText2))
           &&(filtertext3!=NULL && filterText3!='' && !String.isEmpty(filterText3))
           &&(filterText4!=NULL && filtertext4!='' && !String.isEmpty(filtertext4)))
        {
            if((filterValue5!=NULL && filterValue5!='' && filterValue5!='0')
               &&(filtertext5!=NULL && filterText5!='' && !String.isBlank(filterText5)))
            {
                querycreating = querycommanpart + filterValue1 +' '+operator1+' '+newFilterText1
                    +' '+ 'AND' +' '+ filterValue2 +' '+operator2+' '+newFilterText2
                    +' '+ 'AND' +' '+ filterValue3 +' '+operator3+' '+newFilterText3
                    +' '+ 'AND' +' '+ filterValue4 +' '+operator4+' '+newFilterText4
                    +' '+ 'AND' +' '+ filterValue5 +' '+operator5+' '+newFilterText5 +']'+';';
            } 
        }
        
        //IF TEXT BOX 1 2 3 4 5 VALUES ARE TRUE
        if((filterText1!=NULL && filtertext1!='' && !String.isEmpty(filterText1))
           &&(filterText2!=NULL && filterText2!='' && !String.isEmpty(filterText2))
           &&(filtertext3!=NULL && filterText3!='' && !String.isEmpty(filterText3))
           &&(filterText4!=NULL && filtertext4!='' && !String.isEmpty(filtertext4))
           &&(filterText5!=NULL && filterText5!='' && !String.isEmpty(filterText5)))
        {
            if((filterValue6!=NULL && filterValue6!='' && filterValue6!='0')
               &&(filtertext6!=NULL && filterText6!=' ' && !String.isBlank(filterText6)))
            {
                querycreating = querycommanpart + filterValue1 +' '+operator1+' '+newFilterText1
                    +' '+ 'AND' +' '+ filterValue2 +' '+operator2+' '+newFilterText2
                    +' '+ 'AND' +' '+ filterValue3 +' '+operator3+' '+newFilterText3
                    +' '+ 'AND' +' '+ filterValue4 +' '+operator4+' '+newFilterText4
                    +' '+ 'AND' +' '+ filterValue5 +' '+operator5+' '+newFilterText5
                    +' '+ 'AND' +' '+ filterValue6 +' '+operator6+' '+newFilterText6 +']'+';';
            }
        }
        
        if(querycreating!=NULL && querycreating!='')
        {
            queryFinal = selectedObject +' '+'obj'+selectedObject +'='+querycreating;
            svcObj.Query__c = queryFinal;    
        }
        
        if(Schema.sObjectType.S2V_Send_Voicemail__c.isUpdateable() || Schema.sObjectType.S2V_Send_Voicemail__c.iscreateable())
        {
            upsert svcObj;
            system.debug('svcObj::::::'+svcObj);
        }
        
        //PageReference pr = new PageReference('/apex/S2VTriggerDeployment?objName='+selectedObject);
        PageReference pr = new PageReference('/apex/S2VTriggerDeployment?objName='+selectedObject);
        if(fieldsneed != null && fieldsneed != '0')
        {
            pr.getParameters().put('slctdFldType', fieldsneed);
        }
        
        if(selectedLookup != null && selectedLookup != '0')
        {
            pr.getParameters().put('objFld', selectedLookup);
        }
        
        pr.getParameters().put('SId',svcObj.Id);
        pr.setRedirect(true);
        return pr;
    }
    
    
    //*********************** VOICEMAIL STARTS ************************************
    //METHOD WHICH IS CALLING FROM TRIGGER ALLOW TO MAKE VOICE MAIL TO INSERTED CONTACT OR LEAD FOR SPECIFIC QUERY CRITERIA
    
    Global static Boolean CallFutureMethod(List<id> lstSobjRcrds, String ObjectName)
    {
        Boolean retVal = false;
        String contactLookup ; //TO CHECK WHETHER LOOKUP OF CONTACT IS AVAILABLE OR NOT OTHERWISE THAK THE ID
        
        //QUERY ON ACTIVE SCHEDULES
        if(lstSobjRcrds != null && lstSobjRcrds.size() > 0 && ObjectName != null && ObjectName.trim() != '')
        {
            
            List<S2V_Send_Voicemail__c> lstSndVcmails =[SELECT Is_Active__c,Reference_Field_Lable__c,S2V_Send_Voicemail__c.Caller_Id__c,Id,Object_Name__c,
                                                        Query__c,Option_Schedule__c,Recording_Name__c, Reference_Field__c,Schedule_Frequency__c,
                                                        Start_Date__c,Voice_mail_1_User__c,Recording_By_1_User__c,User_1__c, Recording_1__c,
                                                        Start_Time__c,User_2__c,Recording_2__c,User_3__c,Recording_3__c,Selected_recording_number__c,
                                                        Selected_Lookup__c,Activity_History__c,Sending_Method__c,SMS_Template_Name__c,SMS_Template_Body__c,SMS_Object__c,
                                                        Only_time__c,s2vSMSDemo__Next_Date__c
                                                        FROM S2V_Send_Voicemail__c WHERE Object_Name__c != null AND Is_Active__c = True 
                                                        AND Object_Name__c =: ObjectName.trim() AND Sending_Method__c !=NULL];
            
            //MAIN IF CONDITION STARTS HERE
            if(lstSndVcmails!=NULL && lstSndVcmails.size()>0)
            {
                List<Id> lstids = new List<Id>(); // STORING CONTACT ID TO PASS IN THE CREATE TASK METHOD ONLY IF VOICE MAIL IS SUCCESSFULLY SEND
                
                String s;
                map<String,String> recordnum = new map<String,String>(); 
                //STORING ACTIVESCHEDULE RECORD ID AND THE RECORDING NUMBER WHICH IS GOING TO SENT
                
                Map<String,List<Id>> mptskid = new Map<String,List<Id>>(); //STORING ACTIVESCHEDULE RECORD ID AND LIST OF CONTACT IDS TO CREATE TASK
                
                List<ID> listofIds = new List<ID>(); //STORING RECORD IDS WHICH ARE COMMING FROM TRIGGER
                
                //FOR CONDITION STARTS HERE
                for(S2V_Send_Voicemail__c activevoice : lstSndVcmails)
                {
                    
                    String fieldName = activevoice.Reference_Field__c;
                    List<String> lstCntIds = new List<String>();
                    
                    String UserField; //TO TAKE REFERENCE FIELD FROM WHICH USER THIS VOICE MAIL NEET TO SENT
                    
                    //SELECTED LOOKUP FIELD
                    if(activevoice.Selected_Lookup__c != Null && activevoice.Selected_Lookup__c != '')
                    {
                        contactLookup = activevoice.Selected_Lookup__c;
                    } 
                    else 
                    {
                        contactLookup = 'Id';
                    }
                    
                    //REFERENCE FIELD 
                    if(activevoice.Reference_Field__c != Null && activevoice.Reference_Field__c != '')
                    {
                        UserField = activevoice.Reference_Field__c;
                    }
                    
                    String useridreference = '';
                    
                    String lstQuery = activevoice.Query__c.substring(activevoice.Query__c.indexOf('[')+1);
                    String newquery1 = lstQuery.replace(']','');
                    String newquery = newquery1.replace(';','');
                    
                    if(newquery.contains('WHERE'))
                    {
                        System.debug('Inside WHERE IF :::::::');
                        s = newquery+' AND ID IN : lstSobjRcrds';
                    } 
                    else 
                    {
                        System.debug('Inside WHERE Else :::::::');
                        s = newquery+' where ID IN : lstSobjRcrds';
                    }
                    
                    List<Id> useridfrmobj = new List<Id>();
                    List<sObject> sobjList = Database.query(s);
                    
                    //FETCHING LOOKUP ID OF CONTACT OR LEAD AND IF OF CURRENT RECORD AND IF REFERENCE FIELD OF USER IS PRESENT THEN STORE IT IN TO THE USERS LIST
                    for(sObject obj : sobjList)
                    {
                        
                        lstCntIds.add((String)obj.get(contactLookup));
                        
                        listofIds.add((Id)obj.get('Id'));
                        
                        if(UserField != Null && UserField != '')
                        {
                            useridfrmobj.add((String)obj.get(UserField));
                            useridreference = (String)obj.get(UserField);
                        }
                    }
                    
                    //*****************TASK RELATED CODE STARTS *****************
                    List<Task> tsk = new List<Task>();
                    //CHECK WHETHER TASKS OF THE SAME CONTACT AND RECORDING NUMBER IS AVAILABLE OR NOT OTHERWISE CREATE THE TASK
                    
                    if(activevoice.Sending_Method__c == 'Voicemail')
                    {
                        if(ObjectName != 'Opportunity')
                        {
                            tsk = [select Id,WhoId,whatId from Task where WhoId In :lstCntIds and Send_Voicemail__c =: activevoice.Id and Recording_number__c =: Decimal.valueOf(activevoice.Recording_Name__c)];
                        }
                        else
                        {
                            tsk = [select Id,WhoId,whatId from Task where WhoId In :lstCntIds AND whatId In : listofIds and Send_Voicemail__c =: activevoice.Id and Recording_number__c =: Decimal.valueOf(activevoice.Recording_Name__c)];
                        }   
                    }
                    
                    if(activevoice.Sending_Method__c == 'SMS')
                    {
                        if(ObjectName != 'Opportunity')
                        {
                            tsk = [select Id,WhoId,whatId,SMS_Template_Name__c from Task where WhoId In :lstCntIds and Send_Voicemail__c =: activevoice.Id and SMS_Template_Name__c =: activevoice.SMS_Template_Name__c];
                        }
                        else
                        {
                            tsk = [select Id,WhoId,whatId,SMS_Template_Name__c from Task where WhoId In :lstCntIds AND whatId In : listofIds and Send_Voicemail__c =: activevoice.Id and SMS_Template_Name__c =: activevoice.SMS_Template_Name__c];
                        }
                    }
                    
                    
                    List<Id> contskid = new List<Id>();
                    List<Id> tskids = new List<Id>();
                    
                    //FILTER IDS IF TASKS ARE ALREADY CREATED
                    if(lstCntIds != null && lstCntIds.size()>0)
                    {
                        if(tsk != null && tsk.size()>0)
                        {
                            for(Task tss : tsk)
                            {
                                tskids.add(tss.WhoId);
                            }
                            
                            for(Id conids : lstCntIds)
                            {
                                if(!tskids.contains(conids))
                                {
                                    contskid.add(conids);
                                }
                            }
                        } 
                        else 
                        {
                            contskid.addAll(lstCntIds);
                        }
                    }
                    //*****************TASK RELATED CODE ENDS *****************
                    
                    //SAVING ACTIVE SCHEDULE DATA TO A STRING VALUES
                    List<User> usrs = new List<User>();
                    String [] phoneList = New String[]{};
                        
                        String Starttime;
                    
                    if(activevoice.Start_Time__c != Null && activevoice.Start_Time__c != '')
                    {
                        Starttime = activevoice.Start_Time__c;
                        system.debug('starttime::::'+Starttime);
                    }
                    
                    Integer optionSchedule = 0;
                    if(activevoice.Option_Schedule__c != null && activevoice.Option_Schedule__c == Commonconstant.futurecall )
                    {
                        optionSchedule = 1;
                    }
                    
                    String nextDateofSendingVM;
                    if(activevoice.s2vSMSDemo__Next_Date__c!=NULL && activevoice.s2vSMSDemo__Next_Date__c!='')
                    {
                        nextDateofSendingVM = activevoice.s2vSMSDemo__Next_Date__c;
                    }
                    
                    String onlySelectedTime;
                    if(activeVoice.s2vSMSDemo__Only_time__c!=NULL && activeVoice.s2vSMSDemo__Only_time__c!='')
                    {
                        onlySelectedTime = activeVoice.s2vSMSDemo__Only_time__c;
                    }
                    
                    String ScheduleFreq = activevoice.Schedule_Frequency__c;
                    
                    //IF ELSE VOICEMAIL IS SENDING THROUGH SPECIFIC USER STARTS HERE ***
                    if(activevoice.Voice_mail_1_User__c != Null  
                       && activevoice.Voice_mail_1_User__c != '' 
                       && activevoice.Recording_By_1_User__c != Null  
                       && activevoice.Voice_mail_1_User__c != ''){
                           
                           // CHECK IF VOICEMAIL IS SELECTED CONDITION STARTS HERE ******
                           if(activevoice.sending_method__C == 'Voicemail')
                           {
                               User usr = [select Id,MobilePhone from User where Id =: activevoice.Voice_mail_1_User__c];
                               String callerId = usr.MobilePhone;
                               String singleuser = activevoice.Voice_mail_1_User__c;
                               String selectedVoice = activevoice.Recording_By_1_User__c;
                               
                               if((contskid!=NULL && contskid.size()>0))
                               {
                                   
                                   String phoneListFinal = S2VVoiceMailSendPageController.Phonelist(contskid,ObjectName);
                                   String countryCode = S2VVoiceMailSendPageController.CountryCodeList(contskid, ObjectName); 
                                   
                                   if(phoneListFinal!='' && phoneListFinal!=NULL)
                                   {
                                       system.debug('listofIds:::::917'+listofIds);
                                       //CALLING CALLOUT METHOD FOR VOICEMAIL
                                       S2VVoiceMailSendPageController.makeGeneralCallOut(ObjectName, selectedVoice, phoneListFinal, countryCode,
                                                                                         callerId, optionSchedule, ScheduleFreq, Starttime, singleuser,
                                                                                         True, activevoice.Activity_History__c, contskid, activevoice.id,
                                                                                         activevoice.Recording_Name__c, lstSobjRcrds, contactLookup, listofIds, s,
                                                                                         nextDateofSendingVM, onlySelectedTime);
                                   }
                                   
                               }
                               
                           } 
                           //CHECK IF VOICEMAIL IS SELECTED CONDITION ENDS HERE ****** 
                           
                           //CHECK IF SMS IS SELECTED CONDITION STARTS HERE ******
                           if(activevoice.sending_method__C == 'SMS')
                           {
                               User usr = [select Id,MobilePhone from User where Id =: activevoice.Voice_mail_1_User__c];
                               
                               String callerId = usr.MobilePhone; //FROM NUMBER
                               String singleuser = activevoice.Voice_mail_1_User__c;
                               String smsTemplateName = activevoice.SMS_Template_Name__c;
                               String smsTemplateBody = activevoice.SMS_Template_Body__c;
                               system.debug('smsTemplateBody::::::<<>>>'+smsTemplateBody.length());
                               if(contskid!=NULL && contskid.size()>0)
                               {
                                   String phoneListFinalSMS = S2VVoiceMailSendPageController.PhonelistSMS(contskid,ObjectName);
                                   if(phoneListFinalSMS!='' && phoneListFinalSMS!=NULL)
                                   {
                                       S2VVoiceMailSendPageController.makeGeneralCallOutFORSMS(smsTemplateName, smsTemplateBody, phoneListFinalSMS, callerId,
                                                                                               optionSchedule, ScheduleFreq, Starttime, activevoice.Activity_History__c,
                                                                                               activevoice.id, contskid, objectName, useridreference, contactLookup, lstSobjRcrds,
                                                                                               listofIds, s, nextDateofSendingVM, onlySelectedTime);
                                   }
                               }
                           }
                       } 
                    
                    //IF VOICEMAIL NEEDS TO BE SEND FROM REFERENCE FIELD LIKE OWNER, CREATED BY::::******
                    else 
                    {
                        //IF VOICE MAIL IS SEND IT THROUGH REFERENCE FIELD LIKE OWNER, CREATED BY .
                        //VOICEMAIL IF CONDITION
                        if(activevoice.sending_method__C == 'Voicemail')
                        {
                            List<user> usr = [select Id,MobilePhone from User where Id In : useridfrmobj];
                            
                            if(contskid != null && contskid.size()>0 )
                            {
                                for(User usr1 : usr)
                                {
                                    List<Id> lstid = new List<Id>();
                                    useridreference = usr1.Id;
                                    String callerId = usr1.MobilePhone;
                                    
                                    for(sObject obj : sobjList)
                                    {
                                        for(String cons : contskid)
                                        {
                                            if((String)obj.get(activevoice.Reference_Field__c) == usr1.Id && (String)obj.get(contactLookup) == cons)
                                            {
                                                lstid.add((String)obj.get(contactLookup));                                                   
                                            }   
                                        }
                                    }
                                    
                                    if((lstid!=NULL && lstid.size()>0 ))
                                    {
                                        
                                        String phoneListFinal = S2VVoiceMailSendPageController.Phonelist(lstid,ObjectName);
                                        String countryCode = S2VVoiceMailSendPageController.CountryCodeList(lstid, ObjectName);
                                        
                                        system.debug('countrycode::::'+countryCode);
                                        String selectedVoice = String.valueOf(activevoice.Recording_Name__c);
                                        if(phoneListFinal != '' && phoneListFinal != Null)
                                        {
                                            system.debug('listofIds:::::986'+listofIds);
                                            S2VVoiceMailSendPageController.makeGeneralCallOut(ObjectName, selectedVoice,
                                                                                              phoneListFinal, countryCode, callerId, optionSchedule,
                                                                                              ScheduleFreq, Starttime, useridreference, True, activevoice.Activity_History__c,
                                                                                              lstid,activevoice.id, activevoice.Recording_Name__c, lstSobjRcrds,
                                                                                              contactLookup, listofIds, s, nextDateofSendingVM, onlySelectedTime);
                                            
                                            retVal = true;
                                        }
                                    }
                                } 
                            }
                            
                        }
                        
                        if(activevoice.sending_method__C == 'SMS')
                        {
                            List<user> usr = [select Id,MobilePhone from User where Id In : useridfrmobj];
                            
                            if(contskid != null && contskid.size()>0 )
                            {
                                for(User usr1 : usr)
                                {
                                    List<Id> lstid = new List<Id>();
                                    useridreference = usr1.Id;
                                    String callerId = usr1.MobilePhone;
                                    
                                    for(sObject obj : sobjList)
                                    {
                                        for(String cons : contskid)
                                        {
                                            if((String)obj.get(activevoice.Reference_Field__c) == usr1.Id 
                                               && (String)obj.get(contactLookup) == cons)
                                            {
                                                lstid.add((String)obj.get(contactLookup));
                                            }   
                                        }
                                    }
                                    
                                    if((lstid!=NULL && lstid.size()>0 ))
                                    {
                                        String phoneListFinalSMS = S2VVoiceMailSendPageController.PhonelistSMS(lstid,ObjectName);
                                        String smsTemplateName = activevoice.SMS_Template_Name__c;
                                        String smsTemplateBody = activevoice.SMS_Template_Body__c;
                                        system.debug('smsTemplateBody::::'+smsTemplateBody.length());
                                        if(phoneListFinalSMS != '' && phoneListFinalSMS != Null)
                                        {
                                            system.debug('listofIds:::::1032'+listofIds);
                                            S2VVoiceMailSendPageController.makeGeneralCallOutFORSMS(smsTemplateName, smsTemplateBody, phoneListFinalSMS, callerId,
                                                                                                    optionSchedule, ScheduleFreq, Starttime, activevoice.Activity_History__c,
                                                                                                    activevoice.id, contskid, objectName, useridreference, contactLookup,
                                                                                                    lstSobjRcrds, listofIds, s, nextDateofSendingVM, onlySelectedTime);
                                            retVal = true;
                                        }
                                    }
                                } 
                            }
                            
                        }
                        
                    }
                    //IF ELSE VOICEMAIL IS SENDING THROUGH SPECIFIC USER ENDS HERE ***
                    
                    //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND LISTOF CONTACT AND LEADS
                    
                    if(lstids != null && lstids.size()>0)
                    {
                        mptskid.put(activevoice.Id,lstids);
                    }
                    
                    //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND RECORDINGNUMBER
                    recordnum.put(activevoice.Id,String.valueOf(activevoice.Recording_Name__c));
                    
                }
                System.debug(lstids);
                //FOR CONDITION ENDS HERE      
            }
            //MAIN IF CONDITION ENDS HERE                                                
        }
        return retVal;
    }
    
    //FUTURE CALLOUT METHOD FOR VOICEMAIL
    @future (Callout = True)
    public static void makeGeneralCallOut(String ObjectName,String selectedVoice,String phoneListFinal,
                                          String countryCode,String callerId,Integer optionSchedule,String ScheduleFreq,
                                          String Starttime,String useridreference, Boolean isRecordingname, Boolean setActivityHistory,
                                          List<Id> lstid, Id activevoiceId, String activevoiceRecording,
                                          List<id> lstSobjRcrds, String contactLookup,List<Id> listofIds, String s, 
                                          String nextDateofSendingVM, String onlySelectedTime)
    {   
        //CallFutureMethod(lstSobjRcrds, ObjectName);
        boolean retVal;
        List<id> lstids = new List<id>();
        Map<String, List<Id>> mptskid = new Map<String, List<Id>>();
        Map<String, String> recordnum = new Map<String, String>();
        
        Boolean b1 = S2VVoiceMailSendPageController.sendmailmethod(ObjectName,selectedVoice,phoneListFinal,
                                                                   countryCode,callerId,optionSchedule,ScheduleFreq,
                                                                   Starttime,useridreference,lstSobjRcrds,false);
        system.debug('b1::::'+b1);
        if(b1 == True && setActivityHistory == True)
        {
            lstids.addAll(lstid);
            retVal = true;
        }
        
        if(lstids != null && lstids.size()>0)
        {
            mptskid.put(activevoiceId,lstids);
        }
        
        system.debug('mptskid::::::'+mptskid);
        //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND RECORDINGNUMBER
        recordnum.put(activevoiceId,String.valueOf(activevoiceRecording));
        S2VVoiceMailSendPageController.createTasks(mptskid,ObjectName,recordnum,lstSobjRcrds,contactLookup,listofIds,s);
    }
    
    //FUTURE CALLOUT METHOD FOR SMS
    @future (Callout = True)
    public static void makeGeneralCallOutFORSMS(String smsTemplateName, String smsTemplateBody, 
                                                String phoneListFinalSMS, String callerId, Integer optionSchedule,String ScheduleFreq,String Starttime, Boolean setActivityHistory, 
                                                ID activevoiceid, List<Id> lstid, String objectName, String useridreference, String contactLookup, 
                                                List<id> lstSobjRcrds, List<Id> listofIds,String s, String nextDateofSendingVM, String onlySelectedTime)
    {
        
        boolean retVal;
        List<id> lstids = new List<id>();
        Map<String, List<Id>> mptskid = new Map<String, List<Id>>();
        Map<String, String> recordnum = new Map<String, String>();
        system.debug('lstSobjRcrds:::::::::::::'+lstSobjRcrds);
        system.debug('useridreference:::::'+useridreference);
        Id activevoice = activevoiceid;
        system.debug('List<Id> lstid:::contact::'+lstid);
        Boolean b1 = S2VVoiceMailSendPageController.sendSMSMethod(objectName,smsTemplateBody, smsTemplateName, phoneListFinalSMS, callerId,activevoice,lstid);
        
        if(b1 == True && setActivityHistory == True)
        {
            lstids.addAll(lstid);
            
            retVal = true;
        } 
        else 
        {
            retVal = false;
        }
        
        if(lstids != null && lstids.size()>0)
        {
            mptskid.put(activevoiceId,lstids);
        }
        
        
        //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND RECORDINGNUMBER
        recordnum.put(activevoiceId,smsTemplateName);
        
        S2VVoiceMailSendPageController.createTasks(mptskid,ObjectName,recordnum,lstSobjRcrds,contactLookup,listofIds,s);
        
    }
    
    
    //SINGLE SMS SENDING METHOD FROM CONTACT OR LEAD
    @future (Callout = True)
    public static void singleSMSSending(String objectName, id recordid, String templateName, String message, String fromNumber, String toNumber)
    {
        
        boolean retVal;
        List<id> lstids = new List<id>();
        List<Task> lsttask = new List<Task>();
        
        Boolean b1 = S2VVoiceMailSendPageController.sendSMSMethodSingle(objectName, fromNumber, toNumber, message, recordid);
        
        if(b1 == True)
        {
            retVal = true;
        } 
        else 
        {
            retVal = false;
        }
        
        if(recordid != null)
        {
            Task tsk = new Task();
            tsk.Status = Commonconstant.completed;
            tsk.Priority = Commonconstant.normal;
            tsk.Subject = Commonconstant.smstitle;
            tsk.WhoId = recordid;
            tsk.ActivityDate = system.today();
            lsttask.add(tsk); 
        }
        
        if(lsttask!=NULL && lsttask.size()>0)
        {
            insert lsttask;
        }
        
    }
    
    //THIS METHOD IS CALLED FROM BATCH CLASS S2VFUTUREVOICEMAILBATCH
    Global static Boolean CallFutureMethodBatch(List<id> lstSobjRcrds, String ObjectName)
    {
        Boolean retVal = false;
        String contactLookup;
        
        //MAIN IF CONDITION STARTS HERE********
        if(lstSobjRcrds != null && lstSobjRcrds.size() > 0 && ObjectName != null && ObjectName.trim() != ''){
            
            List<S2V_Send_Voicemail__c> lstSndVcmails = [SELECT Is_Active__c,Reference_Field_Lable__c,S2V_Send_Voicemail__c.Caller_Id__c,Id,
                                                         Object_Name__c,Query__c,Option_Schedule__c,Recording_Name__c,Reference_Field__c,
                                                         Schedule_Frequency__c,Start_Date__c,Voice_mail_1_User__c, Recording_By_1_User__c,User_1__c,
                                                         Recording_1__c,Start_Time__c,User_2__c,Recording_2__c,User_3__c,Recording_3__c,Selected_recording_number__c,
                                                         Selected_Lookup__c,Activity_History__c,Sending_Method__c, s2vSMSDemo__Next_Date__c, s2vSMSDemo__Only_time__c FROM S2V_Send_Voicemail__c 
                                                         WHERE Object_Name__c != null AND Is_Active__c = True 
                                                         AND Object_Name__c =: ObjectName.trim() AND sending_method__c!=NULL];
            
            if(lstSndVcmails!=NULL && lstSndVcmails.size()>0)
            {
                
                List<Id> lstids = new List<Id>(); // STORING CONTACT ID TO PASS IN THE CREATE TASK METHODE ONLY IF VOICE MAIL IS SUCCESSFULLY SEND
                
                String s;
                map<String,String> recordnum = new map<String,String>(); //STORING ACTIVESCHEDULE RECORD ID AND THE RECORDING NUMBER WHICH IS GOING TO SENT
                Map<String,List<Id>> mptskid = new Map<String,List<Id>>(); //STORING ACTIVESCHEDULE RECORD ID AND LIST OF CONTACT IDS TO CREATE TASK
                
                List<String> listOFtaskId = new List<String>();
                
                List<ID> listofIds = new List<ID>(); //STORING RECORD IDS WHICH ARE COMMING FROM TRIGGER
                
                //MAIN FOR LOOP STARTS HERE********
                for(S2V_Send_Voicemail__c activevoice : lstSndVcmails)
                {
                    String fieldName = activevoice.Reference_Field__c;
                    List<String> lstCntIds = new List<String>();
                    
                    String UserField; //TO TAKE REFERENCE FIELD FROM WHICH USER THIS VOICE MAIL NEET TO SENT
                    
                    if(activevoice.Selected_Lookup__c != Null 
                       && activevoice.Selected_Lookup__c != '')
                    {
                        contactLookup = activevoice.Selected_Lookup__c;
                    } 
                    else 
                    {
                        contactLookup = 'Id';
                    }
                    
                    if(activevoice.Reference_Field__c != Null 
                       && activevoice.Reference_Field__c != '')
                    {
                        UserField = activevoice.Reference_Field__c;
                    }
                    
                    String useridreference = '';
                    
                    String lstQuery = activevoice.Query__c.substring(activevoice.Query__c.indexOf('[')+1);
                    String newquery1 = lstQuery.replace(']','');
                    String newquery = newquery1.replace(';','');
                    
                    if(newquery.contains('WHERE'))
                    {
                        System.debug('Inside WHERE IF :::::::');
                        s = newquery+' AND ID IN : lstSobjRcrds';
                    } 
                    else
                    {
                        System.debug('Inside WHERE Else :::::::');
                        s = newquery+' where ID IN : lstSobjRcrds';
                    }
                    
                    List<Id> useridfrmobj = new List<Id>();
                    List<sObject> sobjList = Database.query(s);
                    
                    System.debug('Query Result ::::::::::' + sobjList.size());
                    
                    //FETCHING LOOKUP ID OF CONTACT OR LEAD AND IF OF CURRENT RECORD AND IF REFERENCE FIELD OF USER IS PRESENT THEN STORE IT IN TO THE USERS LIST
                    for(sObject obj : sobjList)
                    {
                        
                        lstCntIds.add((String)obj.get(contactLookup));
                        
                        listofIds.add((Id)obj.get('Id'));
                        
                        if(UserField != Null && UserField != '')
                        {
                            system.debug('UserField::::::::'+UserField);
                            useridfrmobj.add((String)obj.get(UserField));
                            useridreference = (String)obj.get(UserField);
                        }
                    }
                    
                    List<Task> tsk = new List<Task>();
                    //CHECK WHETHER TASKS OF THE SAME CONTACT AND RECORDING NUMBER IS AVAILABLE OR NOT OTHERWISE CREATE THE TASK
                    
                    if(activevoice.Sending_Method__c == 'Voicemail')
                    {
                        if(ObjectName != 'Opportunity')
                        {
                            tsk = [select Id,WhoId,whatId from Task where WhoId In :lstCntIds and Send_Voicemail__c =: activevoice.Id and Recording_number__c =: Decimal.valueOf(activevoice.Recording_Name__c)];
                        }
                        else
                        {
                            tsk = [select Id,WhoId,whatId from Task where WhoId In :lstCntIds AND whatId In : listofIds and Send_Voicemail__c =: activevoice.Id and Recording_number__c =: Decimal.valueOf(activevoice.Recording_Name__c)];
                        }   
                    }
                    
                    if(activevoice.Sending_Method__c == 'SMS')
                    {
                        if(ObjectName != 'Opportunity')
                        {
                            tsk = [select Id,WhoId,whatId,SMS_Template_Name__c from Task where WhoId In :lstCntIds and Send_Voicemail__c =: activevoice.Id and SMS_Template_Name__c =: activevoice.SMS_Template_Name__c];
                        }
                        else
                        {
                            tsk = [select Id,WhoId,whatId,SMS_Template_Name__c from Task where WhoId In :lstCntIds AND whatId In : listofIds and Send_Voicemail__c =: activevoice.Id and SMS_Template_Name__c =: activevoice.SMS_Template_Name__c];
                        }
                    }
                    
                    List<Id> contskid = new List<Id>();
                    List<Id> tskids = new List<Id>();
                    
                    //FILTER IDS IF TASKS ARE ALREADY CREATED
                    if(lstCntIds != null && lstCntIds.size()>0)
                    {
                        
                        if(tsk != null && tsk.size()>0){
                            
                            for(Task tss : tsk)
                            {
                                tskids.add(tss.WhoId);
                                system.debug('task is not nll:::::'+tskids.size());
                            }
                            
                            for(Id conids : lstCntIds)
                            {
                                if(!tskids.contains(conids))
                                {
                                    contskid.add(conids);
                                    system.debug('contskid:::::'+contskid.size());
                                }
                            }
                        } 
                        else 
                        {
                            contskid.addAll(lstCntIds);
                            system.debug('add all contacts or lead to contskid:::'+contskid);
                        }
                    }
                    
                    
                    List<User> usrs = new List<User>();
                    
                    String[] phoneList = New String[]{};
                        String selectedVoice ;
                    
                    String CountryCode;
                    
                    Date startDate;
                    if(activevoice.Start_Date__c!=NULL)
                    {
                        startDate = activevoice.Start_Date__c;  
                    }
                    
                    //SCHEDULED DATE
                    String callerID ;
                    String Starttime;
                    
                    if(activevoice.Start_Time__c != Null && activevoice.Start_Time__c != '')
                    {
                        Starttime = activevoice.Start_Time__c; //SCHEDULED TIME
                    }
                    
                    Integer optionSchedule = 0;
                    
                    if(activevoice.Option_Schedule__c != null && activevoice.Option_Schedule__c == Commonconstant.futurecall )
                    {
                        optionSchedule = 1;
                    }
                    
                    String ScheduleFreq = activevoice.Schedule_Frequency__c; 
                    
                    String nextDateofSendingVM;
                    String onlySelectedTime;
                    
                    if(activeVoice.s2vSMSDemo__Next_Date__c!=NULL && activeVoice.s2vSMSDemo__Next_Date__c!='')
                    {
                        activeVoice.s2vSMSDemo__Next_Date__c = nextDateofSendingVM;
                    }
                    
                    if(activeVoice.s2vSMSDemo__Only_time__c!=NULL && activeVoice.s2vSMSDemo__Only_time__c!='')
                    {
                        activeVoice.s2vSMSDemo__Only_time__c = onlySelectedTime;
                    }
                    
                    //IF VOICE MAIL IS SEND IT THROUGH SPECIFIC USER
                    if(activevoice.Voice_mail_1_User__c != Null 
                       && activevoice.Voice_mail_1_User__c != '' 
                       &&activevoice.Recording_By_1_User__c != Null 
                       && activevoice.Voice_mail_1_User__c != '')
                    {
                        //voicemail
                        if(activevoice.sending_method__c == 'Voicemail')
                        {
                            User usr = [select Id,MobilePhone from User where Id =: activevoice.Voice_mail_1_User__c];
                            
                            callerId = usr.MobilePhone;
                            String singleuser = activevoice.Voice_mail_1_User__c;
                            selectedVoice = activevoice.Recording_By_1_User__c;
                            String phoneListFinal;
                            if(contskid!=NULL && contskid.size()>0)
                            {
                                
                                phoneListFinal = S2VVoiceMailSendPageController.Phonelist(contskid,ObjectName);
                                countryCode = S2VVoiceMailSendPageController.CountryCodeList(contskid, ObjectName);
                                
                                if(phoneListFinal!=NULL && phoneListFinal!='')
                                {
                                    
                                    retVal = S2VVoiceMailSendPageController.makeGeneralCallOutBatch(startDate, ObjectName, selectedVoice, phoneListFinal, countryCode, 
                                                                                                    callerId, optionSchedule, ScheduleFreq, Starttime, singleuser, 
                                                                                                    True, activevoice.Activity_History__c, 
                                                                                                    contskid, activevoice.id, activevoice.Recording_Name__c, 
                                                                                                    lstSobjRcrds, contactLookup, listofIds, s, nextDateofSendingVM, onlySelectedTime);
                                }
                                
                            }
                            
                        }
                        
                        if(activevoice.sending_method__C == 'SMS')
                        {
                            User usr = [select Id,MobilePhone from User where Id =: activevoice.Voice_mail_1_User__c];
                            
                            callerId = usr.MobilePhone; //FROM NUMBER
                            String singleuser = activevoice.Voice_mail_1_User__c;
                            String smsTemplateName = activevoice.SMS_Template_Name__c;
                            String smsTemplateBody = activevoice.SMS_Template_Body__c;
                            String phoneListFinalSMS;
                            system.debug('smsTemplateBody::::::::>>>>'+smsTemplateBody.length());
                            if(contskid!=NULL && contskid.size()>0)
                            {
                                phoneListFinalSMS = S2VVoiceMailSendPageController.PhonelistSMS(contskid,ObjectName);
                                if(phoneListFinalSMS!='' && phoneListFinalSMS!=NULL)
                                {
                                    S2VVoiceMailSendPageController.makeGeneralCallOutBatchFORSMS(smsTemplateName, smsTemplateBody, phoneListFinalSMS, Starttime, ScheduleFreq,
                                                                                                 callerId, activevoice.Activity_History__c, 
                                                                                                 activevoice.id, contskid, objectName, 
                                                                                                 useridreference, contactLookup, lstSobjRcrds, listofIds, s, nextDateofSendingVM, onlySelectedTime);
                                }
                            }
                        }
                        
                    }
                    //IF VOICEMAIL IS SEND THROUGH REFERENCE FIELD LIKE CREATED BY
                    //ELSE CONDITION STARTS HERE *********
                    else
                    {
                        if(activevoice.sending_method__c == 'Voicemail')
                        {
                            String phoneListFinal;
                            List<user> usr = [select Id,MobilePhone from User where Id In : useridfrmobj];
                            
                            if(contskid != null && contskid.size()>0 )
                            {
                                for(User usr1 : usr)
                                {
                                    List<Id> lstid = new List<Id>();
                                    useridreference = usr1.Id;
                                    callerId = usr1.MobilePhone;
                                    
                                    for(sObject obj : sobjList)
                                    {
                                        for(String cons : contskid)
                                        {
                                            if((String)obj.get(activevoice.Reference_Field__c) == usr1.Id && (String)obj.get(contactLookup) == cons)
                                            {
                                                system.debug((String)obj.get(activevoice.Reference_Field__c) == usr1.Id);
                                                system.debug((String)obj.get(contactLookup) == cons);
                                                lstid.add((String)obj.get(contactLookup));
                                            }
                                        }
                                    }
                                    
                                    if(lstid!=NULL && lstid.size()>0)
                                    {
                                        system.debug('lstid::::::'+lstid.size());
                                        phoneListFinal = S2VVoiceMailSendPageController.Phonelist(lstid,ObjectName);
                                        countryCode = S2VVoiceMailSendPageController.CountryCodeList(lstid, ObjectName);
                                        system.debug('countrycode:::::'+countryCode);
                                        selectedVoice = String.valueOf(activevoice.Recording_Name__c);
                                        
                                        if(phoneListFinal!='' && phoneListFinal!=NULL)
                                        {
                                            system.debug('phoneListFinal:::::'+phoneListFinal);
                                            retVal = S2VVoiceMailSendPageController.makeGeneralCallOutBatch(startDate, ObjectName, selectedVoice, phoneListFinal, 
                                                                                                            countryCode, callerId, optionSchedule, 
                                                                                                            ScheduleFreq, Starttime, useridreference, 
                                                                                                            True, activevoice.Activity_History__c, lstid, activevoice.id, 
                                                                                                            activevoice.Recording_Name__c, lstSobjRcrds, contactLookup, listofIds, s, nextDateofSendingVM, onlySelectedTime);
                                        }
                                    }
                                }
                            }
                        }
                        
                        if(activevoice.sending_method__C == 'SMS')
                        {
                            String phoneListFinalSMS;
                            List<user> usr = [select Id,MobilePhone from User where Id In : useridfrmobj];
                            
                            if(contskid != null && contskid.size()>0 )
                            {
                                for(User usr1 : usr)
                                {
                                    List<Id> lstid = new List<Id>();
                                    useridreference = usr1.Id;
                                    callerId = usr1.MobilePhone;
                                    
                                    for(sObject obj : sobjList)
                                    {
                                        for(String cons : contskid)
                                        {
                                            if((String)obj.get(activevoice.Reference_Field__c) == usr1.Id && (String)obj.get(contactLookup) == cons)
                                            {
                                                lstid.add((String)obj.get(contactLookup));
                                                
                                            }   
                                        }
                                    }
                                    
                                    if((lstid!=NULL && lstid.size()>0 ))
                                    {
                                        phoneListFinalSMS = S2VVoiceMailSendPageController.PhonelistSMS(lstid,ObjectName);
                                        String smsTemplateName = activevoice.SMS_Template_Name__c;
                                        String smsTemplateBody = activevoice.SMS_Template_Body__c;
                                        system.debug('smsTemplateBody::::::::>><<'+smsTemplateBody.length());
                                        if(phoneListFinalSMS != '' && phoneListFinalSMS != Null)
                                        {
                                            S2VVoiceMailSendPageController.makeGeneralCallOutBatchFORSMS(smsTemplateName, smsTemplateBody, phoneListFinalSMS, ScheduleFreq, Starttime, 
                                                                                                         callerId, activevoice.Activity_History__c, 
                                                                                                         activevoice.id, contskid, objectName, useridreference, 
                                                                                                         contactLookup, lstSobjRcrds, listofIds, s, nextDateofSendingVM, onlySelectedTime);
                                            retVal = true;
                                        }
                                    }
                                } 
                            }
                            
                        }
                    }
                    //ELSE CONDITION ENDS HERE********
                    
                    //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND LISTOF CONTACT AND LEADS
                    if(lstids != null && lstids.size()>0)
                    {
                        mptskid.put(activevoice.Id,lstids);
                        listOFtaskId.addAll(lstids);
                    }
                    
                    system.debug('0mptskid::::::'+mptskid);
                    String activevoiceid = activevoice.Id;
                    //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND RECORDINGNUMBER
                    recordnum.put(activevoice.Id,String.valueOf(activevoice.Recording_Name__c));
                    system.debug('creating task:::');
                    
                }
                //MAIN FOR LOOP ENDS HERE********
                System.debug(lstids);
            }
            
        }
        //MAIN IF CONDITION ENDS HERE**********
        return retVal;
        
    }
    
    
    //CALLOUT METHOD FOR BATCH
    public static boolean makeGeneralCallOutBatch(Date startDate, String ObjectName, String selectedVoice, String phoneListFinal,
                                                  String countryCode, String callerId, Integer optionSchedule, String ScheduleFreq,
                                                  String Starttime, String useridreference, Boolean isRecordingname, Boolean setActivityHistory,
                                                  List<Id> lstid, Id activevoiceId, String activevoiceRecording,
                                                  List<id> lstSobjRcrds, String contactLookup, List<Id> listofIds, String s, 
                                                  String nextDateofSendingVM, String onlySelectedTime)
    {   
        //CallFutureMethod(lstSobjRcrds, ObjectName);
        boolean retVal;
        List<id> lstids = new List<id>();
        Map<String, List<Id>> mptskid = new Map<String, List<Id>>();
        Map<String, String> recordnum = new Map<String, String>();
        
        Boolean b1 = S2VVoiceMailSendPageController.sendmailmethod(ObjectName,selectedVoice,phoneListFinal,countryCode,callerId,
                                                                   optionSchedule,ScheduleFreq,Starttime,useridreference,lstSobjRcrds,false);
        if(b1 == True && setActivityHistory == True)
        {
            lstids.addAll(lstid);
            retVal = true;
        } 
        else 
        {
            retVal = false;
        }
        
        if(lstids != null && lstids.size()>0)
        {
            mptskid.put(activevoiceId,lstids);
        }
        
        //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND RECORDINGNUMBER
        recordnum.put(activevoiceId,String.valueOf(activevoiceRecording));
        S2VVoiceMailSendPageController.createTasks(mptskid,ObjectName,recordnum,lstSobjRcrds,contactLookup,listofIds,s);
        return retVal;
        
    }
    
    //SMS BATCH
    public static boolean makeGeneralCallOutBatchFORSMS(String smsTemplateName, String smsTemplateBody, 
                                                        String phoneListFinalSMS, String starttime, String scheduleFreq, String callerId, Boolean setActivityHistory, 
                                                        ID activevoiceid, List<Id> lstid, String objectName, String useridreference, String contactLookup, 
                                                        List<id> lstSobjRcrds, List<Id> listofIds,String s, String nextDateofSendingVM, String onlySelectedTime)
    {
        
        boolean retVal;
        List<id> lstids = new List<id>();
        Map<String, List<Id>> mptskid = new Map<String, List<Id>>();
        Map<String, String> recordnum = new Map<String, String>();
        Id activevoice = activevoiceid;
        Boolean b1 = S2VVoiceMailSendPageController.sendSMSMethod(objectName,smsTemplateBody, smsTemplateName, phoneListFinalSMS, callerId,activevoice,lstid);
        
        if(b1 == True && setActivityHistory == True)
        {
            lstids.addAll(lstid);
            retVal = true;
        } 
        else 
        {
            retVal = false;
        }
        
        if(lstids != null && lstids.size()>0)
        {
            mptskid.put(activevoiceId,lstids);
        }
        
        //PASS MAP TO CREATE TASK METHODE TO CREATE TASKS IT CONTAINS ACTIVESCHEDULE ID AND RECORDINGNUMBER
        recordnum.put(activevoiceId,String.valueOf(smsTemplateName));
        
        S2VVoiceMailSendPageController.createTasks(mptskid,ObjectName,recordnum,lstSobjRcrds,contactLookup,listofIds,s);
        
        return retVal;
    }
    
    
    //CREATE TASK METHOD
    public static void createTasks(Map<String,List<Id>> lstCntIds,String ObjectName,map<String,string> recordnumber,List<id> whatids,String conlookups,List<Id> lstSobjRcrds,String dynamicquery){
        
        Map<String,String> descriptionmap = new Map<String,String>();
        
        //FETCHIN DESCRIPTION TO STORE IT INTO THE TASKS 
        List<Recording__c> descriptions = [select Id,Recording_Number__c,Description__c from Recording__c];
        for(Recording__c s2vrec : descriptions)
        {
            String descriptionsrecs ;
            if(s2vrec.Description__c == Null || s2vrec.Description__c == '')
            {
                descriptionsrecs = Commonconstant.none;
            } 
            else 
            {
                descriptionsrecs = s2vrec.Description__c;
            }
            descriptionmap.put(String.valueOf(s2vrec.Recording_Number__c),descriptionsrecs);
        }
        
        List<Id> conldids = new List<Id>();
        for(List<Id> lstid : lstCntIds.values())
        {
            conldids.addAll(lstid);
        }
        
        List<Task> lsttask = new List<Task>();
        
        List<Id> lstSobjcon = new List<Id>(); //CONTACT ID
        String phoneListFinal ;
        if((lstCntIds != null && lstCntIds.size() > 0 && ObjectName != Commonconstant.lead ))
        {
            List<Contact> lstCnts1 = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone 
                                      FROM Contact 
                                      WHERE Id IN: conldids];
            
            if(lstCnts1 != Null && lstCnts1.size()>0)
            {
                for(Contact cons : lstCnts1 )
                {
                    if(cons.MobilePhone != null)
                    { 
                        lstSobjcon.add(cons.Id);
                    }
                }
            }
        } 
        
        List<Lead> lstCnts = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone FROM Lead WHERE Id IN: conldids];
        
        if(lstCnts != Null && lstCnts.size()>0)
        {
            for(Lead  cons : lstCnts )
            {
                if(cons.MobilePhone != null)
                { 
                    lstSobjcon.add(cons.Id);
                }
            }
        }
        
        List<S2V_Send_Voicemail__c> listACTSCH = [SELECT id,Sending_Method__c,SMS_Template_Name__c FROM S2V_Send_Voicemail__c WHERE id =:lstCntIds.keyset()];
        
        // CREATING TASK FOR CONTACT AND LEAD TASK AND CAMPAIGNMEMBER OBJECTS
        if(conlookups == Commonconstant.idlookup || ObjectName ==  Commonconstant.lead || ObjectName ==  Commonconstant.Contact || ObjectName ==  Commonconstant.campaignMember  || ObjectName == Commonconstant.task )
        {
            for(String activsch : lstCntIds.keyset())
            {
                system.debug(' lstCntIds.keyset():::::'+ lstCntIds.keyset());
                for(Id idfiltered : lstSobjcon){ //CONTACT ID
                    if(lstCntIds.get(activsch).contains(idfiltered))
                    {
                        for(S2V_Send_Voicemail__c objACT : listACTSCH)
                        {
                            if(objACT.Sending_Method__c == 'Voicemail')
                            {
                                system.debug('activsch::::::'+activsch);
                                Task tsk = new Task();
                                tsk.Status = Commonconstant.completed;
                                tsk.Priority = Commonconstant.normal;
                                tsk.Subject = Commonconstant.autosubs;
                                tsk.WhoId = idfiltered;
                                tsk.Send_Voicemail__c = activsch;
                                tsk.Recording_number__c = Decimal.valueOf(recordnumber.get(activsch));
                                tsk.Description = descriptionmap.get(recordnumber.get(activsch));
                                tsk.ActivityDate = system.today();
                                lsttask.add(tsk);    
                            } 
                            
                            if(objACT.Sending_Method__c == 'SMS')
                            {
                                system.debug('activsch::::::'+activsch);
                                Task tsk = new Task();
                                tsk.Status = Commonconstant.completed;
                                tsk.Priority = Commonconstant.normal;
                                tsk.Subject = Commonconstant.smstitle;
                                tsk.WhoId = idfiltered;
                                tsk.Send_Voicemail__c = activsch;
                                tsk.SMS_Template_Name__c = objACT.SMS_Template_Name__c;
                                //tsk.Description = descriptionmap.get(recordnumber.get(activsch));
                                tsk.ActivityDate = system.today();
                                lsttask.add(tsk);   
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
        } 
        else if(ObjectName ==  Commonconstant.Opportunity){ //CREATING TASK FOR ALL OBJECT EXCEPT CONTACT AND LEAD
            
            List<sObject> sobjList = Database.query(dynamicquery);
            for(String activsch : lstCntIds.keyset())
            {
                for(sObject obj : sobjList)
                {
                    for(S2V_Send_Voicemail__c objACT : listACTSCH)
                    {
                        if(lstSobjcon.contains((String)obj.get(conlookups)) && lstCntIds.get(activsch).contains((String)obj.get(conlookups)))
                        {
                            if(objACT.Sending_Method__c == 'Voicemail')
                            {
                                Task tsk = new Task();
                                tsk.Status = Commonconstant.completed;
                                tsk.Priority = Commonconstant.normal;
                                tsk.Subject = Commonconstant.autosubs;
                                tsk.WhoId = (String)obj.get(conlookups);
                                tsk.Send_Voicemail__c = activsch;
                                tsk.Recording_number__c = Decimal.valueOf(recordnumber.get(activsch));
                                tsk.Description = descriptionmap.get(recordnumber.get(activsch));
                                tsk.whatId = (Id)obj.get(Commonconstant.idlookup);
                                tsk.ActivityDate = system.today();
                                lsttask.add(tsk);   
                            }
                            
                            if(objACT.Sending_Method__c == 'SMS')
                            {
                                Task tsk = new Task();
                                tsk.Status = Commonconstant.completed;
                                tsk.Priority = Commonconstant.normal;
                                tsk.Subject = Commonconstant.autosubs;
                                tsk.WhoId = (String)obj.get(conlookups);
                                tsk.Send_Voicemail__c = activsch;
                                tsk.SMS_Template_Name__c = objACT.SMS_Template_Name__c;
                                //tsk.Description = descriptionmap.get(recordnumber.get(activsch));
                                tsk.whatId = (Id)obj.get(Commonconstant.idlookup);
                                tsk.ActivityDate = system.today();
                                lsttask.add(tsk);  
                            }
                        }   
                    } 
                }
            }
        }
        
        if(lsttask != Null && lsttask.size()>0)
        {
            insert lsttask;
        }
    }
    
    //PASS ALL SELECTED VALUES IN TO S2VM SYSTEM TO MAKE VOICE MAIL OR SCHEDULE IN FUTURE 
    Global static Boolean sendmailmethod(String ObjectName,String selectedVoice,String phoneListFinal,
                                         String countryCode,String callerId,Integer optionSchedule,String ScheduleFreq,
                                         String selectedTime,String useridreference,List<id> lstSobjRcrds, Boolean isRecordingname)
    {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        IOVDCampaign ioCamp = new IOVDCampaign();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/campaign/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('POST');  
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        Integer hours = dt.hour();
        
        
        // s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        IORecording mRec = IOVoicemailDropBackend.getVoiceMessagesList1(setting.s2vSMSDemo__username__c ,setting.s2vSMSDemo__password__c,setting.s2vSMSDemo__url__c );
        
        if(mRec.isSuccess== true)
        {   
            for (IORecording.RObject r : mRec.objects)
            {
                if( r.recording_number == selectedVoice && r.saleslforce_user_id == useridreference)
                {
                    selectedVoice = r.name;  
                } 
            }
        }
        
        s2vSMSDemo__Countrycode__c code = [select Name,s2vSMSDemo__Active__c from s2vSMSDemo__Countrycode__c where s2vSMSDemo__Active__c =: True limit 1];
        String countrycodeCS = '';
        if(code.Name == 'CA-US')
        {
            countrycodeCS = 'CA';
        } 
        else 
        {
            countrycodeCS = code.Name;
        }
        
        System.debug(countrycodeCS);
        
        //SENDING VOICE MAIL TO THOSE CONTACTS WHICH CONTAINS MOBILE NUMBERS
        
        if((countryCode!=null && countryCode!=''))
        {
            system.debug('countryCode:::::'+countryCode);
            if(selectedTime == NULL)
            {
                system.debug('without schedule data');
                req.setBody('name='+ObjectName + system.now() +'&audio='+selectedVoice+'&phone_list='+phoneListFinal+'&phonecode='+countryCode+'&callerID='+callerID+'&option_schedule='+optionSchedule);
            } 
            else 
            {
                system.debug('with schedule data');
                req.setBody('name='+ObjectName + system.now() +'&audio='+selectedVoice+'&phone_list='+phoneListFinal+'&phonecode='+countryCode+'&callerID='+callerID+'&option_schedule='+optionSchedule+'&schedule_frequency='+ScheduleFreq+'&schedule_date_to_start='+selectedTime);   
            }
        } 
        
        if(countryCode==null || countryCode =='')
        { //IF CONDITION FOR CA - US COUNTRY CODE
            system.debug('country code custom setting');
            if(optionSchedule == 0)
            {
                system.debug('without schedule data');
                req.setBody('name='+ObjectName + system.now() +'&audio='+selectedVoice+'&phone_list='+phoneListFinal+'&phonecode='+countryCode+'&callerID='+callerID+'&option_schedule='+optionSchedule);
            } 
            else 
            {
                system.debug('with schedule data');
                req.setBody('name='+ObjectName + system.now() +'&audio='+selectedVoice+'&phone_list='+phoneListFinal+'&phonecode='+countryCodeCS+'&callerID='+callerID+'&option_schedule='+optionSchedule+'&schedule_frequency='+ScheduleFreq+'&schedule_date_to_start='+selectedTime);   
            }
        } 
        
        System.debug('all s2v data:::::::::::::::::::::::-------------------'+objectName+' '+selectedVoice+' '+phoneListFinal+' '+countryCode+' '+callerID+' '+optionSchedule+' '+ScheduleFreq+' '+selectedTime);   
        system.debug('req::::::::'+req.getBody());
        HttpResponse res = h.send(req);
        system.debug('AK response body ---> ' + res.getBody());
        ioCamp = (IOVDCampaign)JSON.deserialize(res.getBody(), IOVDCampaign.class); 
        system.debug('iOcamp voicemail:::'+ioCamp);
        Boolean isSusccess ;
        if(res.getStatusCode() == 200)
        {
            ioCamp.isSuccess = true;
            isSusccess = True;
            
        }
        else
        {
            ioCamp.isSuccess = false;
            isSusccess = False;
        }
        
        //STORING RESPONSE IN ERROR FIELD (24/10/2018)
        List <Future_Voicemails__c> fvm = [Select ID,Record_Id__c from Future_Voicemails__c where Record_Id__c IN: lstSobjRcrds ];
        list <Future_Voicemails__c> fvmup = new list <Future_Voicemails__c>();
        if(fvm != null && fvm.size() > 0)
        {
            for(Future_Voicemails__c fv : fvm)
            {
                fv.Error__c =  res.getBody();
                fvmup.add(fv);
            }
            
            if(fvmup!=null && fvmup.size()>0)
            {
                try{
                    update fvmup;
                    system.debug('success:::::::::::'+fvmup);
                }
                catch(Exception e)
                {
                    system.debug('fail:::::::::::'+e);
                    system.debug('fail:::::::::::'+e.getLineNumber());
                    system.debug('fail:::::::::::'+e.getMessage());
                }
            }
        }
        system.debug('isSuccess::::::::'+isSusccess);
        return isSusccess;
    }
    
    
    //SMS REQUEST METHOD
    
    Global static Boolean sendSMSMethod (String objectName, String selectedTemplate,String TemplateName,String phoneListFinalSMS,String FromNumber, Id activeVoice, List<Id> listOfContactId)
    {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        IOVDCampaign ioCamp = new IOVDCampaign();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/message/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('POST'); 
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        Integer hours = dt.hour();
        
        Schema.SObjectType newObjectName = Schema.getGlobalDescribe().get(objectName);
        Sobject genericObject = newObjectName.newSObject();
        
        IOSMSHistory smsRec = IOVoicemailDropBackend.getSMS(setting.s2vSMSDemo__username__c ,setting.s2vSMSDemo__password__c,setting.s2vSMSDemo__url__c );
        system.debug('smsRec:::::'+smsRec.isSuccess);
        
        Id activeScheduleid = activevoice;
        String smstemplateReplacedBody = replaceMergeFields(genericObject, selectedTemplate,activeScheduleid,listOfContactId);
        req.setBody('from_number='+FromNumber+'&to_number='+phoneListFinalSMS+'&message='+smstemplateReplacedBody);
        
        System.debug('all s2v data:::::::::::::::::::::::-------------------'+FromNumber+' '+phoneListFinalSMS+' '+selectedTemplate);   
        system.debug('req:::::'+req);
        
        HttpResponse res = h.send(req);
        system.debug('AK response body ---> ' + res.getBody());
        ioCamp = (IOVDCampaign)JSON.deserialize(res.getBody(), IOVDCampaign.class);
        system.debug('ioCamp::::'+ioCamp);
        Boolean isSusccess ;
        system.debug('res.getStatusCode():::'+res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            ioCamp.isSuccess = true;
            isSusccess = True;
        }
        else
        {
            ioCamp.isSuccess = false;
            isSusccess = False;
        }
        return isSusccess;
        
    }
    
    //SENDING MESSAGE SINGLE FROM CONTACT OR LEAD
    Global static Boolean sendSMSMethodSingle (String objectName, String fromNumber, String toNumber, String message, id recordid)
    {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        IOVDCampaign ioCamp = new IOVDCampaign();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/message/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('POST'); 
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        Integer hours = dt.hour();
        
        IOSMSHistory smsRec = IOVoicemailDropBackend.getSMS(setting.s2vSMSDemo__username__c ,setting.s2vSMSDemo__password__c,setting.s2vSMSDemo__url__c );
        system.debug('smsRec:::::'+smsRec.isSuccess);
        
        Schema.SObjectType newObjectName = Schema.getGlobalDescribe().get(objectName);
        Sobject genericObject = newObjectName.newSObject();
        
        String smstemplateReplacedBody = replaceMergeFieldsforSingleSMS (genericObject, message,recordid);
        
        if(fromNumber.startsWith('0'))
        {
            fromNumber = fromNumber.replaceFirst('0', '61');
        }
        
        req.setBody('from_number='+FromNumber+'&to_number='+toNumber+'&message='+smstemplateReplacedBody);
        
        System.debug('all s2v data:::::::::::::::::::::::-------------------'+FromNumber+' '+toNumber+' '+smstemplateReplacedBody);   
        system.debug('req:::::'+req);
        
        HttpResponse res = h.send(req);
        system.debug('AK response body ---> ' + res.getBody());
        ioCamp = (IOVDCampaign)JSON.deserialize(res.getBody(), IOVDCampaign.class);
        system.debug('ioCamp::::'+ioCamp);
        Boolean isSusccess ;
        system.debug('res.getStatusCode():::'+res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            ioCamp.isSuccess = true;
            isSusccess = True;
        }
        else
        {
            ioCamp.isSuccess = false;
            isSusccess = False;
        }
        return isSusccess;
    }
    
    //SEND SMS 2 WAY
    Global static Boolean sendSMSMethodSingle2Way (String objectName, String fromNumber, String toNumber, String message, id recordid)
    {
        s2vSMSDemo__S2V_Settings1__c setting =  s2vSMSDemo__S2V_Settings1__c.getInstance(userInfo.getOrganizationId());//get custom settings
        
        IOVDCampaign ioCamp = new IOVDCampaign();
        Http h = new Http();            
        HttpRequest req = new HttpRequest(); 
        String username = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__username__c;
        String password = s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__password__c;
        Blob headerValue = Blob.valueOf( username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        req.setEndpoint(s2vSMSDemo__S2V_Settings1__c.getInstance().s2vSMSDemo__url__c+'/api/v1/message/');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', '*/*');       
        req.setMethod('POST'); 
        
        TimeZone tz = UserInfo.getTimeZone();
        DateTime dt = Datetime.now();
        Integer hours = dt.hour();
        
        IOSMSHistory smsRec = IOVoicemailDropBackend.getSMS(setting.s2vSMSDemo__username__c ,setting.s2vSMSDemo__password__c,setting.s2vSMSDemo__url__c );
        system.debug('smsRec:::::'+smsRec.isSuccess);
        
        
        req.setBody('from_number='+FromNumber+'&to_number='+toNumber+'&message='+message);
        
        System.debug('all s2v data:::::::::::::::::::::::-------------------'+FromNumber+' '+toNumber+' '+message);   
        system.debug('req:::::'+req);
        
        HttpResponse res = h.send(req);
        system.debug('AK response body ---> ' + res.getBody());
        ioCamp = (IOVDCampaign)JSON.deserialize(res.getBody(), IOVDCampaign.class);
        system.debug('ioCamp::::'+ioCamp);
        Boolean isSusccess ;
        system.debug('res.getStatusCode():::'+res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            ioCamp.isSuccess = true;
            isSusccess = True;
            
        }
        else
        {
            ioCamp.isSuccess = false;
            isSusccess = False;
        }
        return isSusccess;
        
    }
    
    //GETING ALL MOBILE NUMBERS OF INSERTED CONTACT AND SEND TO THE S2V SYSTEM TO MAKE VOICE MAIL
    Global static String Phonelist(List<Id> lstCntIds,String ObjectName)
    {
        List<String> phoneList =new List<String>();
        String phoneListFinal ;
        
        if((lstCntIds != null && lstCntIds.size() > 0 && ObjectName != 'Lead' ))
        {
            //FILTERING CONTACTS WHICH CONTAINS MOBILENUMBERS
            List<Contact> lstCnts1 = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone,MailingCountry 
                                      FROM Contact 
                                      WHERE Id IN: lstCntIds];
            
            if(lstCnts1 != Null && lstCnts1.size()>0)
            {
                for(Contact cons : lstCnts1 )
                {
                    if(cons.MobilePhone != null)
                    { 
                        phoneList.add(cons.firstName+' ' + cons.LastName+' ' + cons.MobilePhone.deleteWhitespace());
                    }
                }
            }
            
            if(phoneList != Null)
            {
                phoneListFinal = string.join(phoneList,',');
                phoneListFinal = phoneListFinal.replace('(','');
                phoneListFinal = phoneListFinal.replace(')','');
                phoneListFinal = phoneListFinal.replace('-','');
            }
            
        } 
        
        //FILTERING lEADS WHICH CONTAINS MOBILENUMBERS
        List<Lead> lstCnts = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone
                              FROM Lead 
                              WHERE Id IN: lstCntIds];
        
        if(lstCnts != Null && lstCnts.size()>0)
        {
            for(Lead  cons : lstCnts )
            {
                if(cons.MobilePhone != null)
                { 
                    phoneList.add(cons.firstName+' ' + cons.LastName+' ' + cons.MobilePhone.deleteWhitespace());
                }
            }
        }
        
        if(phoneList != Null)
        {
            phoneListFinal = string.join(phoneList,',');
            phoneListFinal = phoneListFinal.replace('(','');
            phoneListFinal = phoneListFinal.replace(')','');
            phoneListFinal = phoneListFinal.replace('-','');
        }
        
        //RETURNING FINAL LIST OF MOBILENUMBERS TO SEND A VOICE MAIL
        return phoneListFinal;
    }
    
    //TEMPORARY
    private static Set<String> fields(Schema.sObjectType t) 
    {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectField> fields = t.getDescribe().fields.getMap();
        return fields.keySet();
    }
    
    // REPLACE MERGE FIELDS FOR SINGLE SMS SEND FROM CONTACT OR LEAD
    public Static String replaceMergeFieldsforSingleSMS (sObject genericObject, String message, String recordid){
        
        String SobjectApiName = String.valueof(genericObject);
        String sobjectName = '';
        if(SobjectApiName!=NULL)
        {
            sobjectName = SobjectApiName.replace(':{}','');   
        }
        
        String fieldsinquery ='';
        String key = '';
        String fieldsused = '';
        String fieldneedstobereplaced = '';
        
        for(String objString : fields((genericObject.getSObjectType())))
        {
            key = '{!' + objString + '}';
            fieldsused = objString;
            if(message.containsIgnoreCase(key))
            {
                fieldsinquery+= objString+',';
                
            }   
        }
        
        String finalField = fieldsinquery.removeEnd(',');
        String query = '';
        fieldneedstobereplaced = '{!' +finalField+ '}';
        
        if(finalField!=NULL && finalField!='' && sobjectName!=NULL && recordid!=NULL)
        {
            query = 'Select '+ finalField + '  from ' +sobjectName+ ' Where id='+ '\''+String.escapeSingleQuotes(recordid)+ '\'';
            List<sObject> finalQuery = Database.query(query);
            
            for(sObject objectNew: finalQuery)
            {
                String newValues = (String)objectNew.get(finalField);
                message = message.replace(fieldneedstobereplaced, newValues);
            }
            system.debug('message::::::::::'+message);
        }
        
        
        return message;
    }
    
    //REPLACE SMS TEMPLATE DATA
    public static String replaceMergeFields(sObject objectName, String SMSTemplateBody, Id activeScheduleId, List<Id> listOfContactId)
    {
        String SobjectApiName = String.valueof(objectName);
        String sobjectName = '';
        if(SobjectApiName!=NULL)
        {
            sobjectName = SobjectApiName.replace(':{}','');   
        }
        String sendingObject;
        
        for(S2V_Send_Voicemail__c objSendVoicemail : [SELECT id,SMS_Object__c,Object_Name__c FROM S2V_Send_Voicemail__c Where id =:activeScheduleId]){
            if(objSendVoicemail.SMS_Object__c!=NULL)
            {
                sendingObject = objSendVoicemail.SMS_Object__c;
            }
            else 
            {
                sendingObject = objSendVoicemail.Object_Name__c;
            }
        }
        
        String fieldsinquery ='';
        String key = '';
        String fieldsused = '';
        String fieldneedstobereplaced = '';
        
        for(String objString : fields((objectName.getSObjectType())))
        {
            key = '{!' + objString + '}';
            fieldsused = objString;
            if(SMSTemplateBody.containsIgnoreCase(key))
            {
                fieldsinquery+= objString+',';
            }   
        }
        
        String finalField = fieldsinquery.removeEnd(',');
        fieldneedstobereplaced = '{!' +finalField+ '}';
        String contactId = listOfContactId[0];
        if(finalField!=NULL && finalField!='' && sendingObject!=NULL && contactId!=NULL)
        {
            String query = 'Select '+ finalField + '  from ' +sendingObject+ ' Where id='+ '\''+String.escapeSingleQuotes(contactId)+ '\'';
            List<sObject> finalQuery = Database.query(query);
            List<String> lookupfieldsvalues = new List<String>();
            
            for(sObject objectNew: finalQuery)
            {
                String newValues = (String)objectNew.get(finalField);
                SMSTemplateBody = SMSTemplateBody.replace(fieldneedstobereplaced, newValues);
            } 
        }
        //system.debug('finalSMSTemplateBody::::::::::::'+SMSTemplateBody);
        return SMSTemplateBody;
    }
    
    //
    Global static String PhonelistSMS(List<Id> lstCntIds,String ObjectName )
    {
        List<String> phoneListSMS =new List<String>();
        String phoneListFinalSMS ;
        if((lstCntIds != null && lstCntIds.size() > 0 && ObjectName != 'Lead' ))
        {
            //FILTERING CONTACTS WHICH CONTAINS MOBILENUMBERS
            List<Contact> lstCnts1 = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone,MailingCountry 
                                      FROM Contact 
                                      WHERE Id IN: lstCntIds];
            
            if(lstCnts1 != Null && lstCnts1.size()>0)
            {
                for(Contact cons : lstCnts1 )
                {
                    if(cons.MobilePhone != null)
                    { 
                        phoneListSMS.add(cons.MobilePhone.deleteWhitespace());
                    }
                }
            }
            
            if(phoneListSMS != Null)
            {
                phoneListFinalSMS = string.join(phoneListSMS,',');
                phoneListFinalSMS = phoneListFinalSMS.replace('(','');
                phoneListFinalSMS = phoneListFinalSMS.replace(')','');
                phoneListFinalSMS = phoneListFinalSMS.replace('-','');
            }
            
        } 
        
        //FILTERING lEADS WHICH CONTAINS MOBILENUMBERS
        List<Lead> lstCnts = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone
                              FROM Lead 
                              WHERE Id IN: lstCntIds];
        
        if(lstCnts != Null && lstCnts.size()>0)
        {
            for(Lead  cons : lstCnts)
            {
                if(cons.MobilePhone != null)
                { 
                    phoneListSMS.add(cons.MobilePhone.deleteWhitespace());
                }
            }
        }
        
        if(phoneListSMS != Null)
        {
            phoneListFinalSMS = string.join(phoneListSMS,',');
            phoneListFinalSMS = phoneListFinalSMS.replace('(','');
            phoneListFinalSMS = phoneListFinalSMS.replace(')','');
            phoneListFinalSMS = phoneListFinalSMS.replace('-','');
        }
        //RETURNING FINAL LIST OF MOBILENUMBERS TO SEND A VOICE MAIL
        return phoneListFinalSMS;
    }
    
    
    //GETING ALL COUNTRY CODES OF INSERTED CONTACT AND SEND TO THE S2V SYSTEM TO MAKE VOICE MAIL
    Global static String CountryCodeList(List<Id> lstCntIds,String ObjectName)
    {
        List<String> CountryCodeList =new List<String>();
        String CountryCode;
        if((lstCntIds != null && lstCntIds.size() > 0 && ObjectName != 'Lead' ))
        {
            //FILTERING CONTACTS WHICH CONTAINS MOBILENUMBERS
            List<Contact> lstCnts1 = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone,MailingCountry 
                                      FROM Contact 
                                      WHERE Id IN: lstCntIds];
            
            if(lstCnts1 != Null && lstCnts1.size()>0)
            {
                for(Contact cons : lstCnts1)
                {
                    if(cons.MailingCountry != null)
                    { 
                        CountryCodeList.add(cons.MailingCountry);
                    }
                }
            }
            
            if(CountryCodeList != Null)
            {
                CountryCode = string.join(CountryCodeList,',');
                CountryCode = CountryCode.replace('(','');
                CountryCode = CountryCode.replace(')','');
            }
            
        } 
        
        
        //FILTERING lEADS WHICH CONTAINS MOBILENUMBERS
        List<Lead> lstCnts = [SELECT Id,FirstName, LastName, Email, Phone, MobilePhone,Country 
                              FROM Lead 
                              WHERE Id IN: lstCntIds];
        
        if(lstCnts != Null && lstCnts.size()>0)
        {
            for(Lead  cons : lstCnts)
            {
                if(cons.Country != null)
                { 
                    CountryCodeList.add(cons.Country);
                }
            }
        }
        
        if(countryCodeList!=null && countryCodeList.size()>0)
        {
            countryCode = string.join(CountryCodeList,',');
            CountryCode = CountryCode.replace('(','');
            CountryCode = CountryCode.replace(')','');
            //CountryCode = CountryCode.replace('-','');
        }
        
        //HANDLING COUNTRY CODE IN BACKEND AS IT'S API IS NOT SUPPORTING US AS A COUNTRY CODE
        //SO CHANGING COUNTRY CODE FROM US TO CA ONLY IN BACKEND IT WILL NOT AFFECT IN SALESFORCE DATABASE
        if(countryCode == 'US')
        {
            countryCode = 'CA';
        }
        
        if(countryCode == 'CA-US')
        {
            countryCode = 'CA';
        }
        
        //RETURNING FINAL LIST OF MOBILENUMBERS TO SEND A VOICE MAIL
        return CountryCode;
        
    }
    
    //DROP DOWN TO GET ALL AVAILABLE TIME WHEN USER CAN SCHEDULE VOICE MIL FOR FUTURE CALL
    public List<SelectOption> getAllAvailableTimes()
    {
        List<SelectOption> result = new List<SelectOption>();
        result.add(new selectoption('09:00:00','09:00'));        
        result.add(new selectoption('10:00:00','10:00'));
        result.add(new selectoption('11:00:00','11:00'));
        result.add(new selectoption('12:00:00','12:00'));
        result.add(new selectoption('13:00:00','13:00'));
        result.add(new selectoption('14:00:00','14:00'));
        result.add(new selectoption('15:00:00','15:00'));
        result.add(new selectoption('16:00:00','16:00'));
        result.add(new selectoption('17:00:00','17:00'));
        return result;      
    }
    
    //FETCHING LOOKUP FIELD OF CONTACT OR LEAD FOR OBJECT LIKE OPPORTUNITY AND TASK
    public List<SelectOption> getAlllookupfields()
    {
        List<SelectOption> result = new List<SelectOption>();
        result.clear();
        result.add(new selectoption('0','--None--'));
        if(selectedObject != Null && selectedObject != '0' && fieldsneed != NUll && fieldsneed != '0' && selectedObject != 'Contact' && selectedObject != 'Lead')
        {
            map<string, Map<String, Schema.SObjectField>> objectFieldsMap = new map<string, Map<String, Schema.SObjectField>>(); //Object field schema map
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            for(Schema.SObjectField fld :objectFields.values()){
                schema.describeFieldResult dfield = fld.getDescribe();
                string fldType = string.valueOf(dfield.getType());   
                if (fldType == 'REFERENCE')
                { // LOOKUP FIELD!
                    List<Schema.sObjectType> temp = fld.getDescribe().getReferenceTo();
                    for(Schema.sObjectType s : temp)
                    {
                        if(String.valueOf(s) == fieldsneed )
                        {
                            result.add(new selectoption(fld.getDescribe().getName(),fld.getDescribe().getLabel())); 
                        }
                    }
                }
            }
        }
        return result;      
    }
    
    //GET 10 SMS TEMPLATES FROM THE SMS_Template__c OBJECT
    public PageReference AllSmsTemplate()
    {
        try
        {
            SMS_Template__c objSMSTemplate = [Select id,Template_Name__c,Template_Body__c from SMS_Template__c where id=:smstemplateID limit 1];
            smstemplateName = objSMSTemplate.Template_Name__c;
            smstemplateBody = objSMSTemplate.Template_Body__c;
            //system.debug('smstemplateID::::'+smstemplateID);
            //system.debug('smstemplateBody:::::'+smstemplateBody);
            return null;            
        }
        catch(QueryException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,'Error');
            ApexPages.addMessage(myMsg); 
            return null;
        }
        
    }
    
    //GET SMS TEMPLATES
    public List<SelectOption> getSmsTemplates()
    {
        try
        { 
            
            List<SelectOption> options = new List<SelectOption>();
            List<SMS_Template__c> objListSMStemplates = [Select id,Template_Name__c,Template_Body__c from SMS_Template__c where Template_Name__c!=NULL];
            
            options.add(new SelectOption('none','------Select the SMS Template----------'));
            if((objListSMStemplates!=null) && (!objListSMStemplates.isEmpty())){
                for(SMS_Template__c objEmailTemp : objListSMStemplates)
                {
                    options.add(new SelectOption(objEmailTemp.id,objEmailTemp.Template_Name__c));
                    //system.debug('7th Debug Email templates:'+options);
                }
            }
            return options;
        }
        catch(QueryException e)
        {
            ApexPages.addMessages(e);
            return null;  
        }
        
    }
    
    public List<SelectOption> getRadios() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Voicemail','Voicemail'));
        options.add(new SelectOption('SMS','SMS'));
        return options;
    }
    
    public String getRadioValues()
    {
        return radioValues;
    }
    
    public void setRadioValues (String radioValues)
    {
        this.radioValues =  radioValues;
    } 
    
    public PageReference actionSave()
    {
        if (radioValues == 'Voicemail')
        {
            voicemailvalue = true;
            sms = false;
        }
        
        if(radioValues == 'SMS') 
        {
            voicemailvalue = False;
            sms = true;
        }
        return null;
    }
    
    //GETTING 1 TO 10 RECORDING NUMBER TO IDENTIFY RECORDING NAME AND SEND THAT RECORDING AS A VOICE MAIL
    public List<SelectOption> getAllrecornumber()
    {
        List<Recording__c> rec = [select Id,Recording_Number__c,Description__c from Recording__c];
        List<SelectOption> result = new List<SelectOption>();
        result.clear();
        result.add(new selectoption('0','--None--'));
        
        for(Recording__c rec1 : rec)
        {
            if(rec1.Description__c != Null && rec1.Description__c != '')
            {
                result.add(new selectoption(String.valueOf(rec1.Recording_Number__c),rec1.Description__c));
            }
        }
        if(result!=NULL)
        {
            return result;          
        }
        return null;
    }
    
    public Static void createCampaign(String tempQuery,String fldName,String objName,String voiceName,String callerId,Integer optionSchedule,Date strtDate,String scdleFreq)
    {
        
    }
    
}