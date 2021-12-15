public class OpportunityHandler {
    private Opportunity oppty;
    
    public OpportunityHandler(id opptyId){
        if(opptyId != null){
            oppty = [SELECT Id, AccountId, Name, StageName, Amount, CloseDate, IsClosed, IsWon 
                    FROM Opportunity];
        }
    }
    
    public OpportunityHandler(string name, string stageName){
        closeDate = closeDate == null ? Date.today().addDays(30) : closeDate;
        stageName = stageName == null ? 'Prospecting' : stageName;
        oppty = new Opportunity(Name = name, CloseDate = closeDate, StageName = stageName);
    }
    
    public static Opportunity QueryOpportunityById(id opptyId){
        Opportunity queryOppty = new Opportunity();
        if(opptyId != null){
            queryOppty = [SELECT Id, AccountId, Name, StageName, Amount, CloseDate, IsClosed, IsWon 
                        FROM Opportunity
                        WHERE id =: opptyId];
        }
        return queryOppty;
    }
    
    public static Opportunity QueryOpportunityByAccount(id acctId){
        Opportunity queryOppty = new Opportunity();
        if(acctId != null){
            queryOppty = [SELECT Id, AccountId, Name, StageName, Amount, CloseDate, IsClosed, IsWon 
                        FROM Opportunity
                        WHERE AccountId =: acctId];
        }
        return queryOppty;
    }
    
    public Opportunity DiscountOpportunity(decimal discount){
        oppty.Amount = oppty.Amount * (1 - discount);
        return oppty;
    }
    
    public Boolean upsertOpportunity (string name, date closeDate, string stageName){
        Boolean response = false;
        try {
            oppty.Name = name;
            oppty.CloseDate = closeDate;
            oppty.StageName = stageName;
            oppty.Amount = amount;
            
            upsert oppty;
            response = true;
            return response;
        } catch (Exception ex){
            System.debug('Exception: '+ ex.getMessage());
            return response;
        }
    }
}