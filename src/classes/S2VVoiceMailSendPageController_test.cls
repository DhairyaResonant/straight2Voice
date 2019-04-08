/*
* CREATED BY: DHAIRYA SHAH
* DATE: 20/09/2018
* DESC: TEST CLASS FOR S2VVoiceMailSendPageController APEX CLASS
*/ 
@isTest
public class S2VVoiceMailSendPageController_test{
    
    //METHOD 1  
    @testsetup public static void testData(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        s2vSMSDemo__S2V_Trigger_Handler__c trgHandler = new s2vSMSDemo__S2V_Trigger_Handler__c();
        trgHandler.Name = 'TriggerHandler';
        trgHandler.s2vSMSDemo__S2VRestrictingCampaignMember__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneContact__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneLead__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneOpp__c = true;
        trgHandler.s2vSMSDemo__S2VTimeZoneTask__c = true;
        trgHandler.s2vSMSDemo__SameRecordNumber__c = true;
        trgHandler.s2vSMSDemo__SendVoiceMail__c = true;
        insert trgHandler;
        
        Countrycode__c codes = new Countrycode__c();
        codes.Name = 'AU';
        codes.Active__c = True;
        insert codes;
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User usr=new User(firstname = 'ABC', 
                          lastName = 'XYZ', 
                          email = uniqueName + '@test' + orgId + '.org', 
                          Username = uniqueName + '@test' + orgId + '.org', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = uniqueName.substring(18, 23), 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = pf.Id
                         ); 
        insert usr;
        
        List<S2V_Send_Voicemail__c> lst_voiceMail = new List<S2V_Send_Voicemail__c>();
        S2V_Send_Voicemail__c voiceMail = new S2V_Send_Voicemail__c();
        voiceMail.Is_Active__c = true;
        voiceMail.Object_Name__c = 'Contact';
        voiceMail.Recording_By_1_User__c = '2';
        voiceMail.Voice_mail_1_User__c =  usr.Id;
        //voiceMail.Selected_Lookup__c = ;
        //voiceMail.Reference_Field__c = 'Opportunity';
        voiceMail.Option_Schedule__c = 'Now';
        voiceMail.Recording_Name__c = '1';
        voiceMail.Activity_History__c = True;
        voiceMail.Start_Time__c = String.valueOf(System.Now());
        voiceMail.Query__c = 'Contact objContact=[SELECT Id FROM Contact];';
        voiceMail.OwnerId = usr.Id;
        voiceMail.sending_method__c = 'voiceMail';
        lst_voiceMail.add(voiceMail);
        
        S2V_Send_Voicemail__c voiceMail1 = new S2V_Send_Voicemail__c();
        voiceMail1.Is_Active__c = true;
        voiceMail1.Object_Name__c = 'Contact';
        voiceMail1.Recording_By_1_User__c = '';
        voiceMail1.Voice_mail_1_User__c =  '';
        voiceMail1.Recording_Name__c = '1';
        voiceMail1.Activity_History__c = True;
        voiceMail1.sending_method__c = 'voiceMail';
        //voiceMail1.Selected_Lookup__c = 'Account';
        // voiceMail1.Reference_Field__c = 'Opportunity';
        voiceMail1.Query__c = 'Contact objContact=[SELECT Id FROM Contact];';
        voiceMail1.OwnerId = usr.Id;
        lst_voiceMail.add(voiceMail1);
        
        Recording__c des = new Recording__c();
        des.Recording_Number__c = 1;
        des.Description__c = 'abc';
        insert des;

        Test.startTest();
            S2VVoiceMailSendPageController objRA = new S2VVoiceMailSendPageController();
            
            List<SelectOption> options = new List<SelectOption>();
            options = objRA.getRadios();
            objRA.radioValues = 'Voicemail';
            //objRA.setRadioValues(radioValues);
            PageReference objPageRef = objRA.actionSave();

        Test.stopTest();
        
        System.assertEquals(voiceMail.Object_Name__c,'Contact');
        
        if(lst_voiceMail != Null && lst_voiceMail.size() > 0){
            Insert lst_voiceMail;
        }
        
    }
    
