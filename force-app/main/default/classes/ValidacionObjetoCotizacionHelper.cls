public class ValidacionObjetoCotizacionHelper {
    
     //Check Before (When the Quote is not inserted already, so we need to check de opportunity for the products)
    public static void CheckObjects(List<Quote> inQuotes){
        //Take the Quotes (Presupuestos), check if Status == 'Approved'.
        //Compare the Quote's OpportunityID with the OpportunityLineItem's OpportunityID to find if a product exists.
        for(Quote newQuote : inQuotes){  
            if(newQuote.Status == 'Aprobado'){
                if([SELECT OpportunityId  FROM OpportunityLineItem WHERE OpportunityId =: newQuote.OpportunityId LIMIT 1].isEmpty()){
                	newQuote.AddError('No existe un producto');
                }
            }
            
        }
    }
    
    //Check After
    public static void CheckObjectsAfter(List<Quote> inQuotes){
        //Take the Quotes (Presupuestos), check if Status == 'Approved'.
        //Compare the Quote's OpportunityID with the OpportunityLineItem's OpportunityID to find if a product exists.
        for(Quote newQuote : inQuotes){  
            if(newQuote.Status == 'Aprobado'){
                List<QuoteLineItem> LineItems = [SELECT QuoteId FROM QuoteLineItem WHERE QuoteId =: newQuote.Id];
                if(LineItems.isEmpty()){
                	newQuote.AddError('No existe un producto');
                }
            }
            
        }
    }
    
    //Update Inventory
    public static void DiscountOnInventory(List<Quote> inQuotes){
        //If not approved, do nothing
        if(inQuotes[0].Status == 'Aprobado'){
            //Take QLIs, with them we search for a product that matches the CodigoProd__c
            //If exists, substract the corresponding Cantidad_dis__c
            
            //Take QuoteIDs
            List<string> QuoteIDs = new List<string>();
            for(Quote newQuote : inQuotes){
                QuoteIDs.add(newQuote.Id);
            }
            
            //Take QLIs Product Codes
            //Take QLI based on QuoteID
            List<QuoteLineItem> QLIs = [SELECT QuoteId, Product2Id, Quantity FROM QuoteLineItem WHERE QuoteId IN: QuoteIDs];
            List<string> ProductIDs = new List<string>();
            for(QuoteLineItem LineItem : QLIs){
                ProductIDs.add(LineItem.Product2Id);
            }
            
            //Take ProductCode based on QLI's productIDs
            List<Product2> Products = [SELECT Id, ProductCode FROM Product2 WHERE Id IN: ProductIDs];
            List<string> ProductCodes = new List<string>();
            for(Product2 Product: Products){
                ProductCodes.add(Product.ProductCode);
            }
            
            //Only InvArticles that exist on our QLI
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