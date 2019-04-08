/*Created By: Dhairya & Dhrudeep
*Dated: 28th June 2018
*Desc: Generating Triggers and deploying it the different orgs.
*/

Global class S2VTriggerDeploymentController {
    public static String API_VERSION = '42.0';
    public String ZipData { get; set; }
    public MetadataService.AsyncResult AsyncResult {get; private set;}
    public String selectedObject {get;set;}
    public String s2vId {get;set;}
    public String selectedField {get;set;}
    public String selectedFieldType {get;set;}
    //CONSTRUCTOR
    public S2VTriggerDeploymentController(){
        if(ApexPages.currentPage().getParameters().get('objName') != null){
            selectedObject = ApexPages.currentPage().getParameters().get('objName');
            s2vId = ApexPages.currentPage().getParameters().get('SId');
        }
        if(ApexPages.currentPage().getParameters().get('objFld') != null ){
            selectedField = ApexPages.currentPage().getParameters().get('objFld');
        }
        if(ApexPages.currentPage().getParameters().get('slctdFldType') != null ){
            selectedFieldType = ApexPages.currentPage().getParameters().get('slctdFldType');
        }
        executeQuery();        
    }
    //CREATING QUERY FROM THE CLASS CALLED S2VVOICEMAILSENDPAGECONTROLLER AND USING THE STORED QUERY IN STRING CALLED QUERYCREATNG FROM THE DECLARED CLASS
    
    public void executeQuery(){
        S2VVoiceMailSendPageController s2vv = new S2VVoiceMailSendPageController();
        String triggerQuery = s2vv.querycreating;
        system.debug('triggerQuery:::::;'+triggerQuery);            
    }
    
    // CREATING XML FOR THE ZIP FILE
    public String getPackageXml(){
        return 
            '<?xml version="1.0" encoding="UTF-8"?>' + 
            '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
            '<types>' + 
            '<members>' + selectedObject + 'ObjTrigger</members>' +
            '<name>ApexTrigger</name>' + 
            '</types>' + 
            '<types>' + 
            '<members>' + selectedObject + 'ObjTriggerTest</members>' +
            '<name>ApexClass</name>' + 
            '</types>'  + 
            '<version>' + API_VERSION + '</version>' + 
            '</Package>';       
    }
    
    //PATH FOR XML FILE
    public String getPathTriggerTestCodeMetadata(){
        return 'classes/'+selectedObject+'ObjTriggerTest.cls-meta.xml';
    }
    
    //DECIDE THE API VERSION OF TRIGGER.
    public String getTriggerTestCodeMetadata(){
        return 
            '<?xml version="1.0" encoding="UTF-8"?>' +
            '<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">' +
            '<apiVersion>' + API_VERSION + '</apiVersion>' + 
            '<status>Active</status>' +
            '</ApexClass>';     
    }
    
    //PATH FOR TEST CLASS
    public String getPathTriggerTestCode(){
        return 'classes/' + selectedObject + 'ObjTriggerTest.cls';
    }
    
    //GENERATING THE CODE FOR TEST CLASS
    public String getTriggerTestCode(){
        
        System.debug('@IsTest\n' +    
                     'private class ' + selectedObject + 'ObjTriggerTest' + '\n' +  
                     '{\n' + 
                     (false == true ? '    @IsTest(SeeAllData=true)\n' : '    @IsTest\n') +
                     '    private static void testTrigger()\n' +
                     '    {\n' +
                     '    }\n' +
                     '}');
        String namespace = '';
        
        // DEPLOY GENERATED CODE
        return 
            '@IsTest\n' +    
            'private class ' + selectedObject + 'ObjTriggerTest' + '\n' +  
            '{\n' + 
            (false == true ? '    @IsTest(SeeAllData=true)\n' : '    @IsTest\n') +
            '    private static void testTrigger()\n' +
            '    {\n' +
            
            's2vSMSDemo__S2V_Trigger_Handler__c objCS = new s2vSMSDemo__S2V_Trigger_Handler__c();\n'+
            'objCS.Name = \'TriggerHandler\';\n'+
            'objCS.s2vSMSDemo__S2VRestrictingCampaignMember__c = true;\n'+
            'objCS.s2vSMSDemo__S2VTimeZoneContact__c = true;\n'+
            'objCS.s2vSMSDemo__S2VTimeZoneLead__c = true;\n'+
            'objCS.s2vSMSDemo__S2VTimeZoneOpp__c = true;\n'+
            'objCS.s2vSMSDemo__S2VTimeZoneTask__c = true;\n'+
            'objCS.s2vSMSDemo__SameRecordNumber__c = true;\n'+
            'objCS.s2vSMSDemo__SendVoiceMail__c = true;\n'+
            'insert objCS;\n'+
            
            '  CountryCode__c cs = new CountryCode__c();\n'+
            '  cs.Name = \'AU\';\n'+
            '  cs.Country__c = \'AU\';\n'+
            '  cs.Active__c = TRUE;\n'+
            '  insert cs;\n\n'+
            
            '  CountryCode__c cs1 = new CountryCode__c();\n'+
            '  cs1.Name = \'CA-US\';\n'+
            '  cs1.Country__c = \'CA-US\';\n'+
            '  cs1.Active__c = FALSE;\n'+
            '  insert cs1;\n\n'+
            
            '  CountryCode__c cs2 = new CountryCode__c();\n'+
            '  cs2.Name = \'NZ\';\n'+
            '  cs2.Country__c = \'NZ\';\n'+
            '  cs2.Active__c = FALSE;\n'+
            '  insert cs2;\n\n'+   
            
            'List<Contact> listCon = new List<Contact>();\n'+
            '  Contact objCon = new Contact();\n'+
            '  objCon.lastName = \'test\';\n'+
            '  objCon.Email = \'d@d.com\';\n'+
            '  objCon.Country__c = \'Australia/NSW\';\n'+
            '  objCon.MailingCountry = \'AU\';\n'+
            '  objCon.S2V_Batch_Record__c = true;\n'+
            '  objCon.s2vSMSDemo__S2V_Stop_Notifications__c = false;\n'+
            
            '  Contact objCon1 = new Contact();\n'+
            '  objCon1.lastName = \'test\';\n'+
            '  objCon1.Email = \'d@d.com\';\n'+
            '  objCon1.Country__c = \'Australia/NSW\';\n'+
            '  objCon1.MailingCountry = \'AU\';\n'+
            '  objCon1.S2V_Batch_Record__c = false;\n'+
            '  objCon1.s2vSMSDemo__S2V_Stop_Notifications__c = false;\n'+
            
            '  listCon.add(objCon);\n'+
            '  listCon.add(objCon1);\n'+
            '  insert listCon;\n'+
            
            +GeneratingTestClasses.getRequiredFields(selectedObject)+'\n'+
            
            '    }\n' +
            '}';            
        
    }
    
    
    
    public String getPathTriggerCodeMetadata(){
        return 'triggers/' + selectedObject + 'ObjTrigger.trigger-meta.xml';
    }
    
    public String getTriggerCodeMetadata(){
        return 
            '<?xml version="1.0" encoding="UTF-8"?>' +
            '<ApexTrigger xmlns="http://soap.sforce.com/2006/04/metadata">' +
            '<apiVersion>' + API_VERSION + '</apiVersion>' + 
            '<status>Active</status>' +
            '</ApexTrigger>';       
    }
    
    public String getPathTriggerCode(){
        return 'triggers/' + selectedObject+ 'ObjTrigger.trigger';
    }
    
    public String getTriggerCode(){
        
        
        String namespace = '';
        
        //DEPLOY GENEREATED CODE        
        return 
            
            'trigger ' + selectedObject + 'ObjTrigger on ' + selectedObject + ' (after insert, after update)\n'+ 
            '{\n '+ 
            '   List<Id> lstIds = new List<Id>();\n'+
            '   System.debug(RecursiveTriggerHandler.isFirstTime);\n'+
            '   if(RecursiveTriggerHandler.isFirstTime){\n'+
            '       RecursiveTriggerHandler.isFirstTime = false;\n'+
            '    String selectedObject = \''+ selectedObject + '\';\n'+
            '    String selectedFieldType = \'' + selectedFieldType + '\'; \n' +
            '      for('+selectedObject+' obj'+selectedObject+' : Trigger.new){\n'+
            '      if(obj'+selectedObject+'.S2V_Customer_Time_Zone__c != null && obj'+selectedObject+'.S2V_Stop_Notifications__c == FALSE){\n'+
            '        Boolean isValid = S2VTimezonevalidation.isValidForSendVM(obj'+selectedObject+'.S2V_Customer_Time_Zone__c); \n'+
            '        Boolean isNotBatchRecord = S2VTimezonevalidation.isItBatchContact(selectedObject, obj'+selectedObject+');\n'+
            '        if((isValid && isNotBatchRecord) || Test.isRunningtest()){ \n'+
            '          lstIds.add(obj'+selectedObject+'.Id);\n'+
            '        }\n' +
            '        else { \n'+
            '          S2VTimezonevalidation.insertQueueRecords(\'' +selectedObject +'\',obj'+ selectedObject + '.id,\'' + selectedFieldType + '\',\'' + selectedField + '\',  obj'+ selectedObject +'.S2V_Customer_Time_Zone__c);' +
            '             } \n' +
            '      } else {\n'+
            '          lstIds.add(obj'+selectedObject+'.Id);\n'+ 
            '        } \n\n'+
            '      }\n\n'+
            '       if(lstIds!=NULL && lstIds.size()>0){\n'+
            '          if(!Test.isRunningtest()){\n'+
            '          S2VVoiceMailSendPageController.CallFutureMethod(lstIds,\'' + selectedObject + '\'); \n' +
            '		}\n\n'+
            '    }\n'+		   
            '  }\n'+
            '}\n';
        
        
    }
    
    //DEPLOYING THE ZIP FILE.
    public void deployZip(){
        
        // DEPLOY ZIP FILE POSTED BACK FROM THE PAGE ACTION                
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.testLevel = 'RunSpecifiedTests';
        deployOptions.runTests = new List<String> { selectedObject + 'ObjTriggerTest' };
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        deployOptions.singlePackage = true;  
        if(!test.isRunningTest()){
            AsyncResult = service.deploy(ZipData, DeployOptions);
        }
        system.debug(AsyncResult);
    }
    
    public PageReference sendToListPage(){
        PageReference pr = new PageReference('/apex/S2VActiveSchedulePage');
        pr.setRedirect(true);
        return pr;    
    }
    
    //CREATING SERVICE USING METADATA API
    private static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}