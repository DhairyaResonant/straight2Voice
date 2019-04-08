/*
 * Created By: Dhairya Shah
 * Desc: Scheduleable class for scheduling future voicemails records.
 */
global class S2VFutureVoicemailBase implements Schedulable{
    
    public Interface IS2VFutureVoicemailBase{
        void execute(SchedulableContext sc);
    }
    
    global void execute(SchedulableContext sc) {
        Type targettype = Type.forName('S2VFutureVoicemail');
        if(targettype != null){
            IS2VFutureVoicemailBase obj = (IS2VFutureVoicemailBase)targettype.NewInstance();
            obj.execute(sc);
        }
    }
}