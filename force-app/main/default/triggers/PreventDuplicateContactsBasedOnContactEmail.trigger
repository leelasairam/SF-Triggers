trigger PreventDuplicateContactsBasedOnContactEmail on Contact (before insert) {
    set<String>ProcessContacts = new set<String>();
    
    for(Contact c : Trigger.New){
        if(c.Email!=null){
            ProcessContacts.add(c.Email);
        }
    }
    
    if(ProcessContacts.size()>0){
        list<Contact>contacts = [SELECT Id, Email FROM Contact WHERE Email IN: ProcessContacts];
        list<String>Emails = new list<String>();
        if(contacts.size()>0){
            for(Contact c : contacts){
                Emails.add(c.Email);
            }
            for(Contact c : Trigger.New){
                if(Emails.contains(c.Email)){
                    c.addError('Duplicate contacts are not allowed : '+ c.Email + ' already used');
                }
            }
        }
    }
}