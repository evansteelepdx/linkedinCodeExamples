({
    doInit: function (component, event, helper) {
        var getSkillAction = component.get("c.getSkillList");
        getSkillAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.options', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("An unknown error occurred");
                }
            }
        });
        $A.enqueueAction(getSkillAction);
    },
    handleRouting: function (component, event, helper) {
        var selectedSkill = component.get('v.selectedValue');
        if (selectedSkill) {
            var routeAction = component.get("c.routeUsingSkills");
            routeAction.setParams({
                SkillId: selectedSkill,
                CaseId: component.get("v.recordId")
            });
            routeAction.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue() == 'Successfully routed record') {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Record routed",
                            "message": "The record has been routed successfully",
                            "type": "success"
                        });
                        toastEvent.fire();
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Failed to route record",
                            "message": response.getReturnValue(),
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(routeAction);
        }
    }
});
