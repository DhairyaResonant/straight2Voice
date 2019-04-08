/*Created By: Dhairya Shah
* Date: 24/08/2018
* Desc: Super admin account and contacts
*/
global class QueueUpdateAccountContact implements Queueable,Database.AllowsCallouts{
    // BATCHABLE CLASS
    public String username;
    public String password;
    public Boolean flagfornextcall{get;set;}
    public Integer skip {get;set;}
    public Integer total {get;set;}
    public SuperAdminAllUsers acc {get;set;}
    public DateTime lastCreditUsage {get;set;}
    public DateTime lastCreditPurchase {get;set;}
    
    //CONSTRUCTOR
    global QueueUpdateAccountContact(){
        flagfornextcall = false;
        skip = 0;
        total = 0;
        
        //CUSTOM SETTING
        Xero_Settings_Super_Admin__c setting =   Xero_Settings_Super_Admin__c.getInstance(userInfo.getOrganizationId());
        this.username = username;
        this.password = password;
        
        if(setting.s2vSMSDemo__username__c != null && setting.s2vSMSDemo__password__c != Null){
            this.username = setting.s2vSMSDemo__username__c;
            this.password = setting.s2vSMSDemo__password__c;
        }
        
    }

    //CONSTRUCTOR WITH PARAMETERS
    global QueueUpdateAccountContact(Integer skip1, Boolean flagfornextcall1){
        
        flagfornextcall = flagfornextcall1;
        skip = skip1;
        total = 0;
        
        //CUSTOM SETTING
        Xero_Settings_Super_Admin__c setting =   Xero_Settings_Super_Admin__c.getInstance(userInfo.getOrganizationId());
        this.username = username;
        this.password = password;
        
        if(setting.s2vSMSDemo__username__c != null && setting.s2vSMSDemo__password__c != Null){
            this.username = setting.s2vSMSDemo__username__c;
            this.password = setting.s2vSMSDemo__password__c;
        }
        
    }
    

    //EXECUTE METHOD
    global void execute(QueueableContext cont) {

        try{
            List<Account> acc1 = new List<Account>();
            List<Contact> cons = new List<Contact>();
            List<String> emailunique = new List<String>();
            List<String> emailuniqueforacc = new List<String>();
            
            //SUPERADMINALLUSERS CLASS
            if(flagfornextcall == false){
                skip = 0;
                acc = s2vIOVoicemailDropBackend.getMoreSuperAccountDetails(username , password,'/api/v1/user/?limit=20&offset='+skip);
            } else {
                acc = s2vIOVoicemailDropBackend.getMoreSuperAccountDetails(username , password,'/api/v1/user/?limit=20&offset='+skip);
            }
            
            SuperAdminAllUsers.meta mtobj = acc.meta;
            
            if(acc.objects.size() != null){
                skip = skip + acc.objects.size();
                total = mtobj.total_count - skip; 
                
                if(total > 0 ){ 
                    flagfornextcall = true;
                } else {
                    flagfornextcall = false;
                }
            }
            
            Map<String,Account> accountEmailMap = new Map<String,Account>();
            Map<String,ContacT> conEmailMap = new Map<String,Contact>();

            for(SuperAdminAllUsers.objects obj : acc.objects){
                emailuniqueforacc.add(obj.email.toLowercase());
            }

            //ACCOUNT
            List<Account> acclstemails = [select Id,Name,Registered_Login_Email_Address__c from Account where Registered_Login_Email_Address__c In : emailuniqueforacc ];

            for(Account accmail : acclstemails ){
                if(accmail.Registered_Login_Email_Address__c!=NULL){
                    accountEmailMap.put(accmail.Registered_Login_Email_Address__c.toLowercase(),accmail);  
                }
            }

            //CONTACT
            List<Contact> conList = [select Id,Name,Email from Contact where Email In : emailuniqueforacc];

            for(Contact conMail : conList ){
                if(conMail.Email!=NULL){
                    conEmailMap.put(conMail.Email.toLowercase(),conMail);  
                }
            }
            
            List<Account> lstAccounts = new List<Account>();

            for(SuperAdminAllUsers.objects obj : acc.objects){
                if(obj.email != null && obj.email.trim() != '' && ((obj.first_name != null && obj.first_name.trim() != '') || (obj.last_name != null && obj.last_name.trim() != '') || (obj.company != null && obj.company.trim() != ''))){
                    Account act;
                    if(accountEmailMap != null && accountEmailMap.size() > 0 && accountEmailMap.containsKey(obj.email)){
                        act = accountEmailMap.get(obj.email.toLowercase());
                    }else{
                        act = new Account();
                    }
                
                    if(obj.company != null && obj.company.trim() != ''){
                        act.Name = obj.company;
                    }else if(obj.company == null || obj.company == ''){
                        if(obj.first_name != null && obj.first_name.trim() != '' && obj.last_name != null && obj.last_name.trim() != ''){
                            act.Name = obj.first_name + ' ' + obj.last_name;
                        }else if((obj.first_name == null || obj.first_name == '') && (obj.last_name != null && obj.last_name.trim() != '')){
                            act.Name = obj.last_name;
                        }else if((obj.last_name == null || obj.last_name == '') && (obj.first_name != null && obj.first_name.trim() != '')){
                            act.Name = obj.first_name;
                        }
                    }

                    if(obj.Phone!=NULL){
                        act.phone = obj.Phone;
                    }
                        
                        //EMAIL ADDRESS
                    if(obj.email !=NULL && obj.email.trim() != ''){
                        act.Registered_Login_Email_Address__c= obj.email.toLowercase();
                    }

                    lstAccounts.add(act);    
                }
                
            }

            upsert lstAccounts;
            System.debug('UPSERT ACCOUNTS SIZE ::::::::::::' + lstAccounts.size());
            for(Account act : lstAccounts){
                if(!accountEmailMap.containsKey(act.Registered_Login_Email_Address__c.toLowercase())){
                    accountEmailMap.put(act.Registered_Login_Email_Address__c.toLowercase(), act);
                }
            }

            System.debug('Account Map Size is :::::::::::::' + accountEmailMap.size());

            List<Contact> lstContacts = new List<Contact>();

            for(SuperAdminAllUsers.objects obj : acc.objects){
                if(obj.email != null && obj.email.trim() != '' && ((obj.first_name != null && obj.first_name.trim() != '') || (obj.last_name != null && obj.last_name.trim() != '') || (obj.company != null && obj.company.trim() != ''))){
                    Contact con;
                    if(conEmailMap != null && conEmailMap.size() > 0 && conEmailMap.containsKey(obj.email.toLowercase())){
                        con = conEmailMap.get(obj.email.toLowercase());
                    }else{
                        con = new Contact();
                    }

                    con.AccountId = accountEmailMap.get(obj.email.toLowercase()).Id;

                    if(obj.first_name != null && obj.first_name.trim() != ''){
                        con.Firstname = obj.first_name;
                    } else {
                        con.Firstname = 'Unknown';
                    }
                        
                        //LAST NAME
                    if(obj.Last_name != null && obj.Last_name.trim() != ''){
                        con.Lastname = obj.Last_name;
                    } else {
                        con.Lastname = 'Unknown';
                    }
                        
                        //EMAIL 
                    if(obj.email !=NULL && obj.email.trim() != ''){
                        con.Email = obj.email.toLowercase();
                    }

                    
                        //NUMBER OF VOICEMAIL SENT
                        if(obj.lm_voicemail!=NULL){
                            con.Number_of_voicemail_sent__c = Integer.valueof(obj.lm_voicemail) ;
                        }

                        if(obj.phone!=NULL){
                            con.MobilePhone = obj.phone;
                        }
                        
                        //CREDITS
                        if(obj.credit!=NULL){
                            con.Remaining_Credits__c = Integer.valueof(obj.credit) ;
                        }
                        
                        //STATUS
                        if(obj.Status!=NULL){
                            con.S2V_Status__c = obj.status;
                        }

                        //COUNTRY
                        if(obj.timezone!=NULL){
                            con.Country__c = obj.timezone;
                        }

                        if(obj.last_credit_usage_date != null && obj.last_credit_usage_date !='None' && obj.last_credit_usage_date.trim() != ''){
                            DateTime temp = DateTime.valueOf(obj.last_credit_usage_date).addHours(10);
                            con.Last_Credit_Usage_Date__c = Date.ValueOf(temp);
                        }else{
                            con.Last_Credit_Usage_Date__c = NULL;
                        }
                        
                        //LAST CREDIT PURCHASE
                        if(obj.last_credit_purchase_date != null && obj.last_credit_purchase_date !='None' && obj.last_credit_purchase_date.trim() !=''){
                            DateTime temp = DateTime.valueOf(obj.last_credit_purchase_date).addHours(10);
                            con.Last_Credit_Purchase_Date__c  = Date.ValueOf(temp);
                        }else{
                            con.Last_Credit_Purchase_Date__c = NULL;
                        }
                    
                    con.S2V_Batch_Record__c = true;

                    lstContacts.add(con);
                }
            }

            System.debug('UPSERT CONTACT SIZE ::::::::::::' + lstContacts.size());
            upsert lstContacts;

            if(flagfornextcall == true){
                System.enqueueJob(new QueueUpdateAccountContact(skip ,flagfornextcall));
            } else if (flagfornextcall == false) {
                System.debug('Success');
            }

        }

        catch(Exception e){
            System.debug('Exception :::::::::::'+ e);
            System.debug('Exception Message :::::' + e.getMessage());
            system.debug('Exception line>:::::::::'+e.getLineNumber());
        }
    }
}