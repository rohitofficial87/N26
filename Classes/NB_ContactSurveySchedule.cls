global class NB_ContactSurveySchedule implements Schedulable {
    
public static Id sceduleCronJon()
{
    String cronJob='0 0 22 * * ? *';
 ID scheduleId=  System.schedule('Send Surveys to Customer', cronJob, new NB_ContactSurveySchedule() );
    return scheduleId;
}    
    
    
    
global void execute(SchedulableContext sc) {
Datetime todayDate = System.now();
    
   String todayDateString=todayDate.format(NB_Constants.DATE_FORMAT);
     
     String query='Select Id,Email,Survey_date__c,language__c from Contact'
         +' where Survey_date__c < '+todayDateString;
     
     
        NB_ContactSurveyBatch surveyBatch= new NB_ContactSurveyBatch(query);
        ID batchprocessid = Database.executeBatch(surveyBatch,100);           
    }
}