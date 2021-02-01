public with sharing class skillsbasedroutingcontroller {
    @AuraEnabled
    public static list<Skill> getSkillList(){
        return [Select Id, MasterLabel from Skill];
    }
    @AuraEnabled
    public static String routeUsingSkills(Id SkillId, Id CaseId){
        String result;
        PendingServiceRouting psrObj = new PendingServiceRouting(
            CapacityWeight = 1,
            IsReadyForRouting = FALSE,
            RoutingModel = 'MostAvailable',
            RoutingPriority = 1,
            RoutingType = 'SkillsBased',
            ServiceChannelId = getChannelId(),
            WorkItemId = CaseId,
            PushTimeout = 0
        );
        Database.SaveResult sr = Database.insert(psrObj, false);
        if (sr.isSuccess()){
            psrObj = [select id, IsReadyForRouting from PendingServiceRouting where id =: psrObj.id];
            SkillRequirement srObj = new SkillRequirement(
                RelatedRecordId = psrObj.id,
                SkillId = SkillId
            );
            insert srObj;
            psrObj.IsReadyForRouting = True;
            update psrObj;
            result = 'Successfully routed record';
        } else {
            for(Database.Error err : sr.getErrors()) {
                result = err.getMessage();
            }
        }
        return result;
    }
    static String getChannelId() {
        ServiceChannel channel = [Select Id From ServiceChannel Where RelatedEntity ='Case'];
        return channel.Id;
    }
}
