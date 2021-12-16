@isTest
private class TestQuoteInvTrigger {
    //Si el método CheckObjects falla...
    @isTest static void TestCheckObjectsBeforeFailure(){
        //Revisar configuración de datos
        Opportunity testOpportunity = new Opportunity(Name='Opportunity Test',
                                                    CloseDate=Date.newInstance(2021, 2, 17),
                                                    StageName='Prospecting');
        insert testOpportunity;
        Quote testQuote = new Quote(Name='Test Quote',
                                OpportunityId=testOpportunity.Id,
                                Status='Aprobado');
        
        Test.startTest();
        //inserta una testQuote o trae la exception y el mensaje de error esperado mostrándolo en el Debug si el try falla
        Database.SaveResult result;
        try{
            insert testQuote; //No failures allowed
        }catch(Exception e){
            System.Debug(e.getMessage());
            System.assert(e.GetMessage().Contains('No existe un producto'));
        }
        Test.stopTest();
    }
    
    //Si el método CheckObjects no falla
    @isTest static void TestCheckObjectsBeforeSuccess(){
        //No admite fallas
        Opportunity testOpportunity = new Opportunity(Name='Opportunity Test',
                                                    CloseDate=Date.newInstance(2021, 2, 17),
                                                    StageName='Prospecting');
        insert testOpportunity;
        Product2 testProduct = new Product2(Name='Test Product',
                                        ProductCode='TEST01');
        insert testProduct;
        Id standardPBID = Test.getStandardPricebookId();
        PricebookEntry testPricebookEntry = new PricebookEntry(Product2Id=testProduct.Id,
                                                            Pricebook2Id=standardPBID,
                                                            UnitPrice=12.2,
                                                            IsActive=true);
        insert testPricebookEntry;
        //inserta una OLITest o trae la exception y la muestra en el Debug si el try falla
        try{
            OpportunityLineItem OLITest = new OpportunityLineItem(OpportunityId=testOpportunity.Id,
                                                                    Quantity=8,
                                                                    TotalPrice=12.2,
                                                                    PricebookEntryId=testPricebookEntry.Id,
                                                                    Product2Id=testProduct.Id);
        insert OLITest;            
        }catch(Exception e){
            System.Debug(e.getMessage());
        }
        Quote testQuote = new Quote(Name='Test Quote',
                                OpportunityId=testOpportunity.Id,
                                Status='Aprobado');
        Test.startTest();
        Database.SaveResult result = Database.insert(testQuote, true);
        Test.stopTest();
        //Verify
		System.assert(result.isSuccess()); //Should NOT be an error
        System.assertEquals(true, result.getErrors().isEmpty());
    }
    
