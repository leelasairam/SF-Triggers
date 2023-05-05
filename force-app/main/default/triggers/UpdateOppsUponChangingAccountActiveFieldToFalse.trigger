trigger UpdateOppsUponChangingAccountActiveFieldToFalse on Account (after update) {
	set<Id>ProcessAccounts = new set<Id>();
    for(Account a : Trigger.New){
        if(a.Active__c!=Trigger.oldMap.get(a.Id).Active__c && a.Active__c=='No'){
            ProcessAccounts.add(a.Id);
        }
    }
    if(ProcessAccounts.size()>0){
        list<Account>accs = [SELECT Id,(SELECT Id,StageName FROM Opportunities) FROM Account WHERE Id IN : ProcessAccounts];
        list<Opportunity>UpdateOpps=new list<Opportunity>();
        for(Account a : accs){
            for(Opportunity o : a.Opportunities){
                if(o.StageName!='Closed Won'){
                    o.StageName='Closed Lost';
                	UpdateOpps.add(o);
                }
            }
        }
        if(UpdateOpps.size()>0){
            Update UpdateOpps;
        }
        
    }
}