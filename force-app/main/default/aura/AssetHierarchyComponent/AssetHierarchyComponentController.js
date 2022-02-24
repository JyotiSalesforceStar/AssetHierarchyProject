({
    init: function (cmp,event,helper) {
        helper.getAccountsAssetHierarchy(cmp,event,helper);
    },
    
    expandAllAssets: function(cmp, event,helper) {
        helper.expandAllAssets(cmp, event,helper);
    },
    
    collapseAllAssets: function(cmp, event,helper) {
        helper.collapseAllAssets(cmp, event,helper);
    }
})