({
    getAccountsAssetHierarchy : function (cmp,event,helper) {
        var columns = [
            {
                type: 'text',
                fieldName: 'Name',
                label: 'Asset Name'
            },
            {
                type: 'text',
                fieldName: 'ProductName',
                label: 'Product Name'
            },
            {
                type: 'text',
                fieldName: 'ProductCode',
                label: 'Product Code'
            },
            {
                type: 'text',
                fieldName: 'ProductFamily',
                label: 'Product Family'
            }
        ];
        
        var action = cmp.get("c.getAssetsHierarchy");
        action.setParams({
            "accountId": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                
                if(data.length>0){
                    cmp.set("v.gridDataIsExists",true);
                    var parsedData = JSON.parse( JSON.stringify( data ).split( 'children' ).join( '_children' ) );
                    cmp.set("v.gridColumns", columns);
                    cmp.set("v.gridData", parsedData);
                }
            } else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error',
                                message: errors[0].message,
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    expandCollapseAllAssets: function(cmp, event,helper) {
        let button = event.getSource();
        button.set('v.disabled',true);
        var buttonName = event.getSource().get("v.name"); // return myButton
        let button1;
        var tree = cmp.find('mytree');
        if(buttonName === 'Expand All'){
            button1 = cmp.find('collapseAllId');
            tree.expandAll(); 
        }else{
            button1 = cmp.find('expandAllId');
            tree.collapseAll();
        }
        button1.set('v.disabled',false);   
   }    
  
})