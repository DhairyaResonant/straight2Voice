public class IORecording {
    public class RObject
    {
        public String audio_file {get;set;}
        public String id {get;set;}
        public String name {get;set;}
        public String resource_uri {get;set;}
        public String saleslforce_user_id {get;set;}
        public String recording_number{get;set;}
        public String description{get;set;}
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