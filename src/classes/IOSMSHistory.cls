//S2V SMS HISTORY APEX CLASS
public class IOSMSHistory{

	public class RObject
    {
        public String from_number {get;set;}
        public String to_number {get;set;}
        public String message {get;set;}
        public String submit_date {get;set;}
        public String recipient {get;set;}
        public String submit_status {get;set;}
      //  public String saleslforce_user_id {get;set;}
        public String name {get;set;}
        
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