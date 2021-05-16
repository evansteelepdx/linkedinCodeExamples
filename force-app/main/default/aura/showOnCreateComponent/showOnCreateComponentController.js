({
	handleShowOnCreateEvent: function (component, event, helper) {
		var caseResult = event.getParam("caseId");
		var workspaceAPI = component.find("workspace");

		workspaceAPI.getFocusedTabInfo().then(function (response) {
			workspaceAPI.openSubtab({
				parentTabId: response.tabId,
				recordId: caseResult,
				focus: false
			});
		});
	}
});
