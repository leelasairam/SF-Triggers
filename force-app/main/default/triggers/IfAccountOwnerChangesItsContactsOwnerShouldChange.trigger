trigger IfAccountOwnerChangesItsContactsOwnerShouldChange on Account (after Update) {
    set<Id>ProcessAccs = new set<Id>();
    
    for(Account a : Trigger.New){
        if(a.OwnerId != Trigger.oldMap.get(a.Id).OwnerId){
            ProcessAccs.add(a.Id);
        }
    }
    
    if(ProcessAccs.size()>0){
        list<Account>accs = [SELECT Id,(SELECT Id,OwnerId,Account.OwnerId FROM Contacts) FROM Account WHERE Id IN: ProcessAccs];
        list<Contact>contacts= new list<Contact>();
        for(Account a : accs){
            if(a.Contacts.size()>0){
                for(Contact c : a.Contacts){
                    c.OwnerId = c.Account.OwnerId;
                    contacts.add(c);
                }
            } 
        }
        
        if(contacts.size()>0){
            update contacts;
        }
    }
}