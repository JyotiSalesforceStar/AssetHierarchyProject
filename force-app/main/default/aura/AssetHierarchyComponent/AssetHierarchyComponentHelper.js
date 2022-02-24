({
    getAccountsAssetHierarchy : function (cmp,event,helper) {
        //can we pull it from custom metadata 
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
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    
    expandAllAssets: function(cmp, event,helper) {
        let button = event.getSource();
        button.set('v.disabled',true);
        let button1 = cmp.find('collapseAllId');
        button1.set('v.disabled',false);        
        var tree = cmp.find('mytree');
        tree.expandAll();        
    },
    
    collapseAllAssets: function(cmp, event,helper) {
        
        let button = event.getSource();
        button.set('v.disabled',true);
        let button1 = cmp.find('expandAllId');
        button1.set('v.disabled',false);        
        var tree = cmp.find('mytree');
        tree.collapseAll();
    },
})