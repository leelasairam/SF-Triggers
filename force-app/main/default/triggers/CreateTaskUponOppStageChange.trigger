trigger CreateTaskUponOppStageChange on Opportunity (after update) {
	set<Id>ProcessOpp = new set<Id>();
    for(Opportunity op : Trigger.New){
        if(op.StageName!=Trigger.oldMap.get(op.Id).StageName){
            ProcessOpp.add(op.Id);
        }
    }
    if(ProcessOpp.size()>0){
        list<Opportunity>opps = [SELECT Id, Name, OwnerId FROM Opportunity WHERE Id IN : ProcessOpp];
        list<Task>InsertTasks = new list<Task>();
        for(Opportunity op : opps){
            Task T = new Task(Subject='From Opportunity (Stage Changed) : '+'['+op.Name+']',ActivityDate=Date.today().addDays(1),WhatId=op.Id,OwnerId=op.OwnerId,Status='Not Started');
            InsertTasks.add(T);
        }
        if(InsertTasks.size()>0){
            Insert InsertTasks;
        }
    }
}