public with sharing class botMessagingPreChat {
  public class conversationEntryOutput {
    @InvocableVariable(required=true)
    public String conversationEntryMessage;
  }

  public class routableInput {
    @InvocableVariable(required=true)
    public Id routableId;
  }

  @InvocableMethod(label='Get Initial SMS Message')
  public static List<conversationEntryOutput> getInitialMessage(
    List<routableInput> routableInputs
  ) {
    List<conversationEntryOutput> entryOutputs = new List<conversationEntryOutput>();
    Set<Id> routableIds = new Set<Id>();
    for (routableInput input : routableInputs) {
      routableIds.add(input.routableId);
    }
    ConversationEntry entryResult = [
      SELECT Id, ConversationId, createddate, entrytype, message
      FROM ConversationEntry
      WHERE ConversationId IN :routableIds AND EntryType = 'text'
      ORDER BY createdDate DESC
      LIMIT 1
    ];
    conversationEntryOutput entryOutput = new conversationEntryOutput();
    entryOutput.conversationEntryMessage = entryResult.message;
    entryOutputs.add(entryOutput);
    return entryOutputs;
  }
}
