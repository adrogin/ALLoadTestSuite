codeunit 65100 "Load Test Setup ALD"
{
    Subtype = Test;

    [Test]
    procedure TestSessionDelaySetupMultipleAccepted()
    var
        LoadTestSetup: Record "Load Test Setup ALD";
        TestSession: Record "Load Test Session ALD";
        Multiplier: Integer;
    begin
        // [SCENARIO] Start time delay for the first session is accepted if it is a multiple of the update frequency setup

        Initialize();
        LoadTestSetup.Get();
        Multiplier := LibraryRandom.RandInt(5);
        TestSession.Validate("Session Start Delay", LoadTestSetup."Task Update Frequency" * Multiplier);
        Assert.AreEqual(TestSession."Session Start Delay", LoadTestSetup."Task Update Frequency" * Multiplier, UnexpectedFieldValueErr);
    end;

    [Test]
    procedure TestSessionDelayNotSetupMultipleRejected()
    var
        LoadTestSetup: Record "Load Test Setup ALD";
        TestSession: Record "Load Test Session ALD";
    begin
        // [SCENARIO] Start time delay for the first session is rejected if it is not a multiple of the update frequency setup

        Initialize();
        LoadTestSetup.Get();
        asserterror TestSession.Validate("Session Start Delay", Round(LoadTestSetup."Task Update Frequency" * LibraryRandom.RandDecInDecimalRange(1.1, 1.9, 1), 1));
        Assert.ExpectedError('123345');
    end;

    [Test]
    procedure TestSessionCloneDelaySetupMultipleAccepted()
    var
        LoadTestSetup: Record "Load Test Setup ALD";
        TestSession: Record "Load Test Session ALD";
        Multiplier: Integer;
    begin
        // [SCENARIO] Start time delay for session clones is accepted if it is a multiple of the update frequency setup

        Initialize();
        LoadTestSetup.Get();
        Multiplier := LibraryRandom.RandInt(5);
        TestSession.Validate("Delay Between Clones", LoadTestSetup."Task Update Frequency" * Multiplier);
        Assert.AreEqual(TestSession."Session Start Delay", LoadTestSetup."Task Update Frequency" * Multiplier, UnexpectedFieldValueErr);
    end;

    [Test]
    procedure TestSessionCloneDelayNotSetupMultipleRejected()
    var
        LoadTestSetup: Record "Load Test Setup ALD";
        TestSession: Record "Load Test Session ALD";
    begin
        // [SCENARIO] Start time delay for session clones is rejected if it is not a multiple of the update frequency setup

        Initialize();
        LoadTestSetup.Get();
        asserterror TestSession.Validate("Delay Between Clones", Round(LoadTestSetup."Task Update Frequency" * LibraryRandom.RandDecInDecimalRange(1.1, 1.9, 1), 1));
        Assert.ExpectedError('123345');
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;

        LibraryLoadTest.InitLoadTestSetup();
        Commit();
    end;


    var
        LibraryLoadTest: Codeunit "Library - Load Test ALD";
        LibraryRandom: Codeunit "Library - Random";
        Assert: Codeunit Assert;
        IsInitialized: Boolean;
        UnexpectedFieldValueErr: Label 'Unexpected field value';
}