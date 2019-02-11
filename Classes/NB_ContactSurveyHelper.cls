public class NB_ContactSurveyHelper {
    
    /*This function is used to send email by using visual force template it sends the mail to contacts for the survey to be 
     * completed
     * @listOfContacts : The contacts to which the email need to be send to.
     * @return The function return map of error records Id with the error message.
     * */
    
    public static Map<Id,String> sendMessage(List<Contact> listOfContacts)
    {
        Map<Id,String> mapOfErrors=new Map<Id,String>();      
        EmailTemplate templateId = [Select id from EmailTemplate where name = 'Survey'];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        for(Contact con:listOfContacts)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(con.id);  
            mail.setWhatId(con.id);
            mail.setTemplateId(templateId.Id);
            mail.setSaveAsActivity(false);
            allmsg.add(mail);   
        }        
        Messaging.SendEmailResult[] results =  Messaging.sendEmail(allmsg,false);
        for(Messaging.SendEmailResult result:results)   
        {
            if (result.isSuccess()==false) 
            {
             String msg='';
                    for(Database.Error err: result.getErrors()){
msg += err.getmessage()+'\n\n';
}
               mapOfErrors.put(result.errors[0].getTargetObjectId(),msg);
            }
        }
        return mapOfErrors;
        
    }
    
    public static void updateSurveys(List<Contact> listOfContacts,Map<Id,String> mapOfErrorEmail)
    {
        Map<Id,String> mapOfErrorRec=new Map<Id,String>();
        List<Contact> listToUpdate=new List<Contact>();
        
        for(Contact con:listOfContacts)
        {
           if(mapOfErrorEmail.isEmpty() || 
              mapOfErrorEmail.containsKey(con.Id)==false)
           {
             con.survey_date__c=null;
               listToUpdate.add(con);
           }
        }
        
        if(listToUpdate.isEmpty()==false)
        {
         try
     {
        update listToUpdate;
     }
        catch(Exception DmlException)
            {
                System.debug('Error while updating contacts '+listToUpdate);
            }    
        }
        
    }
    
   
   
    /*This function send emails to admin for the failed records or if the limit is exceded
     * completed
     * @errRecMap : Error records to be processed
     * @isEmailLimitExceded is the email limit of the org is at the border line.
     * @jobId : The job id of the batch
     *
     * */   
    
    
 public static void sendMailToAdmin(Map<Id,String> errRecMap,Boolean isEmailLimitExceded,
                                   String jobId)
 {
 
     
   String body='';
     String subject=NB_Constants.ADMIN_EXCEP_EMAIL_SUBJ+' '+jobId;
     
     if(isEmailLimitExceded==true)
     {
       body=NB_Constants.ADMIN_EXCEP_EMAIL_BODY1;  
     }
     
     if(errRecMap.isEmpty()==false)
     {
         for(String contacttId :errRecMap.keySet())
         {
             body=NB_Constants.ADMIN_EXCEP_EMAIL_BODY2+contacttId + NB_Constants.ADMIN_EXCEP_EMAIL_BODY3;
             body=body+errRecMap.get(contacttId)+'\n';
         }
     }
     
     if(isEmailLimitExceded==true||errRecMap.isEmpty()==false)
     {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());  
         mail.setSubject(subject);
            mail.setHtmlBody(body);
            mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
 }
    
    
    
}