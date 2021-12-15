public class ObtenerInventario {
	public static List<Inventario__c> ObtenerInventarioAPI(){
        List<Inventario__c> retorno = new List<Inventario__c>();
        Http Link = new Http();
        HttpRequest solicitud = new HttpRequest();
        solicitud.setEndpoint('https://64bjp0q5wg.execute-api.us-east-2.amazonaws.com/Implement/');
        solicitud.setMethod('GET');
        HttpResponse respuesta = Link.send(solicitud);
        if(respuesta.getStatusCode() == 200){
            // respuesta.getBody()--> trae el JSON
            InventarioModel inventwrapper = InventarioModel.parse(respuesta.getBody());
            //fAqui esta la lista de inventarios
            for(InventarioModel.Inventory item : inventwrapper.Body.Inventory){
                Inventario__c Inve = new Inventario__c();
                Inve.CodigoProd__c = item.ProductID;
                Inve.Name = item.Name;
                Inve.Cantidad_dis__c = item.Quan;
                Inve.Cantidad_apart__c = item.BlockedQuan;
                retorno.Add(Inve);
            }
        }
        return retorno;
    }
}