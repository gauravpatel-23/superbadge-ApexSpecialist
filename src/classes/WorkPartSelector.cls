public class WorkPartSelector {

    public static Map<Id, List<Work_Part__c>> getCaseIdToWorkParts(Set<Id> caseIds) {
        List<Case> cases = [
                SELECT
                        Id, (
                                SELECT
                                        Name, Equipment__c, Equipment__r.Maintenance_Cycle__c, Maintenance_Request__c, Quantity__c
                                FROM
                                        Work_Parts__r
                            )
                FROM
                        Case
                WHERE
                        Id IN :caseIds
        ];

        Map<Id, List<Work_Part__c>> caseIdToWorkParts = new Map<Id, List<Work_Part__c>>();

        for (Case c : cases) {
            caseIdToWorkParts.put(c.Id, c.Work_Parts__r);
        }

        return caseIdToWorkParts;
    }
}