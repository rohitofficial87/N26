@isTest
public class NB_ContactSurveySucessTest {

    private static  List<Contact> listOfContacts;
    
    @testSetup
    public static void setInitialData()
    {
      List<Schema.Picklistentry> fieldResultLanguage = Contact.language__c.getDescribe().getPicklistValues();
 
 
        listOfContacts=NB_DataFactory.createContacts(10, null,convertPickListToListString(fieldResultLanguage),'Test Contact');
        insert listOfContacts;
        
    }
    
    

        public testMethod static void successEmailForSurvey()
    {
        
    Datetime todayDate = System.now();
   String todayDateString=todayDate.format(NB_Constants.DATE_FORMAT);
     
     String query='Select Id,Email,Survey_date__c,language__c from Contact'
         +' where Survey_date__c < '+todayDateString;
      NB_ContactSurveyBatch surveyBatch= new NB_ContactSurveyBatch(query);
     
        Test.startTest();
        ID batchprocessid = Database.executeBatch(surveyBatch,100);
     
        Test.stopTest();
        
       List<Contact> listOfContactSurvey =[Select Id,Survey_date__c from Contact where Survey_date__c=null  ];
       System.assert(listOfContactSurvey.size()>0);
       
    }
    
    
     public testMethod static void successEmailForSurveySchedule()
    {

        Test.startTest();
      Id scheduleId= NB_ContactSurveySchedule.sceduleCronJon();
     
        Test.stopTest();
        
      System.assert(scheduleId!=null);
       
       
    }
 
      
    
    
    
    
    private static List<String> convertPickListToListString(List<Schema.Picklistentry> fieldResult)
    {
        List<String> listOfValues=new List<String>();
         for(Schema.PicklistEntry f : fieldResult) {
	 listOfValues.add(f.value);
  }
       return listOfValues;
    }
    
}