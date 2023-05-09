trigger UpdateLatestCaseNumberOnAccount on Case (after insert) {
    set<Id>ProcessCase = new set<Id>();
    
    for(Case c : Trigger.New){
        ProcessCase.add(c.AccountId);
    }
    
    if(ProcessCase.size()>0){
        list<Account>accs = [SELECT Id,Description,(SELECT Id,CaseNumber,CreatedDate FROM Cases ORDER BY CreatedDate DESC LIMIT 1) FROM Account WHERE Id IN: ProcessCase];
        for(Account a : accs){
            if(a.Cases.size()>0){
                a.Description += '\n' + 'Case Number : ' + a.Cases[0].CaseNumber + ', ' + 'Created on : ' + a.Cases[0].CreatedDate;
            }
        }
        if(accs.size()>0){
            update accs;
        }
    }
}