({
    
    
 btnClickHelper: function (event,component)
    {
    
          var params = event.getParam('arguments');
        
          if (params) {
              component.set("v.isReadOnly",params.isReadOnly);
              
         
             if(params.isSave)
             {
                 this.updateProductRecords(component);
             }
              
        }
		
},
  
    updateProductRecords : function(component) {
     
         var apex = new Object();
          apex.isStorable=false;
        apex.methodName = "c.updateContactAndProduct";
        console.log("Before Update >>"+JSON.stringify(component.get("v.resultData")));
        
        apex.params = { "priceBookChanges": component.get("v.resultData"),
                       "contactId": component.get("v.contactId"),
                       "homeCountry": component.get("v.homeCountry")    };   
        var callBacks = new Object();
        callBacks.successStateCallback = this.successPriceChange;
        callBacks.failureStateCallback = this.failureStateCallback;
        this.callServerAction(component,apex,callBacks,this);    
	},   
    
    
    
 onChangeProductHelper : function(component,productId) {
       
         var apex = new Object();
        apex.methodName = "c.searchPriceEntry";
        apex.params = { "productId": productId,
                       "homeCountry": component.get("v.homeCountry") };   
        apex.isStorable=true;
        var callBacks = new Object();
        callBacks.successStateCallback = this.successPriceChange;
        callBacks.failureStateCallback = this.failureStateCallback;
        this.callServerAction(component,apex,callBacks,this);
        
       
        
	},   
    
      successPriceChange: function (component,helper,result) {
         
       console.log("result priceBook >>"+JSON.stringify(result));
     var mapofEntryTypeAndPriceList=helper.getMapOfEntryTypesWithPriceList(result); 
       component.set("v.mapofEntryTypeAndPriceList",mapofEntryTypeAndPriceList);
      },    
    
    
findPriceBookEntries : function(component) {
        console.log("case Id >>",component.get("v.recordId"));
         var apex = new Object();
        apex.methodName = "c.getProductPriceDetails";
        apex.params = { "caseId": component.get("v.recordId")}; 
        var callBacks = new Object();
        callBacks.successStateCallback = this.successPriceBookCallback;
        callBacks.failureStateCallback = this.failureStateCallback;
        this.callServerAction(component,apex,callBacks,this);
        
       
        
	},

      successPriceBookCallback: function (component,helper,result) {
       console.log("result priceBook >>"+JSON.stringify(result));
     var mapofEntryTypeAndPriceList=helper.getMapOfEntryTypesWithPriceList(result.listOfPriceBookEntry);   
          component.set("v.mapofEntryTypeAndPriceList",mapofEntryTypeAndPriceList);
           component.set("v.resultData",result.listOfPriceBookEntry);
           component.set("v.homeCountry",result.homeCountry); 
           component.set("v.productCode",result.productCode); 
           component.set("v.contactId",result.contactId);
           component.set("v.listOfAllProducts",result.listOfAllProducts);
 
      },

        failureStateCallback: function (errorMsg) {
       
      },
    
    
    /**
     * This function gives a pair of Entry_type like Card Replacement Cost,ATM Fee in other currencies
     * or Cost per Calendar Month with the correponding price list.
     * Note:It has been implented in javascript rather than Map to improve performance and also reduce server time.
     * */
    getMapOfEntryTypesWithPriceList: function (priceList) {
   
      var mapofEntryTypeAndPriceList=[];
       var listOfSortedPrices=[]; 
        var previousKey;
      
        
     for(var i=0;i<priceList.length;i++)
     {   
         var newKey=priceList[i].Entry_Type__c;
        if($A.util.isEmpty(previousKey)==false
          &&previousKey!=newKey)
        {
          var insertObj=new Object();
         insertObj.EntryType=previousKey;
         insertObj.sortedList=listOfSortedPrices;               
         mapofEntryTypeAndPriceList.push(insertObj);
             
        listOfSortedPrices=[]; 
        }
       listOfSortedPrices.push(priceList[i]);  
        if(i+1==priceList.length)
         {
            var insertObj=new Object();
         insertObj.EntryType=newKey;
         insertObj.sortedList=listOfSortedPrices;               
         mapofEntryTypeAndPriceList.push(insertObj);  
         }         
        previousKey= priceList[i].Entry_Type__c;
         
     }
console.log("Sorted Map "+JSON.stringify(mapofEntryTypeAndPriceList));
        return mapofEntryTypeAndPriceList;
     },
})