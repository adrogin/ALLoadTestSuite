codeunit 69100 "Library - Load Test ALD"
{
    procedure CreateTestBatch(var LoadTestBatch: Record "Load Test Batch ALD")
    begin
        LoadTestBatch.Validate(Name, LibraryUtility.GenerateGUID());
        LoadTestBatch.Validate(Description, LoadTestBatch.Name);
        LoadTestBatch.Insert(true);
    end;

    procedure CreateTestBatchSession(TestBatchName: Code[20]; var LoadTestBatchSession: Record "Load Test Batch Session ALD")
    var
        LoadTestSession: Record "Load Test Session ALD";
    begin
        CreateLoadTestSession(LoadTestSession);
        LoadTestBatchSession.Validate("Batch Name", TestBatchName);
        LoadTestBatchSession.Validate("Session No.", LoadTestSession."No.");
        LoadTestBatchSession.Insert(true);
    end;

    procedure CreateLoadTestSession(var LoadTestSesion: Record "Load Test Session ALD")
    begin
        LoadTestSesion.Validate("No.", LibraryUtility.GenerateGUID());
        LoadTestSesion.Insert(true);
    end;

    procedure InitLoadTestSetup()
    var
        LoadTestSetup: Record "Load Test Setup ALD";
    begin
        LoadTestSetup.DeleteAll();
        LoadTestSetup.Validate("Task Update Frequency", LibraryRandom.RandIntInRange(100, 500));
        LoadTestSetup.Insert(true);
    end;

    procedure MockActiveTestBatch(var LoadTestActiveBatch: Record "Load Test Active Batch ALD")
    var
        LoadTestBatch: Record "Load Test Batch ALD";
    begin
        LoadTestActiveBatch.Reset();
        LoadTestActiveBatch.DeleteAll();

        CreateTestBatch(LoadTestBatch);
        LoadTestActiveBatch.Validate("Batch Name", LoadTestBatch.Name);
        LoadTestActiveBatch.Validate("Start DateTime", CurrentDateTime);
        LoadTestActiveBatch.Insert(true)
    end;

    var
        LibraryRandom: Codeunit "Library - Random";
        LibraryUtility: Codeunit "Library - Utility";
}