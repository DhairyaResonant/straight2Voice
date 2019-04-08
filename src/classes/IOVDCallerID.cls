public class IOVDCallerID {
    public class RObject
    {
        public String callerid{get;set;}
        public String id {get;set;}
        public Boolean verified {get;set;}
        public String resource_uri {get;set;}
        
    }
    public List<RObject> objects{get;set;}
    public boolean isSuccess{get;set;}
    public String error {get;set;}
    public String id{get;set;}
    public Boolean callerBoolean {get;set;}
    

}