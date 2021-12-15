@isTest
public class BatchTest {
	@IsTest
    static void TBT(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        InventarioBatch Inventario = new InventarioBatch();
        Test.startTest();
        string t = Database.executeBatch(Inventario);
        Test.StopTest();
        system.assertEquals(false, string.IsBlank(t));
    }
}