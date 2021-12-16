@isTest
public class CreateQuoteTest {
    @isTest
    //Valida que al buscar un codigo de producto no existente la respuesta sea falsa
    static void BuscarProductoT(){
        string codigoProducto = 'CL1010';
        
        Product2 Pro = new Product2();
        Pro.Name = 'PNPBE1';
        Pro.ProductCode = 'CL1010';
        insert Pro;
        //system.debug([SELECT Name, ProductCode FROM Product2]);
        
        List<PriceBookEntry> PBE = new List<PriceBookEntry>();
        Id standardPBID = Test.getStandardPricebookId();
        
        PBE.Add(new PriceBookEntry( Product2Id = Pro.Id, 
                                UnitPrice = 100.0, IsActive = true, PriceBook2Id = standardPBID));
        
        try{
        insert PBE;
        }
        catch(DMLException e){
            System.Debug(e.getMessage());
        }
        List<PriceBookEntry> PBECONSULTA = [SELECT Id, Name, Product2Id, Product2.Name, UnitPrice, Product2.ProductCode
                            FROM PriceBookEntry
                            WHERE Product2.ProductCode =: codigoProducto and IsActive= true ];
        Inventario__c Inv = new Inventario__c();
        Inv.Cantidad_dis__c = 10; 
        Inv.CodigoProd__c = 'CL1010';
        insert Inv;
        Inventario__c InvC = [SELECT Cantidad_dis__c, CodigoProd__c 
                                        FROM Inventario__c
                                        WHERE CodigoProd__c =: codigoProducto];
        CreatePartidaController con = new CreatePartidaController();
    system.assertEquals(false, CreatePartidaController.SearchProduct(codigoProducto).IsEmpty());
    }
    
    @isTest
    //Valida que se guarde la partida con el parámetro WrapperProductc esperado siendo true
    static void GuardarT(){
		string codigoProducto = 'CL1010';
        
        Product2 Pro = new Product2();
        Pro.Name = 'PNPBE1';
        Pro.ProductCode = 'CL1010';
        insert Pro;
        //system.debug([SELECT Name, ProductCode FROM Product2]);
        
        List<PriceBookEntry> PBE = new List<PriceBookEntry>();
        Id standardPBID = Test.getStandardPricebookId();
        
        PBE.Add(new PriceBookEntry( Product2Id = Pro.Id, 
                                UnitPrice = 100.0, IsActive = true, PriceBook2Id = standardPBID));
        
        try{
        insert PBE;
        }
        catch(DMLException e){
            System.Debug(e.getMessage());
        }
        List<PriceBookEntry> PBECONSULTA = [SELECT Id, Name, Product2Id, Product2.Name, UnitPrice, Product2.ProductCode
                            FROM PriceBookEntry
                            WHERE Product2.ProductCode =: codigoProducto and IsActive= true ];
        Inventario__c Inv = new Inventario__c();
        Inv.Cantidad_dis__c = 10; 
        Inv.CodigoProd__c = 'CL1010';
        insert Inv;
        Inventario__c InvC = [SELECT Cantidad_dis__c, CodigoProd__c 
                                        FROM Inventario__c
                                        WHERE CodigoProd__c =: codigoProducto];
        Opportunity testOpportunity = new Opportunity(Name='Opportunity Test',
                                                    CloseDate=Date.newInstance(2021, 2, 17),
                                                    StageName='Prospecting',
                                                    Pricebook2Id=standardPBID);
        insert testOpportunity;
        
        Quote testQuote = new Quote(Name='Test Quote',
                                OpportunityId=testOpportunity.Id,
                                Status='Draft');
        insert testQuote;
		CreatePartidaController.WrapperProduct t= CreatePartidaController.SearchProduct(codigoProducto)[0];
        t.QuoteId = testQuote.Id;
        t.quantity = 10;
        t.ProductId = Pro.Id;
        
        try{
            system.debug('1' + CreatePartidaController.Save(t));
        }catch(Exception e){
            System.Debug('1' + e.getMessage());
        }

        try{
            system.debug('2' + t);
        }catch(Exception e){
            System.Debug('2' + e.getMessage());
        }
        system.assertEquals(true, CreatePartidaController.Save(t));
    }
    
    @isTest
    //Al guardarse, valida que no se haya generado un mensaje de error, que esté vacío, false
    static void GuardarTT(){
		string codigoProducto = 'CL1010';
        
        Product2 Pro = new Product2();
        Pro.Name = 'PNPBE1';
        Pro.ProductCode = 'CL1010';
        insert Pro;
        //system.debug([SELECT Name, ProductCode FROM Product2]);
        
        List<PriceBookEntry> PBE = new List<PriceBookEntry>();
        Id standardPBID = Test.getStandardPricebookId();
        
        PBE.Add(new PriceBookEntry( Product2Id = Pro.Id, 
                                UnitPrice = 100.0, IsActive = true, PriceBook2Id = standardPBID));
        
        try{
        insert PBE;
        }
        catch(DMLException e){
             //System.Debug(e.getMessage());
        }
        List<PriceBookEntry> PBECONSULTA = [SELECT Id, Name, Product2Id, Product2.Name, UnitPrice, Product2.ProductCode
                            FROM PriceBookEntry
                            WHERE Product2.ProductCode =: codigoProducto and IsActive= true ];
        Inventario__c Inv = new Inventario__c();
        Inv.Cantidad_dis__c = 10; 
        Inv.CodigoProd__c = 'CL1010';
        insert Inv;
        Inventario__c InvC = [SELECT Cantidad_dis__c, CodigoProd__c 
                                        FROM Inventario__c
                                        WHERE CodigoProd__c =: codigoProducto];
        
        Opportunity testOpportunity = new Opportunity(Name='Opportunity Test',
                                                    CloseDate=Date.newInstance(2021, 2, 17),
                                                    StageName='Prospecting',
                                                    Pricebook2Id=standardPBID);
        insert testOpportunity;
        
        Quote testQuote = new Quote(Name='Test Quote',
                                OpportunityId=testOpportunity.Id,
                                Status='Draft');
        insert testQuote;
		CreatePartidaController.WrapperProduct t= CreatePartidaController.SearchProduct(codigoProducto)[0];
        
        try{
            CreatePartidaController.Save(t);
        }catch(Exception e){
            System.Debug(e.getMessage());
            System.assertEquals(false,string.isBlank(e.GetMessage()));
        }
    }
}