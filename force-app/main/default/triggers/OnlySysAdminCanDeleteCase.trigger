trigger OnlySysAdminCanDeleteCase on Case (before delete) {
    set<Id>ProcessCase = new set<Id>();
    
    for(Case c : Trigger.Old){
        ProcessCase.add(c.Id);
    }
    
    if(ProcessCase.size()>0){
        Id UID = userinfo.getUserId();
        User U = [SELECT Id,Profile.Name FROM User WHERE Id=:UID];
        if(U.Profile.Name != 'System Administrator'){
            Trigger.Old[0].Id.addError('You Cannot delete');
        }
    }
}