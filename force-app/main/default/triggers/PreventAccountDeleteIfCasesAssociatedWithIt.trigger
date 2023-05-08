trigger PreventAccountDeleteIfCasesAssociatedWithIt on Account (before delete) {
    set<Id>ProcessAccount = new set<Id>();
    for(Account a : Trigger.old){
        ProcessAccount.add(a.Id);
    }
    
    if(ProcessAccount.size()>0){
        list<Account>acc = [SELECT Id,(SELECT Id FROM Cases) FROM Account WHERE Id IN: ProcessAccount];
        for(Account a : acc){
            if(a.Cases.size()>0){
                //Here added "Trigger.oldMap.get(a.Id)" because addError won't support if loop through list.
                Trigger.oldMap.get(a.Id).addError('You cannot delete this account beacuse this associated with cases');
            }
        }
    }
}