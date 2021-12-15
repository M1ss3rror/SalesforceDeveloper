public class InventarioModel {
	 public Integer statusCode;
     public Body body;

    public class Body {
        public List<Inventory> Inventory;
    }

    public class Inventory {
        public String name;
        public String ProductID;
        public Integer Quan;
        public Integer BlockedQuan;
    }

    public static InventarioModel parse(String json){
		return (InventarioModel) System.JSON.deserialize(json, InventarioModel.class);
	}
}