trigger TotalContactsOnAccount on Contact (after insert,after delete) {
    set<Id>ProcessAccounts = new set<Id>();
    if(Trigger.New!=null && Trigger.isInsert){
        for(Contact c : Trigger.New){
            if(c.AccountId!=null){
                ProcessAccounts.add(c.AccountId);
            }
        }
    }
    
    if(Trigger.Old!=null && Trigger.isDelete){
        for(Contact c : Trigger.Old){
            ProcessAccounts.add(c.AccountId);
        }
    }
    
    if(ProcessAccounts.size()>0){
        list<Account>UpdateAccounts = [SELECT Id,Total_Contacts__c,(SELECT Id FROM Contacts) FROM Account WHERE Id IN : ProcessAccounts];
        for(Account a : UpdateAccounts){
            a.Total_Contacts__c = a.Contacts.size();
        }
        if(UpdateAccounts.size()>0){
            update UpdateAccounts;
        }
    }
}