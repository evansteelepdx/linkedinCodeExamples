({
	onTabCreated: function (component, event, helper) {
		var newTabId = event.getParam("tabId");
		var workspaceAPI = component.find("workspace");

		workspaceAPI
			.getTabInfo({
				tabId: newTabId
			})
			.then(function (response) {
				if (response.recordId.startsWith("570")) {
					var action = component.get("c.returnChatCases");

					action.setParams({ currentChatTranscript: response.recordId });

					action.setCallback(this, function (response) {
						var state = response.getState();

						if (state === "SUCCESS") {
							var showOnCreateEvent = component.getEvent("showOnCreateEventHandler");

							showOnCreateEvent.setParams({ caseId: response.getReturnValue() });
							showOnCreateEvent.fire();
						} else if (state === "INCOMPLETE") {
							console.log("INCOMPLETE");
						} else if (state === "ERROR") {
							var errors = response.getError();
							console.log(errors);
						}
					});

					$A.enqueueAction(action);
				}
			})
			.catch(function (error) {
				console.log(error);
			});
	},
	onCheckCases: function (component, event, helper) {
		var caseValue = component.find("checkCases").get("v.value");

		component.set("v.showCases", caseValue);
	},
	onCheckContacts: function (component, event, helper) {
		var contactValue = component.find("checkContacts").get("v.value");

		component.set("v.showContacts", contactValue);
	}
});
