public class MaintenanceRequestHelper {


    public static final String TYPE_REPAIR = 'Repair';
    public static final String TYPE_ROUTINE_MAINTENANCE = 'Routine Maintenance';
    public static final String STATUS_CLOSED = 'Closed';
    public static final String SUBJECT = 'Routine Maintenance';

    private static final Date TODAY = Date.today();

    public static void updateWorkOrders(List<Case> newList, Map<Id, Case> oldMap){
        // filter all cases its status changed to STATUS_CLOSED
        List<Case> casesWithChangedStatus = filterStatusChanged(newList, oldMap, STATUS_CLOSED);

        // filter all cases that are of type TYPE_REPAIR or TYPE_ROUTINE_MAINTENANCE
        List<Case> filteredCases = filterByType(casesWithChangedStatus, new Set<String>{TYPE_REPAIR, TYPE_ROUTINE_MAINTENANCE});

        // create new cases for closed ones
        List<Case> newCases = createNewCasesForClosedOnes(filteredCases);

        insert newCases;
    }

    private static List<Case> createNewCasesForClosedOnes(List<Case> cases) {
        // result case list initialization
        List<Case> newCases = new List<Case>();

        // map work parts to case ids
        Set<Id> casesIds = new Map<Id, Case>(cases).keySet();
        Map<Id, List<Work_Part__c>> caseIdToWorkParts = WorkPartSelector.getCaseIdToWorkParts(casesIds);

        for (Case oldCase : cases) {
            Case newCase = new Case();
            newCase.Vehicle__c = oldCase.Vehicle__c;
            newCase.Equipment__c = oldCase.Equipment__c;
            newCase.Type = TYPE_ROUTINE_MAINTENANCE;
            newCase.Subject = SUBJECT;
            newCase.Date_Reported__c = TODAY;
            newCase.Date_Due__c = calculateDueDate(caseIdToWorkParts.get(oldCase.Id));
            newCases.add(newCase);
        }
        return newCases;
    }

    private static Date calculateDueDate(List<Work_Part__c> workParts) {
        if (workParts == null || workParts.isEmpty())
            return TODAY;

        Decimal minCycle = workParts.get(0).Equipment__r.Maintenance_Cycle__c;

        for (Work_Part__c wp : workParts) {
            minCycle = Math.min(minCycle, wp.Equipment__r.Maintenance_Cycle__c);
        }
        return TODAY.addDays(minCycle.intValue());
    }

    private static List<Case> filterByType(List<Case> cases, Set<String> types) {
        List<Case> filtered = new List<Case>();
        for (Case c : cases) {
            if (types.contains(c.Type)) {
                filtered.add(c);
            }
        }
        return filtered;
    }

    private static List<Case> filterStatusChanged(List<Case> newList, Map<Id, Case> oldMap, String newStatus) {
        List<Case> filtered = new List<Case>();
        for (Case newCase : newList) {
            if (newCase.Status == newStatus && oldMap.get(newCase.Id).Status != newStatus) {
                filtered.add(newCase);
            }
        }
        return filtered;
    }
}