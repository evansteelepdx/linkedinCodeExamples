public class batchConvertAttachmentsToFiles implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){

        String query = 'SELECT Subject, ParentID, (SELECT Id, Title FROM CombinedAttachments) FROM EmailMessage';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<EmailMessage> listOfEmails){
        Schema.SObjectType attachmentType = Schema.Attachment.getSObjectType();
        
        List<ContentVersion> newContent = new List<ContentVersion>();
        List<Attachment> oldAttachments = new List<Attachment>();
        List<FeedItem> updatePosts = new List<FeedItem>();
        
        for (EmailMessage s : listOfEmails){
            for (CombinedAttachment c : s.CombinedAttachments){
                if (c.id.getSobjectType() == attachmentType){
                    Attachment currentAttachment = [Select Id,Name,Body from Attachment where Id=:c.Id];
                    
                    ContentVersion cv = new ContentVersion();
                    cv.VersionData = currentAttachment.Body;
                    cv.PathOnClient = currentAttachment.Name;
                    cv.FirstPublishLocationId = s.ParentId;
                    newContent.add(cv);
                    
                    oldAttachments.add(currentAttachment);
                    
                    FeedItem post = new FeedItem();
                    post.Body = 'Attachment ID ' + currentAttachment.Id + ' was converted to a Salesforce File.';
                    post.ParentId = s.ParentId;
                    post.Title = 'Attachment Conversion';
                    updatePosts.add(post);
                }
            }
        }
        insert newContent;
        delete oldAttachments;
        insert updatePosts;
    }
    
    public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Attachment to File Conversion ' + a.Status);
        mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}