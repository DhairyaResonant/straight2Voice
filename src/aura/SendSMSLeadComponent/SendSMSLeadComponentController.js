({
    doInit : function(component, event, helper) {
		var getDomain = component.get("c.getOrganizationDomain");
        getDomain.setCallback(this, function(response) {
           var responseId = response.getReturnValue();
           var iframeURL = 'https://'+ responseId +'/apex/s2vSMSDemo__S2VSendSMSLeadVF?Id=' + component.get('v.recordId');
           component.set('v.iframeLink', iframeURL);
        });
         $A.enqueueAction(getDomain);
        
    },
    
	handleClick : function(component, event, helper) {
        component.set("v.ShowModal",true);
		
	},
    
	closeModal : function(component, event, helper) {
        component.set("v.ShowModal",false);
		
	}
})