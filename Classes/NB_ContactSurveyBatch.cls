global class NB_ContactSurveyBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    global final String query;
    global  Map<Id,String> mapOfErrors=new Map<Id,String>();
    global Boolean isLimitExceeded=false;
    
    
    global NB_ContactSurveyBatch(String q){
        
        query=q; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> listOfContacts){
        if(isLimitExceeded==false)
        {  
            try
            {
                Messaging.reserveSingleEmailCapacity(listOfContacts.size());
            }
            catch(Exception e)
            {
                System.debug(LoggingLevel.ERROR,NB_Constants.LIMIT_EXCEP_MSG+e);
                isLimitExceeded=true;
            }    
            
            if(isLimitExceeded==false)
            {
                Map<Id,String> mapOfErrorMail= NB_ContactSurveyHelper.sendMessage(listOfContacts);            
                 NB_ContactSurveyHelper.updateSurveys(listOfContacts,mapOfErrorMail);  
                
                if(mapOfErrorMail.isEmpty()==false)
                {
                    mapOfErrors.putAll(mapOfErrorMail);
                }
            
            }
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
        //Email is send to the admin if there is any error during Batch processing
        NB_ContactSurveyHelper.sendMailToAdmin(mapOfErrors,isLimitExceeded,BC.getJobId());
        
    }
}