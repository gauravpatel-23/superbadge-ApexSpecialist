public class WarehouseSyncSchedule implements Schedulable {

    public static final String CRON_EXP = '0 0 1 * * ?';

    public void execute(SchedulableContext SC) {
        // sync warehouse equipments
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }

    public static String schedule() {
        return system.schedule('Warehouse equipment sync.', CRON_EXP, new WarehouseSyncSchedule());
    }
}