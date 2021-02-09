codeunit 65101 "Load Test Execution ALD"
{
    Subtype = Test;

    [Test]
    procedure ActiveTestBatchExistsWhenRecInActiveTestBatch()
    var
        LoadTestActiveBatch: Record "Load Test Active Batch ALD";
    begin
        // [SCENARIO] LoadTestManager.ActiveTestBatchExists returns "true" if a record in the "Load Test Active Batch" exists
        LibraryLoadTest.MockActiveTestBatch(LoadTestActiveBatch);
        Assert.IsTrue(LoadTestExec.ActiveTestBatchExists(), UnexpectedFunctionValueErr);
    end;

    [Test]
    procedure ActiveTestBatchNotExistsWhenActiveTestBatchRecEmpty()
    var
        LoadTestActiveBatch: Record "Load Test Active Batch ALD";
    begin
        // [SCENARIO] LoadTestManager.ActiveTestBatchExists returns "false" if a record in the "Load Test Active Batch" does not exist
        LoadTestActiveBatch.DeleteAll();
        Assert.IsFalse(LoadTestExec.ActiveTestBatchExists(), UnexpectedFunctionValueErr);
    end;

    [Test]
    procedure VerifyNoActiveTestErrorWhenActiveBatchFound()
    var
        LoadTestActiveBatch: Record "Load Test Active Batch ALD";
        CannotRunMultipleBatchesErr: Label 'Test batch cannot start while another batch is running';
    begin
        // [SCENARIO] LoadTestManager.VerifyNoActiveTest throws an error if a record in the "Load Test Active Batch" exists
        LibraryLoadTest.MockActiveTestBatch(LoadTestActiveBatch);
        asserterror LoadTestExec.VerifyNoActiveTest();
        Assert.ExpectedError(CannotRunMultipleBatchesErr);
    end;

    [Test]
    procedure StartBatchCopiesBatchToActive()
    var
        LoadTestBatch: Record "Load Test Batch ALD";
        LoadTestBatchSession: Record "Load Test Batch Session ALD";
    begin
        // [SCENARIO] Start Test Batch action copies the selected batch and its configuration into the active batch config.

        Initialize();

        // [GIVEN] Load test batch with two test sessions
        LibraryLoadTest.CreateTestBatch(LoadTestBatch);
        LibraryLoadTest.CreateTestBatchSession(LoadTestBatch.Name, LoadTestBatchSession);
        LibraryLoadTest.CreateTestBatchSession(LoadTestBatch.Name, LoadTestBatchSession);

        // [WHEN] Execute the batch
        LoadTestExec.RunTestBatch(LoadTestBatch.Name);

        // [THEN] Batch sessions are copied to the active batch
        VerifyActiveBatch(LoadTestBatch.Name);
    end;

    procedure StartSessionMultipleClonesInitialized()
    begin
        // [SCENARIO] When starting a aest session with multiple clones configured, each clone is created as a separate active session 
        // TODO: Verify sessions' scheduled time 

        Assert.Fail('Not implemented');
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        LibraryLoadTest.InitLoadTestSetup();

        Commit();
    end;

    local procedure VerifyActiveBatch(BatchName: Code[20])
    var
        LoadTestActiveBatch: Record "Load Test Active Batch ALD";
        LoadTestActiveSession: Record "Load Test Active Session ALD";
        LoadTestBatchSession: Record "Load Test Batch Session ALD";
    begin
        LoadTestActiveBatch.SetRange("Batch Name", BatchName);
        Assert.RecordCount(LoadTestActiveBatch, 1);

        LoadTestBatchSession.SetRange("Batch Name", BatchName);
        LoadTestActiveSession.SetRange("Batch Name", BatchName);
        Assert.RecordCount(LoadTestActiveSession, LoadTestBatchSession.Count());
    end;

    var
        LoadTestExec: Codeunit "Load Test - Execute ALD";
        LibraryLoadTest: Codeunit "Library - Load Test ALD";
        Assert: Codeunit Assert;
        UnexpectedFunctionValueErr: Label 'Unexpected function return value.';
        IsInitialized: Boolean;
}