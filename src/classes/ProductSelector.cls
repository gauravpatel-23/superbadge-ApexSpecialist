public class ProductSelector {

    public static List<Product2> getProducts(Integer queryLimit) {
        return [
                SELECT
                        Replacement_Part__c,
                        Current_Inventory__c,
                        Name,
                        Maintenance_Cycle__c,
                        Lifespan_Months__c,
                        Cost__c,
                        Warehouse_SKU__c
                FROM
                        Product2
                LIMIT
                        :queryLimit
        ];
    }
}