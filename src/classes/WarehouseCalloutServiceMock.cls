@isTest
public class WarehouseCalloutServiceMock implements HttpCalloutMock {

    private final Integer STATUS_CODE;
    private final String BODY;

    public WarehouseCalloutServiceMock(Integer statusCode, String body) {
        this.STATUS_CODE = statusCode;
        this.BODY = body;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(STATUS_CODE);
        resp.setStatus(String.valueOf(STATUS_CODE));
        resp.setBody(BODY);
        return resp;
    }
}