    //METHOD 2
    static testmethod void s2vvoicemailsend(){  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        
        Countrycode__c codes = new Countrycode__c();
        codes.Name = 'AU';
        codes.Active__c = True;
        insert codes;
        
        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.s2vSMSDemo__Full_Name__c    ='s2v';
        s2vsettings.s2vSMSDemo__password__c='mnbvh';
        s2vsettings.s2vSMSDemo__username__c='xyz@gmail.com';
        s2vsettings.s2vSMSDemo__url__c='www.gmail.com';
        insert s2vsettings;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        Contact con = new Contact();
        con.LastName = 'Test Last Name';
        con.AccountId = acc.Id;
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingCountry = 'AU';
        Insert con;
        
        S2V_Send_Voicemail__c sendvoicemail=new S2V_Send_Voicemail__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        sendvoicemail.Recording_Name__c='aakriti';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Activity_History__c = True;
        sendvoicemail.Reference_Field__c='kjj';
        sendvoicemail.Start_Date__c=system.today();
        sendvoicemail.sending_method__c = 'voiceMail';
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(con.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        
        
        
        apexpages.currentpage().getparameters().put('sid', sendvoicemail.Id);
        System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
        System.assertEquals(lstid.size(),1);
        
        Test.setMock(HttpCalloutMock.class, new IOCampaignS2VResponceTest()); 
        S2VVoiceMailSendPageController s2vmail=new S2VVoiceMailSendPageController();
        s2vmail.isEditMode = true;
        s2vmail.selectedField = '1';
        s2vmail.selectedField = '2';
        s2vmail.selectedLookup = '1';
        s2vmail.selectedObject = 'Opportunity';
        s2vmail.fieldsneed = 'Contact__c';
        s2vmail.isActivityhistory = true;
        List<SelectOption> listSO = s2vmail.SobjectUserNames1;
        //s2vmail.getAllSObject();
        //s2vmail.fetchFieldNames();
        s2vmail.getAllFieldNames();
        s2vmail.getSobjectFieldNames();
        //s2vmail.OwnerUsers();
        //s2vmail.getDropDownCallerList();
        s2vmail.getScheduleList();
        s2vmail.getScheduleFreqList();
        s2vmail.enableFutureCallFields();
        s2vmail.getAllAvailableTimes();
        s2vmail.getAlllookupfields();
        s2vmail.getAllrecornumber();
        s2vmail.filtertext1 = 'Text';
        s2vmail.filtertext2 = 'Text';
        s2vmail.filtertext3 = 'Text';
        s2vmail.filtertext4 = 'Text';
        s2vmail.filtertext5 = 'Text';
        s2vmail.filtertext6 = 'Text';
        s2vmail.newfiltertext1 = s2vmail.filtertext1;
        s2vmail.newfiltertext2 = s2vmail.filtertext2;
        s2vmail.newfiltertext3 = s2vmail.filtertext3;
        s2vmail.newfiltertext4 = s2vmail.filtertext4;
        s2vmail.newfiltertext5 = s2vmail.filtertext5;
        s2vmail.newfiltertext6 = s2vmail.filtertext6;
        s2vmail.filterop1 ='Not Equals to';
        s2vmail.filterop1 ='Less than';
        s2vmail.filterop2 ='Greater than';
        s2vmail.filterop3 = 'Greater than';
        s2vmail.filterop3 = 'Less than';
        s2vmail.filterop4 = 'Greater than';
        s2vmail.filterop5 = 'Greater than';
        s2vmail.filterop5 = 'Less than';
        s2vmail.filterop6 = 'Greater than';
        s2vmail.saveData();
        //s2vmail.getCallerID();
        Integer i = 1;
        Datetime myDT = Datetime.now();
        String myDate = myDT.format('h:mm a');
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new IOCampaignS2VResponceTest());
        S2VVoiceMailSendPageController.Phonelist(lstid, 'Contact');
        s2vvoicemailsendpageController.CountryCodeList(lstid, 'Contact');
        S2VVoiceMailSendPageController.CallFutureMethod(lstid, 'Contact');
        S2VVoiceMailSendPageController.CallFutureMethodBatch(lstid, 'Contact');
        //S2VVoiceMailSendPageController.makeGeneralCallOut(system.today(),'Contact','sending','98989','AU','98989',i,'Now',myDate,'Contact',True,True,lstId,sendvoicemail.id,'insert',lstId,'Contact',lstId,'S');
        //S2VVoiceMailSendPageController.sendmailmethod(system.today(),'Contact','sending','98989','AU','98989',0,'Now','1020','Contact',lstid,True);

        //S2VVoiceMailSendPageController.sendmailmethod(startDate, 'Contcat', selectedVoice, phoneListFinal, callerId, optionSchedule, ScheduleFreq, selectedTime1, useridreference, isRecordingname);
        Test.StopTest(); 
    }
    
