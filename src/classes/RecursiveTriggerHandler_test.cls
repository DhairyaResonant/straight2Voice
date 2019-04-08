@IsTest
private class RecursiveTriggerHandler_test
{
    @IsTest
    private static void testTrigger()
    {
        test.starttest();
        RecursiveTriggerHandler.isFirstTime  = true;
        test.stoptest();
    }
}