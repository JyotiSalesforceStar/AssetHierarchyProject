/* Class : AssetHierarchyController
* Created By : Jyoti Shinde
* Purpose : To retrive Asset hierarchy related to Account 
*/

public with sharing class AssetHierarchyController {
    
    /*Method Name : getAssetsHierarchy
	Return Type : List<HierarchyWrapperClass>
	Parameters  : id */
    @AuraEnabled
    public static List <HierarchyWrapperClass> getAssetsHierarchy(id accountId){
        try{
            List<HierarchyWrapperClass> assetWrapperList = new List<HierarchyWrapperClass>();
            List<Asset> listOfAssets = getListOfAssets(accountId);
            
            if(listOfAssets!=null && listOfAssets.size()>0){
                for(Asset asset : listOfAssets){
                    if(asset.ParentId == null){
                        HierarchyWrapperClass rootAssetWrap = new HierarchyWrapperClass();
                        rootAssetWrap.Name = asset.Name;
                        rootAssetWrap.ProductName = asset.Product2.Name;
                        rootAssetWrap.ProductFamily = asset.Product2.Family;
                        rootAssetWrap.ProductCode = asset.ProductCode;
                        rootAssetWrap.children = findRelations( listOfAssets, asset.RootAssetId ); //unessesory call need to be removed
                        assetWrapperList.add( rootAssetWrap );
                    }
                }
            }
            return assetWrapperList;
        }catch(Exception e){
            throw e;
        }
    }
    
    /*Method Name : getListOfAssets : to retrive Assets related to Account
	Return Type : List<Asset>
	Parameters  : id */
    private static List<Asset> getListOfAssets(id accountId){
       
        List<Asset> listOfAssets = new List<Asset>();
        if(accountId!=null){
            listOfAssets = [SELECT AccountId,Id,Name,ParentId,Product2Id,Product2.Family,Product2.Name,ProductCode,RootAssetId FROM Asset where AccountId =: accountId];
        }else{
            AuraHandledException ex = new AuraHandledException(Label.AccountIdIsNull);
            ex.setMessage(Label.AccountIdIsNull);
            throw ex;
        }
        return listOfAssets;
    }
    
    /*Method Name : findRelations : to retrive child Assets related to parent asset
	Return Type : List<HierarchyWrapperClass>
	Parameters  : List<Asset> and Id */
    private static List < HierarchyWrapperClass > findRelations( List <Asset> listAssets, Id rootAssetId ) {
        
        List <HierarchyWrapperClass> listWrap = new List <HierarchyWrapperClass>();        
        for ( Asset objAsset : listAssets ) {            
            if ( objAsset.ParentId == rootAssetId ) {                
                HierarchyWrapperClass wrap = new HierarchyWrapperClass();
                wrap.Name = objAsset.Name;
                wrap.ProductCode = objAsset.ProductCode;
                wrap.ProductName = objAsset.Product2.Name;
                wrap.ProductFamily = objAsset.Product2.Family;
                wrap.children = findRelations( listAssets, objAsset.Id );
                listWrap.add( wrap );                
            }            
        }
        
        if ( listWrap.size() > 0 )
            return listWrap;
        else 
            return listWrap;
        
    }
    
    //wrapper class to maintain Asset Hierarchy
    @TestVisible
    private class HierarchyWrapperClass {
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String ProductName;
        @AuraEnabled
        public String ProductCode;
        @AuraEnabled
        public String ProductFamily;
        @AuraEnabled
        public List <HierarchyWrapperClass> children;
    }
}