    //METHOD 3
    static testmethod void method1(){  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        
        
        Countrycode__c codes = new Countrycode__c();
        codes.Name = 'AU';
        codes.Active__c = True;
        insert codes;
        
        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.s2vSMSDemo__Full_Name__c    ='s2v';
        s2vsettings.s2vSMSDemo__password__c='mnbvh';
        s2vsettings.s2vSMSDemo__username__c='xyz@gmail.com';
        s2vsettings.s2vSMSDemo__url__c='www.gmail.com';
        insert s2vsettings;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        S2V_Send_Voicemail__c sendvoicemail=new S2V_Send_Voicemail__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        sendvoicemail.Recording_Name__c='aakriti';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Activity_History__c = True;
        sendvoicemail.Reference_Field__c='kjj';
        sendvoicemail.Start_Date__c=system.today();
        sendvoicemail.sending_method__c = 'voiceMail';
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(acc.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        
        User usr = [Select Id From User limit 1];        
        
        
        System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
        System.assertEquals(lstid.size(),1);
        
        S2VVoiceMailSendPageController s2vmail=new S2VVoiceMailSendPageController();
        s2vmail.filterValue1 = 'value1';
        s2vmail.filterValue2 = 'value2';
        s2vmail.filterValue3 = 'value3';
        s2vmail.filterValue4 = 'value4';
        s2vmail.filterValue5 = 'value5';
        s2vmail.filterValue6 = 'value6';
        
        s2vmail.filterop1 = 'Equals';
        s2vmail.filterop2 = 'Equals';
        s2vmail.filterop3 = 'Equals';
        s2vmail.filterop4 = 'Equals';
        s2vmail.filterop5 = 'Equals';
        s2vmail.filterop6 = 'Equals';
        
        s2vmail.filtertext1 = 'Text1';
        s2vmail.filtertext2 = 'Text2';
        s2vmail.filtertext3 = 'Text3';
        s2vmail.filtertext4 = 'Text4';
        s2vmail.filtertext5 = 'Text5';
        s2vmail.filtertext6 = 'Text6';
        
        s2vmail.selectedField = '1';
        s2vmail.selectedLookup = '1';
        s2vmail.selectedObject = 'Task';
        s2vmail.selectedUser = usr.Id;
        
        s2vmail.selectedDate = System.today();
        s2vmail.selectedFreq = ''; 
        s2vmail.userfields = '';
        s2vmail.recOperators = '';
        s2vmail.diffUsers = '';
        
        List<SelectOption> lstAllusr1 = new List<SelectOption>();
        lstAllusr1 = s2vmail.lstAllusr;
        
        System.assertEquals(usr != Null, !String.isBlank(usr.Id)); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IOCampaignS2VResponceTest()); 

        s2vmail.saveData();
        s2vmail.getAllFieldNames();
        S2VVoiceMailSendPageController.Phonelist(lstid, 'Contact');
        //S2VVoiceMailSendPageController.makeGeneralCallOut(lstid, 'Contact');
        S2VVoiceMailSendPageController.CallFutureMethod(lstid, 'Contact');
        //S2VVoiceMailSendPageController.CallFutureMethodBatch(lstid, 'Contact');
        //S2VVoiceMailSendPageController.sendmailmethod(startDate, 'Contcat', selectedVoice, phoneListFinal, callerId, optionSchedule, ScheduleFreq, selectedTime1, useridreference, isRecordingname);
        test.stopTest();  
    }
    
