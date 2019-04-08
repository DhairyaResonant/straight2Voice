@isTest

public class TestClassGeneratingtestclasses
{
    static testmethod void requiredfields(){
        
        String objname = 'Contact';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.getRequiredFields(objname); 
    }
    
    static testmethod void requiredfieldsCampaignMem(){
        
        String objname = 'CampaignMember';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.getRequiredFields(objname); 
    }
    
     static testmethod void requiredfieldsCampaignMem1(){
        
        String objname = 'CampaignMember';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.referField1(objname); 
    }
    
    static testmethod void requiredfields1(){
        String objname = 'Opportunity';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.referField1(objname); 
    }
    
    static testmethod void requiredfields2(){
        String objname = 'Opportunity';
        GeneratingTestClasses.forcampmember = 'test';
        GeneratingTestClasses.referField(objname);
        GeneratingTestClasses.campmembers();
        
    }
    
    static testmethod void requiredfields5(){
        String objname = 'Lead';
        GeneratingTestClasses.getRequiredFields(objname); 
        GeneratingTestClasses.campmembers();        
    }
}