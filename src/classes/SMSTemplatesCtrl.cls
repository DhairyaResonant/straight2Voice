/*
 * Created By - Yugandhara atil
 * Date - 12/12/2018
 * Purpose - Controller of SMSTemplatesPage.vfp
 * 
 */

public class SMSTemplatesCtrl {

	Public String SMSTemplateName {get;set;}
	Public String SMSTemplateType {get;set;}
	Public String SMSTemplateSource {get;set;}
	Public String SMSTemplateBody {get;set;}
	Public String SelectedField   {get;set;}
	Public String SelectedFieldToInsert {get;set;}    

	Public Boolean isListView {get;set;}
	Public Boolean isNewtemplate {get;set;}	
    Public Boolean showErrorMessage {get;set;}

    Public Id deleteTempId {get;set;}
	Public Id editTemplateId {get;set;}
	
	Public List<Selectoption> lstSources {get;set;}
	Public List<Selectoption> lstFields {get;set;}
	Public List<SMS_Template__c> lst_SMSTemplates {get;set;}

	Public Map<Id, SMS_Template__c> mapIdToTemplates;

    public SMSTemplatesCtrl(){
        SMSTemplateType = 'Lead';
        SMSTemplateSource = 'Lead';

        SMSTemplateName = '';
    	SMSTemplateBody = '';
        SelectedField = ''; 
    	SelectedFieldToInsert = '';  

    	isListView = true;
		isNewtemplate = false;
        showErrorMessage = true;

      	lstSources = new List<selectoption>();
      	lstFields = new List<selectoption>();
		lst_SMSTemplates = new List<SMS_Template__c>();

		mapIdToTemplates = new Map<Id, SMS_Template__c>();

		getSMSTemplateList();

    }

    public void getSMSTemplateList(){
    	System.debug('Inside getSMSTemplateList --> ');
    	
    	lst_SMSTemplates = [SELECT Id, Name, Template_Name__c, Object_Name__c, Template_Body__c, CreatedDate, LastModifiedDate FROM SMS_Template__c];
    	if(lst_SMSTemplates != null && lst_SMSTemplates.size() > 0){
    		for(SMS_Template__c tempVar : lst_SMSTemplates){
    			mapIdToTemplates.put(tempVar.Id, tempVar);
    			System.debug('Template Body ---> ' + tempVar.Template_Body__c);
    		}

    	}    
    }

    public void displayNewTemplate(){
    	System.debug('Inside displayNewTemplate');
    	isListView = false;
		isNewtemplate = true;
        showErrorMessage = false;

		SMSTemplateType = 'Lead';
        SMSTemplateSource = 'Lead';

        SMSTemplateName = '';
    	SMSTemplateBody = '';
        SelectedField = ''; 
    	SelectedFieldToInsert = '';  
    }

    public void displayEditTemplate(){
    	System.debug('Inside displayEditTemplate Id= ' + editTemplateId);
    	isListView = false;
		isNewtemplate = false;

		if(mapIdToTemplates.containsKey(editTemplateId)){
			SMS_Template__c smsTemp = mapIdToTemplates.get(editTemplateId);
			System.debug('smsTemp ---> ' + smsTemp);
			SMSTemplateType = smsTemp.Object_Name__c;
			SMSTemplateSource = smsTemp.Object_Name__c;
			SMSTemplateName = smsTemp.Template_Name__c;
			SMSTemplateBody = smsTemp.Template_Body__c;
		}	
    }

    public void cancelTemplate(){
    	isListView = true;
		isNewtemplate = false;
        deleteTempId = null;
        editTemplateId = null;
    }

    public void getSMSTemplateType(){
    	System.debug('SMSTemplateType --> ' + SMSTemplateType);
    	SMSTemplateSource = SMSTemplateType;
    	SelectedField = ''; 
    	SelectedFieldToInsert = '';
    }

    public void getSMSTemplateSource(){
    	System.debug('SMSTemplateSource --> ' + SMSTemplateSource);
    	SelectedField = '';
    	SelectedFieldToInsert = '';
    }    

    public List<Selectoption> getAllSourceNames(){
    	lstSources = new List<selectoption>();
    	lstSources.add(new SelectOption(SMSTemplateType,SMSTemplateType));
    	lstSources.add(new SelectOption('User','$User'));
    	lstSources.add(new SelectOption('Organization','$Organization'));
    	return lstSources;
    	
    }

    public void getSelectedField(){
        System.debug('SelectedField --> ' + SelectedField);
        SelectedFieldToInsert = '{!' + SelectedField + '}';
    }

    public List<Selectoption> getAllFields(){

    	lstFields = new List<selectoption>();
    	//System.debug('Inside getAllFields --> ' + SMSTemplateSource);
        Map<String, Schema.SObjectField> mapOfFieldVsAPIName =Schema.getGlobalDescribe().get(SMSTemplateSource).getDescribe().fields.getMap();
		//System.debug('mapOfFieldVsAPIName --->'+mapOfFieldVsAPIName );
		for(String str : mapOfFieldVsAPIName.keyset()){
			lstFields.add(new SelectOption(str,str));
		}
		return lstFields;
    }

    public void deleteSMSTemplate(){

        System.debug('Template to be deleted ---> ' + deleteTempId);
        if(deleteTempId != null){
            SMS_Template__c smsTemp = new SMS_Template__c(id=deleteTempId);
            delete smsTemp;
        }
        deleteTempId = null;
    }

    public void saveSMSTemplate(){

        System.debug('Inside saveSMSTemplate ');

    	SMS_Template__c smsTemp = new SMS_Template__c();    	
    	smsTemp.Template_Name__c  = SMSTemplateName;
    	smsTemp.Object_Name__c   = SMSTemplateType;
    	smsTemp.Template_Body__c    = SMSTemplateBody;

    	if(smsTemp != null){
    	
    		if(isNewtemplate){
                if(lst_SMSTemplates != null && lst_SMSTemplates.size() <= 10){
                        Insert smsTemp;
                    }
    			
    		}else{    	
    			smsTemp.Id = editTemplateId;		
    			Update smsTemp;	
    		}
    		
    	}
    	lst_SMSTemplates = new List<SMS_Template__c>();
    	mapIdToTemplates = new Map<Id, SMS_Template__c>();
    	getSMSTemplateList();
    	isListView = true;
		isNewtemplate = false;

		editTemplateId = null;
		SMSTemplateName = '';
    	SMSTemplateBody = '';
        SelectedField = ''; 
    	SelectedFieldToInsert = ''; 

        /*
    	Pagereference page = new Pagereference('/apex/SMSTemplatesPage?');
    	page.setRedirect(true);
    	return page;*/

    }

}