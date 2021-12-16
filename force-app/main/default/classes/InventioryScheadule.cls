global class InventioryScheadule implements Schedulable{
    //Ejecuta Batch
    global void execute(SchedulableContext SC) {
        InventarioBatch Inventario = new InventarioBatch();
        Id BatchId = Database.executeBatch(Inventario);
    }
}