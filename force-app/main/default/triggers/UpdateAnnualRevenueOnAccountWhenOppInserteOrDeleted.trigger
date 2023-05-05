trigger UpdateAnnualRevenueOnAccountWhenOppInserteOrDeleted on Opportunity (after insert,after delete) {
	set<Id>ProcessOpp = new set<Id>();
    if(Trigger.isInsert){
        for(Opportunity o : Trigger.New){
            if(o.AccountId!=null){
                ProcessOpp.add(o.AccountId);
            }
        }
    }
    
    if(Trigger.isDelete){
        for(Opportunity o : Trigger.Old){
            if(o.AccountId!=null){
                ProcessOpp.add(o.AccountId);
            }
        }
    }
    
    if(ProcessOpp.size()>0){
        list<Account>accs = [SELECT Id,AnnualRevenue,(SELECT Id,Amount FROM Opportunities) FROM Account WHERE Id IN: ProcessOpp];
        Decimal Count = 0;
        for(Account a : accs){
            for(Opportunity o : a.Opportunities){
                Count+=o.Amount;
            }
            a.AnnualRevenue=Count;
        }
        if(accs.size()>0){
            update accs;
        }
    }
}