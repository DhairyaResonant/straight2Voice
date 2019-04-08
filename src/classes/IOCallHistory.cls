/*
 * Created By: Dhairya Shah
 * Desc: Used in IOCallHistoryController
 */
public class IOCallHistory {
    public class RObject
    {
        public String call_start {get;set;}
        public String country {get;set;}
        public String duration {get;set;}
        public String ph_number {get;set;}
        public String recipient {get;set;}
        public String resource_uri {get;set;}
        public String result {get;set;}
        
    }
    public List<RObject> objects{get;set;}
    public boolean isSuccess{get;set;}
    public Meta meta{get;set;}
    public class Meta
    {
        public String next{get;set;}
        public String previous{get;set;}
        public String total_count{get;set;}
    }
    
}