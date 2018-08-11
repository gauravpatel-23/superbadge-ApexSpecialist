@isTest
public class ProductFactory {

    public static List<Product2> createProducts(Integer count) {
        List<Product2> products = new List<Product2>();

        for (Integer i = 0; i < count; ++i) {
            products.add(new Product2(
                    Name = randomString(16),
                    Maintenance_Cycle__c = randomMaintenanceCycle(),
                    Replacement_Part__c = true
            ));
        }

        return products;
    }

    public static String randomString(Integer len) {
        Blob blobKey = Crypto.generateAesKey(192);
        String key = EncodingUtil.base64encode(blobKey);
        return key.substring(0, len);
    }

    private static Integer randomMaintenanceCycle() {
        return Math.round(Math.random() * 100);
    }
}