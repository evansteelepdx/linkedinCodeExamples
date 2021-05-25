public with sharing class apexLogComponentController {
  @AuraEnabled
  public static List<Id> getApexLogList(String searchTerm) {
    try {
      List<Id> logIdList = new List<Id>();
      logIdList.add('07L5Y00004iThzzUAC');
      logIdList.add('07L5Y00004iThzpUAC');
      return logIdList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
