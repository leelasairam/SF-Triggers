trigger UpdateAccFieldWithLatestOppAmount on Opportunity (after insert) {
    set<Id>ProcessOpp = new set<Id>();
    
    for(Opportunity o : Trigger.New){
        if(o.AccountId != null){
            ProcessOpp.add(o.AccountId);
        }
    }
    
    if(ProcessOpp.size()>0){
        list<Account>accs = [SELECT Id,Latest_Opp_Amount__c,(SELECT Id,Amount FROM Opportunities ORDER BY CreatedDate DESC LIMIT 1) FROM Account WHERE Id IN: ProcessOpp];
        for(Account a : accs){
            if(a.Opportunities.size()>0){
                a.Latest_Opp_Amount__c = a.Opportunities[0].Amount;
            }
        }
        if(accs.size()>0){
            update accs;
        }
    }
}