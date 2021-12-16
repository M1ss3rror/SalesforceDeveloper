public class ValidacionObjetoCotizacionHelper {
    
     //Comprobar la oportunida de los productos cuando aún no se ha creado la Quote
    public static void CheckObjects(List<Quote> inQuotes){
        //Comparar OpportunityID de la Quote con el OpportunityID del OpportunityLineItem para ver si existe un producto o no.
        for(Quote newQuote : inQuotes){  
            if(newQuote.Status == 'Aprobado'){
                if([SELECT OpportunityId  FROM OpportunityLineItem WHERE OpportunityId =: newQuote.OpportunityId LIMIT 1].isEmpty()){
                	newQuote.AddError('No existe un producto');
                }
            }
            
        }
    }
    
    //Revisar si la Quote tiene estado aprobado y comparar con OpportunityID del OpportunityLineItem para ver si producto existe
    public static void CheckObjectsAfter(List<Quote> inQuotes){
        for(Quote newQuote : inQuotes){  
            if(newQuote.Status == 'Aprobado'){
                List<QuoteLineItem> LineItems = [SELECT QuoteId FROM QuoteLineItem WHERE QuoteId =: newQuote.Id];
                if(LineItems.isEmpty()){
                	newQuote.AddError('No existe un producto');
                }
            }
            
        }
    }
    
    //Actualizar el inventario si existe y coincide con el CodigoProd__c, sisi, entonces restará la cantidad correspondiente del campo Cantidad_dis__c del inventario
    public static void DiscountOnInventory(List<Quote> inQuotes){
        //If not approved, do nothing
        if(inQuotes[0].Status == 'Aprobado'){
            List<string> QuoteIDs = new List<string>();
            for(Quote newQuote : inQuotes){
                QuoteIDs.add(newQuote.Id);
            }
            List<QuoteLineItem> QLIs = [SELECT QuoteId, Product2Id, Quantity FROM QuoteLineItem WHERE QuoteId IN: QuoteIDs];
            List<string> ProductIDs = new List<string>();
            for(QuoteLineItem LineItem : QLIs){
                ProductIDs.add(LineItem.Product2Id);
            }
            List<Product2> Products = [SELECT Id, ProductCode FROM Product2 WHERE Id IN: ProductIDs];
            List<string> ProductCodes = new List<string>();
            for(Product2 Product: Products){
                ProductCodes.add(Product.ProductCode);
            }
            List<Inventario__c> InvArticles = [SELECT CodigoProd__c, Cantidad_dis__c FROM Inventario__c WHERE CodigoProd__c IN: ProductCodes];
                if(!InvArticles.IsEmpty()){
                    for(Inventario__c InvArticle : InvArticles){
                        for(QuoteLineItem LineItem: QLIs){
                            //Search LineItem By 
                            if(LineItem.Product2Id == [SELECT Id, ProductCode FROM Product2 WHERE ProductCode =: InvArticle.CodigoProd__c LIMIT 1][0].Id){
                                InvArticle.Cantidad_dis__c -= LineItem.Quantity;
                            }
                        }
                    }
                }
            update InvArticles;
        }
    }  
}