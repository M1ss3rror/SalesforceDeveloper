public class InventarioBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    public List<Inventario__c> start(Database.BatchableContext BC){
        return ObtenerInventario.ObtenerInventarioAPI();
    }
    public void execute(Database.BatchableContext BC, List<Inventario__c> inventarios){
        try {
            upsert inventarios CodigoProd__c;
        } catch (DMLException error) {
            System.debug(error.getMessage());
        }
    }
    public void finish(Database.BatchableContext BC){
        
    }
}