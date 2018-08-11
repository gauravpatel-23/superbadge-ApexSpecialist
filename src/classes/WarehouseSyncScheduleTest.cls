@isTest
private class WarehouseSyncScheduleTest {

    @isTest
    private static void scheduleTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(
                WarehouseCalloutServiceTest.STATUS_CODE_SUCCESS,
                WarehouseCalloutServiceTest.BODY_SUCCESS
        ));

        Test.startTest();
        String jobId = WarehouseSyncSchedule.schedule();
        Test.stopTest();

        CronTrigger ct = [
                SELECT
                        Id, CronExpression, TimesTriggered, NextFireTime
                FROM
                        CronTrigger
                WHERE
                        id = :jobId
        ];

        System.assertEquals(WarehouseSyncSchedule.CRON_EXP, ct.CronExpression);
    }
}