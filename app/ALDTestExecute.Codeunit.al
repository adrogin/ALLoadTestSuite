codeunit 55100 "ALD Test - Execute"
{
    procedure RunTestBatch(BatchName: Code[20])
    begin
        VerifyNoRunningTest();
        CleanActiveBatch();
        StartBatch(BatchName);
    end;

    procedure AllTestsCompleted(): Boolean
    var
        ActiveTestSession: Record "ALD Active Test Session";
    begin
        ActiveTestSession.SetFilter(State, '%1|%2', ActiveTestSession.State::Ready, ActiveTestSession.State::Running);
        exit(ActiveTestSession.IsEmpty());
    end;

    procedure IsActiveBatchStarted(): Boolean
    var
        ActiveTestTask: Record "ALD Active Test Task";
    begin
        ActiveTestTask.SetFilter(State, '>%1', ActiveTestTask.State::Ready);
        exit(not ActiveTestTask.IsEmpty());
    end;

    procedure IsActiveBatchRunning(): Boolean
    begin
        if not IsActiveBatchStarted() then
            exit(false);

        exit(not AllTestsCompleted());
    end;

    local procedure CleanActiveBatch()
    var
        LoadTestActiveBatch: Record "ALD Active Test Batch";
    begin
        LoadTestActiveBatch.DeleteAll(true);
    end;

    local procedure CopyBatchSessionToActive(BatchSession: Record "ALD Batch Session")
    var
        ActiveTestBatch: Record "ALD Active Test Batch";
        TestSession: Record "ALD Test Session";
        ActiveTestSession: Record "ALD Active Test Session";
        CloneCount: Integer;
    begin
        ActiveTestBatch.Get(BatchSession."Batch Name");
        TestSession.Get(BatchSession."Session Code");

        for CloneCount := 1 to TestSession."No. of Clones" do begin
            ActiveTestSession.Validate("Batch Name", BatchSession."Batch Name");
            ActiveTestSession.Validate("Session No.", TestSession.Code);
            ActiveTestSession.Validate("Clone No.", CloneCount);
            ActiveTestSession.Validate("Company Name", BatchSession."Company Name");
            ActiveTestSession.Validate(
                "Scheduled Start DateTime",
                ActiveTestBatch."Start DateTime" + TestSession."Session Start Delay" + TestSession."Delay Between Clones" * (CloneCount - 1));
            ActiveTestSession.Insert(true);

            CopySessionTasksToActive(ActiveTestSession);
        end;
    end;

    local procedure CopySessionTasksToActive(LoadTestActiveSession: Record "ALD Active Test Session")
    var
        TestTask: Record "ALD Test Task";
        ActiveTestTask: Record "ALD Active Test Task";
    begin
        TestTask.SetRange("Session Code", LoadTestActiveSession."Session No.");
        if TestTask.FindSet() then
            repeat
                ActiveTestTask.Validate("Batch Name", LoadTestActiveSession."Batch Name");
                ActiveTestTask.Validate("Session No.", LoadTestActiveSession."Session No.");
                ActiveTestTask.Validate("Session Clone No.", LoadTestActiveSession."Clone No.");
                ActiveTestTask.Validate("Task No.", TestTask."Task No.");
                ActiveTestTask.Validate("Object Type", TestTask."Object Type");
                ActiveTestTask.Validate("Object ID", TestTask."Object ID");
                ActiveTestTask.Validate(Description, TestTask.Description);
                ActiveTestTask.Insert(true);
            until TestTask.Next() = 0;
    end;

    procedure StartBatch(BatchName: Code[20])
    var
        ActiveTestBatch: Record "ALD Active Test Batch";
        BatchSession: Record "ALD Batch Session";
        SessionId: Integer;
    begin
        ActiveTestBatch.Validate("Batch Name", BatchName);
        ActiveTestBatch.Validate("Start DateTime", CurrentDateTime);
        ActiveTestBatch.Insert(true);

        BatchSession.SetRange("Batch Name", BatchName);
        if BatchSession.FindSet() then begin
            repeat
                CopyBatchSessionToActive(BatchSession);
            until BatchSession.Next() = 0;

            Commit();

            StartSession(SessionId, Codeunit::"ALD Session Controller");
            ActiveTestBatch.Validate("Controller Session ID", SessionId);
            ActiveTestBatch.Modify(true);
        end;
    end;

    procedure VerifyNoRunningTest()
    begin
        if IsActiveBatchRunning() then
            Error(CannotRunMultipleBatchesErr);
    end;

    var
        CannotRunMultipleBatchesErr: Label 'Test batch cannot start while another batch is running. Wait for the active batch to complete or stop it manually and try again.';
}