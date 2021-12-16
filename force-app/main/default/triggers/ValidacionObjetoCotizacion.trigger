trigger ValidacionObjetoCotizacion on Quote (before insert, before update, after update) {
	if(trigger.IsBefore && trigger.IsInsert){
        //No hay QuoteLineItem, se validan las Oportunidades
        ValidacionObjetoCotizacionHelper.CheckObjects(trigger.new);
    }
    if(trigger.IsBefore && trigger.IsUpdate){
        //Hay QuoteLineItem se valida el OpportunityLineItem
        ValidacionObjetoCotizacionHelper.CheckObjectsAfter(trigger.new);
    }
    if(trigger.IsAfter){
        ValidacionObjetoCotizacionHelper.DiscountOnInventory(trigger.new);
    }
}