# Salesforce LinkedIn Code

The Master branch will just be the SFDX project base files. For the individual code examples, browse the branches. The posts on LinkedIn will be linked to a specific branch.

### This branch is for my post on Omni-Channel User Presences in a console utility:
https://www.linkedin.com/pulse/week-12521-evan-steele/

This project requires you to insert the UserPresenceStatus PushTopic manually through Anonymous Apex. You'll only need to do this once:
```
PushTopic pushTopic = new PushTopic();
pushTopic.Name = 'UserServicePresence';
pushTopic.Query = 'select id,createddate from UserServicePresence';
pushTopic.ApiVersion = 50.0;
pushTopic.NotifyForOperationCreate = true;
pushTopic.NotifyForOperationUpdate = true;
insert pushTopic;
```
