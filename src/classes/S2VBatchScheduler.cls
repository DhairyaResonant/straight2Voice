public class S2VBatchScheduler implements Schedulable{
    private String tempQuery;
    private String voiceMailFileName;
    private String fieldName;
    
    public S2VBatchScheduler(String tempQuery, String voiceMailFileName, String fieldName){
        this.tempQuery = tempQuery;
        this.voiceMailFileName = voiceMailFileName;
        this.fieldName = fieldName;
    }
    
    public void execute(SchedulableContext sc) {
        system.debug('Query is ::' + tempQuery);
        system.debug('File Name is ::' + voiceMailFileName);
        System.debug('Field Name is ::' + fieldName);
        S2VSendVoiceMailBatch b = new S2VSendVoiceMailBatch(tempQuery,voiceMailFileName,fieldName);
        Database.executeBatch(b);
    }
}