@isTest
public class NB_PriceListTest {
@testSetup
    public static void setIntialData()
    {
        List<String> listOfProductName= new list<String> { 'Metal' , 'Standard' , 'Black' };
            List<String> listOfHomeCountries=new List<String>{'FR','ES','DE','IT'};
            List<String> listOfPriceBooks=new list<String> { 'FR_CPCM' , 'ES_CPCM' , 'DE_ATM','IT_ATM' };
             List<String> listOfEntryTypes=new list<String> { 'Cost per Calendar Month' , 'ATM Fee in other currencies' , 'Card Replacement Cost'}; 

  List<Product2> listOfProducts=NB_DataFactory.createProducts(listOfProductName);    
        insert listOfProducts;
  NB_DataFactory.insertStandardPrice(listOfProducts); 
   
 List<Pricebook2> priceBooks= NB_DataFactory.createPriceBooks(listOfPriceBooks); 
        insert priceBooks;
   
        List<String> productIds=new List<String>();
        
        for(Product2 prod:listOfProducts)
        {
           productIds.add(prod.Id); 
        }
        
  List<PricebookEntry> listOfCustomEntries=  NB_DataFactory.createPriceBookEntry(pricebooks, productIds, listOfEntryTypes);
  insert listOfCustomEntries;      
  
        List<Contact> listOfCon=NB_DataFactory.createContacts(10, productIds, null, 'Test Contact Pricing',listOfHomeCountries);
        insert listOfCon;
        List<Case> lisOfCases=NB_DataFactory.creatCases(listOfCon);
        insert lisOfCases;
      
        
    }
    
    public testMethod static void testPricingSuccess()
    {
   Contact conObj=[Select Id,Product__c,Home_Country__c from Contact Limit 1];
        System.debug('conObj '+conObj);
        Test.startTest();
   List<PricebookEntry>  listOfEntry= NB_PriceListController.searchPriceEntry(conObj.Product__c,conObj.Home_Country__c);  
        System.assert(listOfEntry.size()>0);
        Test.stopTest();
        System.debug('listOfEntry '+listOfEntry);
        
    }
    
    public testMethod static void testCaseSuccess()
    {
   Case caseObj=[Select Id from Case Limit 1];
        
        Test.startTest();
  NB_PriceListController.ProductPriceWrapper  wrapper= NB_PriceListController.getProductPriceDetails(caseObj.Id); 
       
        Test.stopTest();
        System.debug('wrapper '+wrapper);
      System.assert(wrapper!=null);
 
         System.assert(wrapper!=null);
        System.assert(wrapper.homeCountry=='FR'||wrapper.homeCountry=='IT' || wrapper.homeCountry=='DE'||wrapper.homeCountry=='ES');
        
        
        
    }    
    
    
}