/*
 * Created By: Dhairya Shah
 * Desc: Used in IOCallHistoryController
 */
public class IOScheduleVoicemail{
    public class RObject
    {
        public String created_at {get;set;}
        public String delay {get;set;}
        public String description {get;set;}
        public String id {get;set;}
        public String last_end {get;set;}
        public String last_start {get;set;}
        public String last_voicemail_left {get;set;}
        public String name {get;set;}
        public String option_schedule {get;set;}
        public String schedule_date_to_start {get;set;}
        public String schedule_frequency {get;set;}
        public String status {get;set;}
        public String total_sent {get;set;}
        
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