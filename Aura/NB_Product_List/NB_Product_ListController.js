({
    
    doInit : function(component, event, helper) {
	helper.findPriceBookEntries(component);
	},
    
    handleOnChangeProduct:function(component, event, helper) {
        
        helper.onChangeProductHelper(component,event.getSource().get("v.value"));
    },
    
      handleOnSave:function(component, event, helper) {
        
        helper.updateProductRecords(component);
    },
    
    
	handleBtnClick : function(component, event, helper) {  
   helper.btnClickHelper(event,component);
	}
})