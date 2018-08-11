public class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    private static final String REST_METHOD = 'GET';

    private static final Set<Integer> VALID_STATUS_CODES = new Set<Integer>{200, 301};

    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        // callout
        HttpResponse resp = new Http().send(createRequest());
        Integer statusCode = resp.getStatusCode();

        // process response
        if (VALID_STATUS_CODES.contains(statusCode)) {
            calloutSuccessful(resp.getBody());
        } else {
            calloutFail(statusCode);
        }
    }

    private static HttpRequest createRequest() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod(REST_METHOD);
        return req;
    }

    private static void calloutSuccessful(String body) {
        body = body.replaceAll('_id', 'externalId');

        // deserialize list
        List<ExternalProduct> externalProducts = (List<ExternalProduct>) JSON.deserialize(body, List<ExternalProduct>.class);

        // parse to products
        List<Product2> products = parseExternalProducts(externalProducts);

        upsert products;
    }

    private static void calloutFail(Integer statusCode) {
        // log error
    }

    private static List<Product2> parseExternalProducts(List<ExternalProduct> externalProducts) {
        List<Product2> products = new List<Product2>();

        for (ExternalProduct extProduct : externalProducts) {
            products.add(extProduct.toProduct());
        }
        return products;
    }

    private class ExternalProduct {
        private String externalId;
        private String replacement;
        private Integer quantity;
        private String name;
        private Integer maintenanceperiod;
        private Integer lifespan;
        private Integer cost;
        private String sku;

        private Product2 toProduct() {
            return new Product2(
                    Replacement_Part__c = true,
                    Current_Inventory__c = quantity,
                    Name = name,
                    Maintenance_Cycle__c = maintenanceperiod,
                    Lifespan_Months__c = lifespan,
                    Cost__c = cost,
                    Warehouse_SKU__c = sku
            );
        }
    }
}