    //Si el metodo CheckObjectsAfter falla
    @isTest static void TestCheckObjectsAfterFailure(){
        Id standardPBID = Test.getStandardPricebookId();
        Opportunity testOpportunity = new Opportunity(Name='Opportunity Test',
                                                    CloseDate=Date.newInstance(2021, 2, 17),
                                                    StageName='Prospecting',
                                                    Pricebook2Id=standardPBID);
        insert testOpportunity;
        Product2 testProduct = new Product2(Name='Test Product',
                                        ProductCode='TEST01');
        insert testProduct;
        PricebookEntry testPricebookEntry = new PricebookEntry(Product2Id=testProduct.Id,
                                                            Pricebook2Id=standardPBID,
                                                            UnitPrice=12.2,
                                                            IsActive=true);
        insert testPricebookEntry;
        OpportunityLineItem OLITest = new OpportunityLineItem(OpportunityId=testOpportunity.Id,
                                                            Quantity=8,
                                                            TotalPrice=12.2,
                                                            PricebookEntryId=testPricebookEntry.Id,
                                                            Product2Id=testProduct.Id);
        try{
            insert OLITest;
        }catch(Exception e){
            System.Debug(e.getMessage());
        }
        //Cree el presupuesto en "Borrador" para evitar el primer error y luego cámbielo a "Aprobado".
        Quote testQuote = new Quote(Name='Test Quote',
                                OpportunityId=testOpportunity.Id,
                                Status='Borrador');
        insert testQuote;
        //Update Status
        testQuote.Status = 'Aprobado';
        
        Test.startTest();
        try{
            update testQuote;
        }catch(Exception e){
            System.assert(e.GetMessage().Contains('No existe un producto'));
        }
        Test.stopTest();
    }
    //Si el método CheckObjects no falla...
    @isTest static void TestCheckObjectsAfterSuccess(){
       	//Test data setup
        Id standardPBID = Test.getStandardPricebookId();
        Opportunity testOpportunity = new Opportunity(Name='Opportunity Test',
                                                    CloseDate=Date.newInstance(2021, 2, 17),
                                                    StageName='Prospecting',
                                                    Pricebook2Id=standardPBID);
        insert testOpportunity;
        Product2 testProduct = new Product2(Name='Test Product',
                                        ProductCode='TEST01');
        insert testProduct;
        
        PricebookEntry testPricebookEntry = new PricebookEntry(Product2Id=testProduct.Id,
                                                            Pricebook2Id=standardPBID,
                                                            UnitPrice=12.2,
                                                            IsActive=true);
        insert testPricebookEntry;
        OpportunityLineItem OLITest = new OpportunityLineItem(OpportunityId=testOpportunity.Id,
                                                            Quantity=8,
                                                            TotalPrice=12.2,
                                                            PricebookEntryId=testPricebookEntry.Id,
                                                            Product2Id=testProduct.Id);
		insert OLITest;
        
        
        Quote testQuote = new Quote(Name='Test Quote',
                                OpportunityId=testOpportunity.Id,
                                Status='Borrador');
        insert testQuote;
        //Create QLI before the Quote to avoid error.
        QuoteLineItem QLITest = new QuoteLineItem(QuoteId=testQuote.Id,
                                                PricebookEntryId = testPricebookEntry.Id,
                                                Quantity = 8,
                                                UnitPrice = 12.2,
                                                Product2Id = testProduct.Id);
        try{        
        insert QLITest;
        }catch(Exception e){
            System.Debug(e.getMessage());
        }
        
        testQuote.Status = 'Aprobado';
        
        //Perform test
        Test.startTest();
        Database.SaveResult result = Database.update(testQuote, true); //No failures allowed
        Test.stopTest();
        
        //Verify
		System.assert(result.isSuccess()); //Should NOT be an error
        System.assertEquals(true, result.getErrors().isEmpty());
    }
    //Comparar resultados esperado y resultados obtenidos del método DiscountOnInventory
    @isTest static void TestDiscountOnInventory(){
        Id standardPBID = Test.getStandardPricebookId();
        Opportunity testOpportunity = new Opportunity(Name='Opportunity Test',
                                                    CloseDate=Date.newInstance(2021, 2, 17),
                                                    StageName='Prospecting',
                                                    Pricebook2Id=standardPBID);
        insert testOpportunity;
        Product2 testProduct = new Product2(Name='Test Product',
                                        ProductCode='TEST01');
        insert testProduct;
        Inventario__c testInv = new Inventario__c(Name='Test Product',
                                                CodigoProd__c='TEST01',
                                                Cantidad_dis__c=75);
        insert testInv;
        
        PricebookEntry testPricebookEntry = new PricebookEntry(Product2Id=testProduct.Id,
                                                            Pricebook2Id=standardPBID,
                                                            UnitPrice=12.2,
                                                            IsActive=true);
        System.Debug('----Checkpoint 2----');
        insert testPricebookEntry;
        OpportunityLineItem OLITest = new OpportunityLineItem(OpportunityId=testOpportunity.Id,
                                                            Quantity=8,
                                                            TotalPrice=12.2,
                                                            PricebookEntryId=testPricebookEntry.Id,
                                                            Product2Id=testProduct.Id);
        insert OLITest;
        
        Quote testQuote = new Quote(Name='Test Quote',
                                OpportunityId=testOpportunity.Id,
                                Status='Aprobado');
        System.Debug('----Checkpoint 1----');
        System.Debug('----Checkpoint 0----');
        //Perform test
        Test.startTest();        
        Database.SaveResult result = Database.insert(testQuote, true); //No failures allowed
        
        QuoteLineItem QLITest = new QuoteLineItem(QuoteId=testQuote.Id,
                                                PricebookEntryId = testPricebookEntry.Id,
                                                Quantity=8,
                                                UnitPrice = 12.2,
                                                Product2Id = testProduct.Id);
        insert QLITest; 
        
        Test.stopTest();
        System.assert(result.isSuccess()); //Should NOT be an error
        System.assertEquals(true, result.getErrors().isEmpty());
        
    }    
}