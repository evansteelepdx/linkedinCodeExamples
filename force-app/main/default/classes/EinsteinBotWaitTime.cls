public with sharing class EinsteinBotWaitTime {
  public class InputVars {
    @InvocableVariable(label='Chat Button ID' required=true)
    public Id chatButtonId;
    @InvocableVariable(label='Chat Deployment ID' required=true)
    public Id chatDeploymentId;
  }

  public class Result {
    @InvocableVariable(label='Wait Time Result' required=true)
    public String waitTime;
  }

  @InvocableMethod
  public static List<Result> getWaitTime(List<InputVars> inputVars) {
    List<Result> results = new List<Result>();

    String orgId = UserInfo.getOrganizationId().substring(0, 15);
    String URL =
      'https://d.la4-c1-ia4.salesforceliveagent.com/chat/rest/Visitor/Availability?org_id=' +
      orgId +
      '&deployment_id=' +
      inputVars[0].chatDeploymentId.to15() +
      '&Availability.ids=[' +
      inputVars[0].chatButtonId.to15() +
      ']&Availability.needEstimatedWaitTime=1';

    Http h = new Http();
    HttpRequest availibilityRequest = new HttpRequest();
    availibilityRequest.setEndpoint(URL);
    availibilityRequest.setMethod('GET');
    availibilityRequest.setHeader('X-LIVEAGENT-API-VERSION', '52');

    HttpResponse res = h.send(availibilityRequest);
    JSONParser parser = JSON.createParser(res.getBody());
    while (parser.nextToken() != null) {
      if (parser.getCurrentName() == 'estimatedWaitTime') {
        parser.nextValue();
        Result currentResult = new Result();
        currentResult.waitTime = parser.getText();
        results.add(currentResult);
      }
    }
    return results;
  }
}
