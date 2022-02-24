@isTest(seeAllData = false)
public without sharing class AssetHierarchyControllerTest {

    @testSetup static void setupAssetHandler(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        List<Product2> productsToInsert = new List<Product2>();
        Product2 prod1 = new Product2();
        prod1.Name = 'SolarSystem';
        prod1.ProductCode = 'SS001';
        prod1.Family = 'Package';
        productsToInsert.add(prod1);
        
        Product2 prod2 = new Product2();
        prod2.Name = 'Mounting System';
        prod2.ProductCode = 'SS002';
        prod2.Family = 'Package';
        productsToInsert.add(prod2);
        
        insert productsToInsert;
        
        List<Asset> assetList = new List<Asset>();
        
        Asset ass1 = new Asset();
        ass1.Name = 'Solar System Asset';
        ass1.AccountId = acc.id;
        ass1.Product2Id = prod1.id;
        assetList.add(ass1);
        
        Asset ass2 = new Asset();
       	ass2.Name = 'Mounting systems Asset';
		ass2.AccountId = acc.id;
        ass2.Product2Id = prod2.id;
        assetList.add(ass2);
        
        insert assetList;
        
        ass2.ParentId = ass1.id;
        update ass2;
        
    } 
    
    @istest 
    public static void getAssetsHierarchyTestPositive(){        
       	Test.startTest();
        Account acc = [select id from Account where Name='Test Account' limit 1];
        List <AssetHierarchyController.HierarchyWrapperClass> resultReturned = AssetHierarchyController.getAssetsHierarchy(acc.id);
        System.assert(resultReturned!=null);
        System.assertEquals(1, resultReturned.size());
        Test.stopTest();
    }
    
    //negative Testcase
     @istest 
    public static void getAssetsHierarchyTestNegative(){        
       	Test.startTest();
        try{
        	List <AssetHierarchyController.HierarchyWrapperClass> resultReturned = AssetHierarchyController.getAssetsHierarchy(null);
        }
        catch(AuraHandledException e){
            System.assertEquals(Label.AccountIdIsNull,e.getMessage());
        }       
        Test.stopTest();
    }
}