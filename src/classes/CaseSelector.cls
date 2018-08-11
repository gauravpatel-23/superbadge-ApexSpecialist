@isTest
public class CaseSelector {

    public static List<Case> getCases(Integer queryLimit) {
        return [
                SELECT
                        Type, Status, Date_Due__c, Subject, Vehicle__c,
                        Equipment__c, Equipment__r.Maintenance_Cycle__c

                FROM
                        Case
                LIMIT
                        :queryLimit
        ];
    }
}