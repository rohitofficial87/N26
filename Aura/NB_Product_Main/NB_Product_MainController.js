({

    handleBtnClickEvent : function(component, event, helper) {
	var childAuraObj=component.find("productList");
    var btnName = event.getSource().get("v.name");
        
             if(btnName=='edit')     
             {
          	childAuraObj.onbtnClick(false,false);
                 component.set("v.isReadOnly",false);
             }
        
        else if(btnName=='cancel')
        {
            childAuraObj.onbtnClick(true,false);
             component.set("v.isReadOnly",true);
        }    
            else if(btnName=='save')
            {
            childAuraObj.onbtnClick(true,true);
             component.set("v.isReadOnly",true);    
            }
   
        
	}
})