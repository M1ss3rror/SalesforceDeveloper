@isTest
public class BatchTest {
	@IsTest
    //Se evalúa que no esté en blanco el método executable() del Batch en el que trae el inventario
    static void TBT(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        InventarioBatch Inventario = new InventarioBatch();
        Test.startTest();
        string t = Database.executeBatch(Inventario);
        Test.StopTest();
        system.assertEquals(false, string.IsBlank(t));
    }
}