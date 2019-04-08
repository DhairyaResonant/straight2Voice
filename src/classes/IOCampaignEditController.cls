/*
 * Edited By: Dhairya
 * Desc: s2v campaign tab page.
 */
public with sharing class IOCampaignEditController {
    //Campaign camp;
    private ApexPages.StandardController controller;
    public Boolean showOption{get;set;}
    public List<SelectOption> countryNames { get; set; }
    public string campaignsCountry{get;set;}
    
    public IOCampaignEditController(ApexPages.StandardController controller){
        this.controller = controller;    
        getCountryNames();
    }
    
    public PageReference saveCampaign(){
        Campaign c=   ((campaign)controller.getRecord());
        c.Straight2Voicemail__c=true;
        system.debug('campaignsCountry:::'+campaignsCountry);
        c.S2V_Country_Codes__c = campaignsCountry;
        controller.save();
        PageReference pr = new PageReference('/apex/IOCampaignsS2V');
        pr.setRedirect(true);
        return pr;
    }

    public void getCountryNames() {
        system.debug('in this method');
        countryNames = new List<SelectOption>();
        
        List<s2vSMSDemo__CountryCode__c> allCountries = new List<s2vSMSDemo__CountryCode__c>();
        
        allCountries = [ SELECT  Name, s2vSMSDemo__Active__c FROM s2vSMSDemo__CountryCode__c];
        
        for(s2vSMSDemo__CountryCode__c country : allCountries ) {
            countryNames.add( new SelectOption(country.Name, country.Name));
        }
       
    }
    
}