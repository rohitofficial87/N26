({
     callServerAction: function (component, apex, callBacks,helper) {
      

        var action = component.get(apex.methodName);
        if (apex.params) {
            action.setParams(apex.params);
        }
         if(apex.isStorable)
         {
             action.setStorable();
         }
         
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                if (callBacks.successStateCallback) { 
                   callBacks.successStateCallback(component,helper,result);
                }
            } else if (response.getState() === "ERROR") {
                if (callBacks.failureStateCallback) {
                    callBacks.failureStateCallback(JSON.stringify(response.getError()));
                }
            } else if (response.getState() === "INCOMPLETE") {
                if (callBacks.incompleteStateCallback) {
                    var message = "The server didn’t return a response. The server might be down or the client might be offline";
                    callBacks.failureStateCallback(message);
                }
            }
        });
        $A.enqueueAction(action);
    },
})