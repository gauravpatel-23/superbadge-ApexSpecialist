@isTest
public class WorkPartFactory {

    public static Work_Part__c createWorkPart(Id productId, Id caseId) {
        Work_Part__c workPart = new Work_Part__c(
                    Quantity__c = randomQuantity(),
                    Equipment__c = productId,
                    Maintenance_Request__c = caseId
        );
        return workPart;
    }

    private static Integer randomQuantity() {
        return Math.round(Math.random() * 10);
    }
}