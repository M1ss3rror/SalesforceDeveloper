public with sharing class CreatePartidaController {
    // este método hace...
    //OJITO: faltan las pruebas unitarias!!!! ;D
    @AuraEnabled(cacheable=true)
    public static List<wrapperProduct> SearchProduct(string searchText){
        // aquí hace falta el try catch
        system.debug('codigo' + searchText);
        List<PricebookEntry> entradas = new List<PricebookEntry>();
        entradas = [SELECT Id,Product2Id, Product2.Name, UnitPrice, Product2.ProductCode
                    FROM PricebookEntry 
                    WHERE isActive = true AND Product2.ProductCode =: searchText];
        System.debug('entradas-->'+entradas);
        List<Inventario__c> inventarios = new List<Inventario__c>();
        inventarios = [SELECT Cantidad_dis__c, CodigoProd__c
                    FROM Inventario__c
                    WHERE CodigoProd__c =: searchText];
        System.debug('inventarios-->'+inventarios);
        List<wrapperProduct> productos = new List<wrapperProduct>();
        for(PricebookEntry entrada : entradas){
            for(Inventario__c inventario : inventarios){
                if( entrada.Product2.ProductCode == inventario.CodigoProd__c){
                    wrapperProduct producto = new wrapperProduct();
                    producto.pricebookentryid = entrada.Id;
                    producto.productName = entrada.Product2.Name;
                    producto.unitPrice = entrada.UnitPrice;
                    producto.productCode = inventario.CodigoProd__c;
                    producto.available = Integer.valueOf(inventario.Cantidad_dis__c);
                    productos.add(producto);
                }
            }
        }
        return productos;
    }
    @AuraEnabled
    public static boolean Save (wrapperProduct partida){
        Boolean response = false;
        try {
            QuoteLineItem item = new QuoteLineItem();
            item.pricebookentryid = partida.pricebookentryid;
            item.Product2Id = partida.productId;
            item.Quantity = partida.quantity;
            item.QuoteId = partida.quoteId;
            item.UnitPrice = partida.unitPrice;
            insert item;
            response = true;
            
        } catch (DMLException e) {
            throw new AuraHandledException('Algo salio mal: '+e.getMessage());
        }
        return response;
    }
    public class wrapperProduct{
        @AuraEnabled
        public string productName {get; set;}
        @AuraEnabled
        public decimal unitPrice {get; set;}
        @AuraEnabled
        public integer available {get; set;}
        @AuraEnabled
        public string productCode {get; set;}
        @AuraEnabled
        public integer quantity {get; set;}
        @AuraEnabled
        public string productId {get; set;}
        @AuraEnabled
        public string quoteId {get; set;}
        @AuraEnabled
        public string pricebookentryid {get; set;}
    }
    }