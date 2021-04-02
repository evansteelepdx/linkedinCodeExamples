public with sharing class togglUtils {
  @future(callout=true)
  public static void togglStartEntry(String pageURL) {
    String recordName = pageURL;
    String results = startTimeEntry(recordName);
    System.debug(results);
  }
  public static String startTimeEntry(String workItemName) {
    togglData td = new togglData(workItemName, 'curl');

    JSONGenerator gen = JSON.createGenerator(false);

    gen.writeStartObject();
    gen.writeFieldName('time_entry');
    gen.writeObject(td);
    gen.writeEndObject();

    system.debug(gen.getAsString());

    Http httpProtocol = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:Toggl/api/v8/time_entries/start');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody(gen.getAsString());
    HttpResponse response = httpProtocol.send(request);
    String results = response.getBody();
    system.debug(results);
    return results;
  }
}
