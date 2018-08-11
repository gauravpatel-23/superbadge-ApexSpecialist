@isTest
public class CaseFactory {

    public static List<Case> createCases(Integer count, String type, String status) {
        List<Case> cases = new List<Case>();

        for (Integer i = 0; i < count; ++i) {
            cases.add(new Case(
                    Type = type,
                    Status = status,
                    Subject = 'This maintenance request was generated in CaseFactory.'
            ));
        }

        return cases;
    }
}