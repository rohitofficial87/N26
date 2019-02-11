public with sharing class NB_PriceListController  {
    
   public class ProductPriceWrapper
   {
       @AuraEnabled
     public  List<PricebookEntry> listOfPriceBookEntry;
       
       @AuraEnabled 
       public String homeCountry;

       @AuraEnabled
       public String productCode;
      
       @AuraEnabled
       public Id contactId;
        @AuraEnabled
        public List<Product2> listOfAllProducts;
   }
    
    @AuraEnabled
    public static ProductPriceWrapper  getProductPriceDetails(String caseId)
    {
       Case caseObj=[Select Id,ContactId from Case where Id=:caseId]; 
       Id ContactId= caseObj.ContactId;
        
       Contact contactObj=[Select Id,Product__c,Home_Country__c,Product__r.Name from Contact where Id=:ContactId ]; 

        ProductPriceWrapper priceWrapper=new ProductPriceWrapper();
            List<PricebookEntry> listOfPrices =searchPriceEntry(contactObj.Product__c,contactObj.Home_Country__c);
        
priceWrapper.homeCountry=contactObj.Home_Country__c;
priceWrapper.productCode=contactObj.Product__r.Name;
priceWrapper.contactId=contactObj.Id;
priceWrapper.listOfPriceBookEntry=listOfPrices;
priceWrapper.listOfAllProducts=getListOfProducts(); 
        
        
        return priceWrapper;
   
    }
    
    private static List<Product2>  getListOfProducts()
    {
        List<Product2> listOfProducts=[Select Id,Name from Product2 where isActive=true];
        return listOfProducts;
    }
    
    
    @AuraEnabled
    public static List<PricebookEntry> updateContactAndProduct(List<PricebookEntry> priceBookChanges,Id contactId
                                                              ,String homeCountry)
    {
       Savepoint sp = Database.setSavepoint();
        try
        {
            update priceBookChanges;
            
            Contact con=new Contact();
            con.Id=contactId;
            con.Product__c=priceBookChanges[0].Product2Id; 
            update con;
        }
        catch(DmlException expection )
        {
            Database.rollback(sp);
            throw new AuraHandledException(NB_Constants.DML_EXCEP_MSG+expection);

        }
        
        System.debug('This is the result '+priceBookChanges[0].Product2Id+'Home Country >>' +homeCountry);
        
        return searchPriceEntry(priceBookChanges[0].Product2Id, homeCountry);
    }
   
    
 @AuraEnabled(cacheable=true)
   
    public  static  List<PricebookEntry> searchPriceEntry(ID productId, String homeCountry)
    {

        //Price Book Entry(Entry_Type__c) is custom field to determine the type of relation which could be 
        //Cost per Calendar Month,ATM Fee in other currencies or Card Replacement Cost
        
        
        List<PricebookEntry> listOfPrices=[Select Id,Name,Pricebook2.Name,UnitPrice,Entry_Type__c,Currency_Type__c,
                                           Product2.Name,IsNA__c
                                             from PricebookEntry where
                                            Product2Id=:productId and Pricebook2.Name like : homeCountry+'%'  and
                                           Entry_Type__c !=null
                                           order by Entry_Type__c ];
        
     
       
return listOfPrices;
   
    
        
            
    }
    

}