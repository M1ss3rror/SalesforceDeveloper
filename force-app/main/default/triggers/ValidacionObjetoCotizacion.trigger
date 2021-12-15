trigger ValidacionObjetoCotizacion on Quote (before insert, before update, after update) {
	if(trigger.IsBefore && trigger.IsInsert){
        //There's no QLI, so that we check Opportunities
        ValidacionObjetoCotizacionHelper.CheckObjects(trigger.new);
    }
    if(trigger.IsBefore && trigger.IsUpdate){
        //There IS a QLI, so we check QuoteLineItems
        ValidacionObjetoCotizacionHelper.CheckObjectsAfter(trigger.new);
    }
    if(trigger.IsAfter){
        ValidacionObjetoCotizacionHelper.DiscountOnInventory(trigger.new);
    }
}