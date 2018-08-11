@isTest
private class MaintenanceRequestHelperTest {

    private static final Integer BULK_SIZE = 300;

    @isTest
    private static void updateWorkOrders() {
        List<Case> cases = CaseFactory.createCases(1, MaintenanceRequestHelper.TYPE_REPAIR, MaintenanceRequestHelper.STATUS_WORKING);
        List<Product2> products = ProductFactory.createProducts(1);
        insert cases;
        insert products;
        Work_Part__c workPart = WorkPartFactory.createWorkPart(products[0].Id, cases[0].Id);
        insert workPart;

        Test.startTest();
        cases[0].Status = MaintenanceRequestHelper.STATUS_CLOSED;
        update cases[0];
        Test.stopTest();

        List<Case> queriedCases = CaseSelector.getCases(10);
        System.assertEquals(2, queriedCases.size(), 'We expect two cases, one closed and one working.');

        Case closed, working;
        for (Case c : queriedCases) {
            if (c.Status == MaintenanceRequestHelper.STATUS_WORKING) {
                working = c;
            } else if (c.Status == MaintenanceRequestHelper.STATUS_CLOSED) {
                closed = c;
            }
        }
        System.assertNotEquals(null, closed, 'There should be one closed case.');
        System.assertNotEquals(null, working, 'There should be one working case.');
        System.assertEquals(cases[0].Id, closed.Id, 'Tested case should be closed.');
        System.assertEquals(MaintenanceRequestHelper.SUBJECT, working.Subject, 'New case has wrong subject.');
        System.assertEquals(MaintenanceRequestHelper.TYPE_ROUTINE_MAINTENANCE, working.Type, 'New case is of wrong type.');
        System.assertEquals(closed.Equipment__c, working.Equipment__c, 'Cases should have same equipment.');
        System.assertEquals(Date.today().addDays(products[0].Maintenance_Cycle__c.intValue()), working.Date_Due__c, 'Due date was set unsuccessfully');
    }

    @isTest
    private static void updateWorkOrdersWithoutWorkParts() {
        List<Case> cases = CaseFactory.createCases(1, MaintenanceRequestHelper.TYPE_REPAIR, MaintenanceRequestHelper.STATUS_WORKING);
        List<Product2> products = ProductFactory.createProducts(1);
        insert cases;

        Test.startTest();
        cases[0].Status = MaintenanceRequestHelper.STATUS_CLOSED;
        update cases[0];
        Test.stopTest();

        List<Case> queriedCases = CaseSelector.getCases(10);
        System.assertEquals(2, queriedCases.size(), 'We expect two cases, one closed and one working.');

        Case closed, working;
        for (Case c : queriedCases) {
            if (c.Status == MaintenanceRequestHelper.STATUS_WORKING) {
                working = c;
            } else if (c.Status == MaintenanceRequestHelper.STATUS_CLOSED) {
                closed = c;
            }
        }
        System.assertNotEquals(null, closed, 'There should be one closed case.');
        System.assertNotEquals(null, working, 'There should be one working case.');
        System.assertEquals(cases[0].Id, closed.Id, 'Tested case should be closed.');
        System.assertEquals(MaintenanceRequestHelper.SUBJECT, working.Subject, 'New case has wrong subject.');
        System.assertEquals(MaintenanceRequestHelper.TYPE_ROUTINE_MAINTENANCE, working.Type, 'New case is of wrong type.');
        System.assertEquals(closed.Equipment__c, working.Equipment__c, 'Cases should have same equipment.');
        System.assertEquals(Date.today(), working.Date_Due__c, 'Due date was set unsuccessfully');
    }

    @isTest
    private static void updateWorkOrdersBulk() {
        List<Case> cases = CaseFactory.createCases(BULK_SIZE, MaintenanceRequestHelper.TYPE_REPAIR, MaintenanceRequestHelper.STATUS_WORKING);
        List<Product2> products = ProductFactory.createProducts(BULK_SIZE);
        insert cases;
        insert products;
        List<Work_Part__c> workParts = new List<Work_Part__c>();
        for (Integer i = 0; i < BULK_SIZE; ++i) {
            workParts.add(WorkPartFactory.createWorkPart(products[i].Id, cases[i].Id));
        }
        insert workParts;

        Test.startTest();
        for (Case c : cases) {
            c.Status = MaintenanceRequestHelper.STATUS_CLOSED;
        }
        update cases;
        Test.stopTest();

        List<Case> queriedCases = CaseSelector.getCases(BULK_SIZE * 3);
        System.assertEquals(BULK_SIZE * 2, queriedCases.size(), 'We expect two cases, one closed and one working.');

        Integer closedCasesCount = 0;
        Integer workingCasesCount = 0;

        for (Case c : queriedCases) {
            if (c.Status == MaintenanceRequestHelper.STATUS_WORKING) {
                ++workingCasesCount;
            } else if (c.Status == MaintenanceRequestHelper.STATUS_CLOSED) {
                ++closedCasesCount;
            }
        }
    }
}