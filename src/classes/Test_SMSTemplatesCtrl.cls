/*
* CREATED BY: AAKRITI GOYAL
* DATE: 16/01/2019
* DESC: TEST CLASS FOR SMSTemplatesCtrl APEX CLASS
*/ 
@isTest
public class Test_SMSTemplatesCtrl {
	@testsetup public static void testData(){
        
        SMS_Template__c smsTemplate = new SMS_Template__c();
        smsTemplate.Template_Name__c = 'Test Template';
        smsTemplate.Object_Name__c = 'Lead';
        smsTemplate.Template_Body__c = 'Test Body';
        insert smsTemplate;
    }
    
    
    static testMethod void testdisplayNewTemplate(){
        SMS_Template__c template = [Select Id from SMS_Template__c LIMIT 1];
        
        SMSTemplatesCtrl ctrl = new SMSTemplatesCtrl();
        ctrl.editTemplateId = template.Id;
        ctrl.displayNewTemplate();
        ctrl.displayEditTemplate();
        ctrl.getSMSTemplateType();
        ctrl.getSMSTemplateList();
        ctrl.getAllSourceNames();
        ctrl.getAllFields();
        ctrl.getSMSTemplateSource();
        ctrl.getSelectedField();
        ctrl.saveSMSTemplate();
        
        ctrl.isNewtemplate = true;
        ctrl.saveSMSTemplate();
        ctrl.cancelTemplate();
        
        ctrl.deleteTempId = template.Id;
        ctrl.deleteSMSTemplate();
    }
    
    
}