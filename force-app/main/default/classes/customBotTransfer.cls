public inherited sharing class customBotTransfer {
  /*
    Multi-step query process for the bot invocation:
    1) Get button routing type
    2) Get labels of buttons that we could transfer to given those buttons
  */

  @InvocableMethod(label='Get queue or skill list for transfer')
  public static List<List<LiveChatButton>> getPossibleButtons(
    List<Id> chatTranscripts
  ) {
    List<LiveChatTranscript> transcriptQueryResults = new List<LiveChatTranscript>();
    List<Id> chatButtonIds = new List<Id>();
    List<LiveChatButton> chatButtonQueryResults = new List<LiveChatButton>();
    List<String> routingTypes = new List<String>();
    List<LiveChatButton> routableChatButtons = new List<LiveChatButton>();
    List<List<LiveChatButton>> buttonResults = new List<List<LiveChatButton>>();

    // fetch button ID of the current transcript
    transcriptQueryResults = [
      SELECT id, liveChatButtonId
      FROM livechattranscript
      WHERE id IN :chatTranscripts
    ];
    for (LiveChatTranscript lct : transcriptQueryResults) {
      chatButtonIds.add(lct.liveChatButtonId);
    }

    // get routing type of the button
    chatButtonQueryResults = [
      SELECT id, routingType
      FROM LiveChatButton
      WHERE ID IN :chatButtonIds
    ];
    for (LiveChatButton lcb : chatButtonQueryResults) {
      routingTypes.add(lcb.routingType);
    }

    // get all buttons with the same routing type
    routableChatButtons = [
      SELECT Id, QueueId, MasterLabel
      FROM LiveChatButton
      WHERE RoutingType IN :routingTypes
    ];
    buttonResults.add(routableChatButtons);
    return buttonResults;
  }
}
