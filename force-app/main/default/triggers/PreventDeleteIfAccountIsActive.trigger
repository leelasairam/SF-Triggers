trigger PreventDeleteIfAccountIsActive on Account (before delete) {
    list<Account>ProcessAccs = new list<Account>();
    
    for(Account a : Trigger.Old){
        ProcessAccs.add(a);
    }
    
    if(ProcessAccs.size()>0){
        for(Account a : ProcessAccs){
            if(a.Active__c=='Yes'){
                Trigger.oldMap.get(a.Id).addError('Account ['+a.Name+'] is active you cannot delete');
            }
        }
    }
}