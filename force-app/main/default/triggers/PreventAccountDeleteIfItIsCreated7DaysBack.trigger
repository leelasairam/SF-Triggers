trigger PreventAccountDeleteIfItIsCreated7DaysBack on Account (before delete) {
    list<Account>ProcessAccs = new list<Account>();
    
    for(Account a : Trigger.old){
        ProcessAccs.add(a);
    }
    
    if(ProcessAccs.size()>0){
        for(Account a : ProcessAccs){
            Integer Diff = (a.Createddate.date()).daysBetween(system.today());
            if(Diff > 7){
                a.addError('You cannot delete this account because it was created 7 days back');
            }
        }
    }
}