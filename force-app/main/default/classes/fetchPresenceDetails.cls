public with sharing class fetchPresenceDetails {
    @AuraEnabled(cacheable=true)
    public static UserServicePresence getUserServicePresence(Id uspID) {
        UserServicePresence currentPresence = [SELECT Id, CreatedDate, isAway, ServicePresenceStatus.MasterLabel, User.Name FROM UserServicePresence WHERE id=:uspId];
        return currentPresence;
    }
}
