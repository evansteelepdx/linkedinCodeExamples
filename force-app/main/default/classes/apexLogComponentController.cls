public with sharing class apexLogComponentController {
  @AuraEnabled
  public static List<ApexLog> getApexLogList(String searchTerm) {
    try {
      List<ApexLog> logList = [
        SELECT Id, LogLength
        FROM ApexLog
        WHERE LogUser.Name = :searchTerm
        ORDER BY logLength DESC
      ];
      return logList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled
  public static List<String> getTraceTargets() {
    List<String> traceList = new List<String>();
    try {
      AggregateResult[] groupedResults = [
        SELECT Count(Id), LogUser.Name
        FROM ApexLog
        GROUP BY LogUser.Name
      ];
      for (AggregateResult ar : groupedResults) {
        traceList.add((String) ar.get('Name'));
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return traceList;
  }
}
