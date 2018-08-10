trigger MaintenanceRequest on Case (before update, after update, before insert, after insert, before delete, after delete) {

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            MaintenanceRequestHelper.updateWorkOrders(Trigger.new, Trigger.oldMap);
        }
    }
}