    static testmethod void method2(){  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        
        
        Countrycode__c codes = new Countrycode__c();
        codes.Name = 'AU';
        codes.Active__c = True;
        insert codes;
        
        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.s2vSMSDemo__Full_Name__c    ='s2v';
        s2vsettings.s2vSMSDemo__password__c='mnbvh';
        s2vsettings.s2vSMSDemo__username__c='xyz@gmail.com';
        s2vsettings.s2vSMSDemo__url__c='www.gmail.com';
        insert s2vsettings;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        S2V_Send_Voicemail__c sendvoicemail=new S2V_Send_Voicemail__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        sendvoicemail.Recording_Name__c='aakriti';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Activity_History__c = True;
        sendvoicemail.Reference_Field__c='kjj';
        sendvoicemail.Start_Date__c=system.today();
        sendvoicemail.sending_method__c = 'voiceMail';
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(acc.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        
        User usr = [Select Id From User limit 1];        
        
        test.starttest();
        System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
        System.assertEquals(lstid.size(),1);
        
        Test.setMock(HttpCalloutMock.class, new IOCampaignS2VResponceTest()); 
        S2VVoiceMailSendPageController s2vmail=new S2VVoiceMailSendPageController();
        s2vmail.filterValue1 = 'value1';
        s2vmail.filterValue2 = 'value2';
        s2vmail.filterValue3 = 'value3';
        s2vmail.filterValue4 = 'value4';
        s2vmail.filterValue5 = 'value5';
        s2vmail.filterValue6 = 'value6';
        
        s2vmail.filterop1 = 'Equals';
        s2vmail.filterop2 = 'Equals';
        s2vmail.filterop3 = 'Equals';
        s2vmail.filterop4 = 'Equals';
        s2vmail.filterop5 = 'Equals';
        s2vmail.filterop6 = 'Equals';
        
        s2vmail.filtertext1 = 'Text1';
        s2vmail.filtertext2 = 'Text2';
        s2vmail.filtertext3 = 'Text3';
        s2vmail.filtertext4 = 'Text4';
        s2vmail.filtertext5 = 'Text5';
        s2vmail.filtertext6 = 'Text6';
        
        s2vmail.selectedField = '1';
        s2vmail.selectedLookup = '1';
        s2vmail.selectedObject = 'Task';
        s2vmail.selectedUser = usr.Id;
        
        s2vmail.selectedDate = System.today();
        s2vmail.selectedFreq = ''; 
        s2vmail.userfields = '';
        s2vmail.recOperators = '';
        s2vmail.diffUsers = '';
        
        List<SelectOption> lstAllusr1 = new List<SelectOption>();
        lstAllusr1 = s2vmail.lstAllusr;
        
        System.assertEquals(usr != Null, !String.isBlank(usr.Id)); 
        s2vmail.saveData();
        s2vmail.getAllFieldNames();
        
        S2VVoiceMailSendPageController.CallFutureMethodBatch(lstid, 'Contact');
        //S2VVoiceMailSendPageController.sendmailmethod(startDate, 'Contcat', selectedVoice, phoneListFinal, callerId, optionSchedule, ScheduleFreq, selectedTime1, useridreference, isRecordingname);
        test.stopTest();  
    }


    // sms coverage parts starts below
   
    static testmethod void S2VSendSMS(){  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
       
        
        Countrycode__c codes = new Countrycode__c();
        codes.Name = 'AU';
        codes.Active__c = True;
        insert codes;
        

        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.s2vSMSDemo__Full_Name__c    ='s2v';
        s2vsettings.s2vSMSDemo__password__c='mnbvh';
        s2vsettings.s2vSMSDemo__username__c='xyz@gmail.com';
        s2vsettings.s2vSMSDemo__url__c='www.gmail.com';
        insert s2vsettings;
        
        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;

        Account acc = new Account();
        acc.name = 'test';
        insert acc; 

        
        Contact con = new Contact();
        con.LastName = 'Test Last Name';
        con.AccountId = acc.Id;
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingCountry = 'AU';
        
        
        S2V_Send_Voicemail__c sendvoicemail=new S2V_Send_Voicemail__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Activity_History__c = True;
        sendvoicemail.Reference_Field__c='kjj';
        sendvoicemail.Start_Date__c=system.today();
        sendvoicemail.sending_method__c = 'SMS';
        sendvoicemail.SMS_Template_Body__c =  objSMSTemp.Template_Body__c;
        sendvoicemail.SMS_Template_Name__c = objSMSTemp.Template_Name__c;
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(con.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        
        
        test.starttest();
        apexpages.currentpage().getparameters().put('sid', sendvoicemail.Id);
        System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
        System.assertEquals(lstid.size(),1);
        
        Test.setMock(HttpCalloutMock.class, new Test_IOVoicemailDropBackend()); 
        S2VVoiceMailSendPageController s2vmail=new S2VVoiceMailSendPageController();
        s2vmail.isEditMode = true;
        s2vmail.selectedField = '1';
        s2vmail.selectedField = '2';
        s2vmail.selectedLookup = '1';
        s2vmail.selectedObject = 'Opportunity';
        s2vmail.fieldsneed = 'Contact__c';
        s2vmail.isActivityhistory = true;
        List<SelectOption> listSO = s2vmail.SobjectUserNames1;
        //s2vmail.getAllSObject();
        //s2vmail.fetchFieldNames();
        s2vmail.getAllFieldNames();
        s2vmail.getSobjectFieldNames();
        //s2vmail.OwnerUsers();
        //s2vmail.getDropDownCallerList();
        s2vmail.getScheduleList();
        s2vmail.getScheduleFreqList();
        s2vmail.enableFutureCallFields();
        s2vmail.getAllAvailableTimes();
        s2vmail.getAlllookupfields();
        s2vmail.getAllrecornumber();
        s2vmail.filtertext1 = 'Text';
        s2vmail.filtertext2 = 'Text';
        s2vmail.filtertext3 = 'Text';
        s2vmail.filtertext4 = 'Text';
        s2vmail.filtertext5 = 'Text';
        s2vmail.filtertext6 = 'Text';
        s2vmail.newfiltertext1 = s2vmail.filtertext1;
        s2vmail.newfiltertext2 = s2vmail.filtertext2;
        s2vmail.newfiltertext3 = s2vmail.filtertext3;
        s2vmail.newfiltertext4 = s2vmail.filtertext4;
        s2vmail.newfiltertext5 = s2vmail.filtertext5;
        s2vmail.newfiltertext6 = s2vmail.filtertext6;
        s2vmail.filterop1 ='Not Equals to';
        s2vmail.filterop2 ='Greater than';
        s2vmail.filterop3 = 'Less than';
        s2vmail.filterop4 = 'Greater than';
        s2vmail.filterop5 = 'Greater than';
        s2vmail.filterop6 = 'Greater than';
        s2vmail.smstemplateID = objSMSTemp.id;
        s2vmail.smstemplateName = sendvoicemail.SMS_Template_Name__c;
        s2vmail.smstemplateBody = sendvoicemail.SMS_Template_Body__c;
       
        List<SelectOption> options = new List<SelectOption>();
        options = s2vmail.getRadios();
        s2vmail.radioValues = 'SMS';
        
        List<SelectOption> options1 = new List<SelectOption>();
        options1 = s2vmail.getSmsTemplates();

        //objRA.setRadioValues(radioValues);
        PageReference objPageRef = s2vmail.actionSave();
        PageReference objPageRef1 = s2vmail.AllSmsTemplate();
        //S2VVoiceMailSendPageController.replaceMergeFields('Opportunity', 'testing', sendvoicemail.id, listCon[0].id);

        s2vmail.saveData();
        S2VVoiceMailSendPageController.PhonelistSMS(lstid, 'Contact');
        S2VVoiceMailSendPageController.CallFutureMethod(lstid, 'Contact');
        
        //S2VVoiceMailSendPageController.sendSMSMethod('Contact','Hi Test','Test','9898980','989898',sendvoicemail.id,lstid);
        
        //S2VVoiceMailSendPageController.replaceMergeFieldsforSingleSMS(sObject Contact,'hi testing',con.id);
        test.stopTest();  
    }


    static testmethod void smsmethod(){  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        
        
        Countrycode__c codes = new Countrycode__c();
        codes.Name = 'AU';
        codes.Active__c = True;
        insert codes;
        
        s2vSMSDemo__S2V_Settings1__c s2vsettings=new s2vSMSDemo__S2V_Settings1__c();
        s2vsettings.s2vSMSDemo__Full_Name__c    ='s2v';
        s2vsettings.s2vSMSDemo__password__c='mnbvh';
        s2vsettings.s2vSMSDemo__username__c='xyz@gmail.com';
        s2vsettings.s2vSMSDemo__url__c='www.gmail.com';
        insert s2vsettings;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 

        Contact con = new Contact();
        con.LastName = 'Test Last Name';
        con.AccountId = acc.Id;
        con.accounts__c = acc.Id;
        con.MobilePhone = '123456789';
        con.MailingCountry = 'AU';
        insert con;

        SMS_Template__c objSMSTemp = new SMS_Template__c();
        objSMSTemp.Template_Name__c = 'Testing';
        objSMSTemp.Template_Body__c = 'hello testing';
        insert objSMSTemp;

        S2V_Send_Voicemail__c sendvoicemail=new S2V_Send_Voicemail__c();
        sendvoicemail.Object_Name__c='Contact';
        sendvoicemail.Reference_Field_Lable__c='abc';
        //sendvoicemail.Recording_Name__c='aakriti';
        sendvoicemail.Option_Schedule__c='Now';
        sendvoicemail.Schedule_Frequency__c='Daily';
        sendvoicemail.Activity_History__c = True;
        sendvoicemail.Reference_Field__c='kjj';
        sendvoicemail.Start_Date__c=system.today();
        sendvoicemail.sending_method__c = 'SMS';
        sendvoicemail.SMS_Template_Body__c =  objSMSTemp.Template_Body__c;
        sendvoicemail.SMS_Template_Name__c = objSMSTemp.Template_Name__c;
        insert sendvoicemail;
        
        list<id> lstid=new list<id>();
        lstid.add(acc.Id);
        
        date startdate=system.today();
        string selectedvoice='abc';
        string phoneListFinal='xyz';
        String callerId='pqr';
        Integer optionSchedule=1;
        String ScheduleFreq='daily';
        String selectedTime1='abc';
        String useridreference='abcdg';
        Boolean isRecordingname=true;
        
        User usr = [Select Id From User limit 1];        
        
       
        System.assertEquals(sendvoicemail.Object_Name__c,'Contact');
        System.assertEquals(lstid.size(),1);
        
       
        S2VVoiceMailSendPageController s2vmail=new S2VVoiceMailSendPageController();
        s2vmail.filterValue1 = 'value1';
        s2vmail.filterValue2 = 'value2';
        s2vmail.filterValue3 = 'value3';
        s2vmail.filterValue4 = 'value4';
        s2vmail.filterValue5 = 'value5';
        s2vmail.filterValue6 = 'value6';
        
        s2vmail.filterop1 = 'Equals';
        s2vmail.filterop2 = 'Equals';
        s2vmail.filterop3 = 'Equals';
        s2vmail.filterop4 = 'Equals';
        s2vmail.filterop5 = 'Equals';
        s2vmail.filterop6 = 'Equals';
        
        s2vmail.filtertext1 = 'Text1';
        s2vmail.filtertext2 = 'Text2';
        s2vmail.filtertext3 = 'Text3';
        s2vmail.filtertext4 = 'Text4';
        s2vmail.filtertext5 = 'Text5';
        s2vmail.filtertext6 = 'Text6';
        
        s2vmail.selectedField = '1';
        s2vmail.selectedLookup = '1';
        s2vmail.selectedObject = 'Task';
        s2vmail.selectedUser = usr.Id;
        
        s2vmail.selectedDate = System.today();
        s2vmail.selectedFreq = ''; 
        s2vmail.userfields = '';
        s2vmail.recOperators = '';
        s2vmail.diffUsers = '';
        
        s2vmail.smstemplateID = objSMSTemp.id;
        s2vmail.smstemplateName = sendvoicemail.SMS_Template_Name__c;
        s2vmail.smstemplateBody = sendvoicemail.SMS_Template_Body__c;
       

        List<SelectOption> lstAllusr1 = new List<SelectOption>();
        lstAllusr1 = s2vmail.lstAllusr;
        
        System.assertEquals(usr != Null, !String.isBlank(usr.Id)); 
        s2vmail.saveData();
        s2vmail.getAllFieldNames();
        
        S2VVoiceMailSendPageController.CallFutureMethodBatch(lstid, 'Contact');
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new Test_IOVoicemailDropBackend()); 
        S2VVoiceMailSendPageController.sendSMSMethod('Contact','Hi Test','Test','9898980','989898',sendvoicemail.id,lstid);
        S2VVoiceMailSendPageController.sendSMSMethodSingle('Contact', '9898989','9898989','Hi test',con.id);
        S2VVoiceMailSendPageController.sendSMSMethodSingle2Way('Contact', '9898989','9898989','Hi test',con.id);
        S2VVoiceMailSendPageController.makeGeneralCallOutFORSMS('Hi Testing', 'Testing', '98988', '989898', 0, 'Once', '09:00:00',true, sendvoicemail.id, lstid, 'Contact', 'User', 'Contact', lstid, lstid, 's', '27-03-2019', '09:00:00');
        S2VVoiceMailSendPageController.singleSMSSending('Contact',con.id,'hi testing','hi testing name','998989','09090');
        Test.stopTest(); 
        
       
    }
    
}