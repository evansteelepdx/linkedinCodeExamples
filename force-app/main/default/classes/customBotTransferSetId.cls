public inherited sharing class customBotTransferSetId {
  public class idInput {
    @InvocableVariable(required=true)
    public LiveChatButton buttonSelections;
  }

  @InvocableMethod(label='Set Queue ID')
  public static List<Id> setIdForTransfer(List<idInput> inputs) {
    List<Id> queueIdList = new List<Id>();
    for (idInput idp : inputs) {
      queueIdList.add(idp.buttonSelections.QueueId);
    }
    return queueIdList;
  }
}
