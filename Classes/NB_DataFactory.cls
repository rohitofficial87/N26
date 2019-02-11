@isTest
public class NB_DataFactory {

  public static List<Contact> createContacts(Integer numberOfContacts,List<String> listOfProductId,List<String> listOfLanguage,
                                             String contactName,List<String> homeCountries)
  {
      Integer addDays=(numberOfContacts/2)-1;
      Date todayDate=System.today();
      List<Contact> listOfContacts=new List<Contact>();
      for(Integer i=0;i<numberOfContacts;i++)
      {
          Contact conObj=new Contact();
          conObj.LastName=contactName+i;
          conObj.Email='test'+i+'@test.com';
          conObj.survey_date__c=todayDate.addDays(addDays-i);
            if(listOfLanguage!=null)
          {
           conObj.language__c=getRandomListValue(listOfLanguage,i);
          }
if(listOfProductId!=null)
{
          conObj.Product__c=getRandomListValue(listOfProductId,i);
}         
          if(homeCountries!=null)
          {
              conObj.Home_Country__c=getRandomListValue(homeCountries,i);
          }
          conObj.Salutation='Mr.';
          listOfContacts.add(conObj);              
      }
      return listOfContacts;
  }
 
    public static void insertStandardPrice(List<Product2> listOfProducts)
    {
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> listOfstandardPriceEntry=new List<PricebookEntry>();
for(Product2 prod:listOfProducts)
{
PricebookEntry standardPrice = new PricebookEntry(
    Pricebook2Id = pricebookId, Product2Id = prod.Id,
    UnitPrice = 0, IsActive = true);
    listOfstandardPriceEntry.add(standardPrice);
    
}
insert listOfstandardPriceEntry;
    }
    
  public static  List<Product2> createProducts(List<String> listOfProductName)
  {
      List<Product2> listOfProduct=new List<Product2>();
      for(Integer i=0;i<listOfProductName.size();i++)
      {
          Product2 prod=new Product2();
          prod.Name=listOfProductName.get(i);
          prod.IsActive=true;
          listOfProduct.add(prod);
          
      }
      return listOfProduct;
  }
    
    public static List<Case> creatCases(List<Contact> contacts)
    {
        List<Case> listOfCases=new List<Case>();
        for(Contact con: contacts)
        {
            Case caseObj=new Case();
            caseObj.Status='Working';
            caseObj.Origin='Email';
            caseObj.ContactId=con.Id;
            listOfCases.add(caseObj);
        }
        return listOfCases;
    }
    
  public static List<Pricebook2>  createPriceBooks(List<String> listOfPriceBooks)
  {
      List<Pricebook2> pricebooks=new List<Pricebook2>();
      for(Integer i=0;i<listOfPriceBooks.size();i++)
      {
          Pricebook2 price=new Pricebook2();
          price.Name=listOfPriceBooks.get(i);
          price.IsActive=true;
          pricebooks.add(price);
      }
      return pricebooks;
  }
    
  public static List<PricebookEntry> createPriceBookEntry(List<Pricebook2> pricebooks,List<String> products,List<String> entryTypes)
  {
      List<PricebookEntry> listOfEntry=new List<PricebookEntry>();
 for( Integer i=0;i<pricebooks.size();i++)
 {
     PricebookEntry entry=new PricebookEntry();
     entry.Pricebook2Id=pricebooks.get(i).Id;
     entry.Product2Id=getRandomListValue(products,i);
     entry.Entry_Type__c=getRandomListValue(entryTypes,i);
     entry.UnitPrice=i+10;
     entry.IsActive=true;
     
     if(entry.Entry_Type__c.equals('ATM Fee in other currencies'))
     {
         entry.Currency_Type__c='percent'; 
     }
    
     
    else if(pricebooks.get(i).Name.contains('DE')||pricebooks.get(i).Name.contains('FR')||
       pricebooks.get(i).Name.contains('ES')||pricebooks.get(i).Name.contains('IT'))
     {
       entry.Currency_Type__c='EUR';  
     }
     else if(pricebooks.get(i).Name.contains('UK'))
     {
         entry.Currency_Type__c='GBP';  
     }
     
     listOfEntry.add(entry);
 }     
      return listOfEntry;
  }
    
    public static String  getRandomListValue(List<String> listOfVal,Integer counter)
    {
        if(counter>listOfVal.size()-1)
        {
            counter=0;
        }
        return listOfVal.get(counter);
    }

    
}