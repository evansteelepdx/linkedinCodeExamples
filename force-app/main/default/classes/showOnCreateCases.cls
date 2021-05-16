public with sharing class showOnCreateCases {
	@AuraEnabled
	public static Id returnChatCases(Id currentChatTranscript) {
		LiveChatTranscript lct = [SELECT CaseId FROM LiveChatTranscript WHERE Id = :currentChatTranscript LIMIT 1];
		return lct.CaseId;
	}
}
