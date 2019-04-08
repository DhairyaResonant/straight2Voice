/*
 * DESC: S2V ACCOUNT CLASS USED IN MULTIPLE CLASS FOR REQUEST CALL
 */ 
public class IOVDAccount {
    public Boolean isSuccess{get;set;}
    public String errorMessage{get;set;}
    public String address {get;set;}   
    public String api_ip_allowed {get;set;}   
    public Boolean auto_recurring {get;set;}   
    public String avatar{get;set;}   
    public String company {get;set;}   
    public Integer concurrent_call_limit{get;set;}   
    public Decimal credit {get;set;}   
    public String email {get;set;}   
    public String first_name {get;set;}   
    public Datetime last_login {get;set;}   
    public String last_name {get;set;}   
    public Boolean monthly_balance_reset{get;set;}   
    public String phone {get;set;}   
    public Boolean private_number {get;set;}   
    public String resource_uri {get;set;}   
    public Integer retry_time {get;set;}   
    public Boolean saparate_call {get;set;}   
    public String scheduler_email_cdr_report {get;set;}   
    public String sure_name{get;set;}   
    public Boolean time_condition{get;set;}   
    public String timezone {get;set;}   
    public Integer upload_prefix {get;set;}   
    public String upload_prefix_allowed {get;set;}

    //RECORDING PARAMETER 
    public String job_uuid {get;set;}
    public String name {get;set;}//phone is already declared
    public String responceVoice {get;set;}
    
    //USAGE AND USER DETIALS TYPES 
    public Integer last_purchase {get;set;}
    public Integer lm_voicemail {get;set;}
    public String status {get;set;}
    public String last_credit_purchase_date {get;set;}
    public String last_credit_usage_date {get;set;}

}