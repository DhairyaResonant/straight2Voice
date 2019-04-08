/*
* Created By: Dhairya Shah
* Date: 24/08/2018
* Desc: Scheduling Accounts and Contacts
*/

global class ScheduleAccountsAndContacts implements Schedulable, Database.AllowsCallouts {
   
    public static string firstname {get;set;}
	public static string username {get;set;}
    public static string password {get;set;}
    public static string lastname {get;set;}
    public static string url {get;set;}
    
    global ScheduleAccountsAndContacts(){
        
    }
    
    global void execute(SchedulableContext SC) {
        
        try{
            if(!Test.isRunningTest()){
              system.enqueueJob(new QueueUpdateAccountContact());  
            }
            
        }
        catch(Exception e){
            system.debug('Catch exception::::'+e);
        }
        
    }
}