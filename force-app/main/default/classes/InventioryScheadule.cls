global class InventioryScheadule implements Schedulable{
    global void execute(SchedulableContext SC) {
        InventarioBatch Inventario = new InventarioBatch();
        Id BatchId = Database.executeBatch(Inventario);
    }
}