codeunit 65101 "ALD Load Test Execution"
{
    Subtype = Test;

    [Test]
    procedure ActiveTestBatchExistsWhenRecInActiveTestBatch()
    var
        ActiveTestBatch: Record "ALD Active Test Batch";
    begin
        // [SCENARIO] LoadTestManager.ActiveTestBatchExists returns "true" if a record in the "Load Test Active Batch" exists
        LibraryLoadTest.MockActiveTestBatch(ActiveTestBatch);
        Assert.IsTrue(TestExecute.ActiveTestBatchExists(), UnexpectedFunctionValueErr);
    end;

    [Test]
    procedure ActiveTestBatchNotExistsWhenActiveTestBatchRecEmpty()
    var
        ActiveTestBatch: Record "ALD Active Test Batch";
    begin
        // [SCENARIO] LoadTestManager.ActiveTestBatchExists returns "false" if a record in the "Load Test Active Batch" does not exist
        ActiveTestBatch.DeleteAll();
        Assert.IsFalse(TestExecute.ActiveTestBatchExists(), UnexpectedFunctionValueErr);
    end;

    [Test]
    procedure VerifyNoActiveTestErrorWhenActiveBatchFound()
    var
        ActiveTestBatch: Record "ALD Active Test Batch";
        CannotRunMultipleBatchesErr: Label 'Test batch cannot start while another batch is running';
    begin
        // [SCENARIO] LoadTestManager.VerifyNoActiveTest throws an error if a record in the "Load Test Active Batch" exists
        LibraryLoadTest.MockActiveTestBatch(ActiveTestBatch);
        asserterror TestExecute.VerifyNoActiveTest();
        Assert.ExpectedError(CannotRunMultipleBatchesErr);
    end;

    [Test]
    procedure StartBatchCopiesBatchToActive()
    var
        TestBatch: Record "ALD Test Batch";
        BatchSession: Record "ALD Batch Session";
    begin
        // [SCENARIO] Start Test Batch action copies the selected batch and its configuration into the active batch config.

        Initialize();

        // [GIVEN] Load test batch with two test sessions
        LibraryLoadTest.CreateTestBatch(TestBatch);
        LibraryLoadTest.CreateTestBatchSession(TestBatch.Name, BatchSession);
        LibraryLoadTest.CreateTestBatchSession(TestBatch.Name, BatchSession);

        // [WHEN] Execute the batch
        TestExecute.RunTestBatch(TestBatch.Name);

        // [THEN] Batch sessions are copied to the active batch
        VerifyActiveBatch(TestBatch.Name);
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
        ActiveTestBatch: Record "ALD Active Test Batch";
        ActiveTestSession: Record "ALD Active Test Session";
        BatchSession: Record "ALD Batch Session";
    begin
        ActiveTestBatch.SetRange("Batch Name", BatchName);
        Assert.RecordCount(ActiveTestBatch, 1);

        BatchSession.SetRange("Batch Name", BatchName);
        ActiveTestSession.SetRange("Batch Name", BatchName);
        Assert.RecordCount(ActiveTestSession, BatchSession.Count());
    end;

    var
        TestExecute: Codeunit "ALD Test - Execute";
        LibraryLoadTest: Codeunit "ALD Library - Load Test";
        Assert: Codeunit Assert;
        UnexpectedFunctionValueErr: Label 'Unexpected function return value.';
        IsInitialized: Boolean;
}