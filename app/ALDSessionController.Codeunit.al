codeunit 55104 "ALD Session Controller"
{
    trigger OnRun()
    begin
        RunSessionControlLoop();
    end;

    local procedure GetNextTestBatchNo(): Integer
    var
        CompletedTestBatch: Record "ALD Completed Test Batch";
    begin
        if not CompletedTestBatch.FindLast() then
            exit(1);

        exit(CompletedTestBatch."Test Run No." + 1);
    end;

    local procedure MoveBatchToCompleted()
    var
        ActiveTestBatch: Record "ALD Active Test Batch";
        CompletedTestBatch: Record "ALD Completed Test Batch";
    begin
        ActiveTestBatch.FindFirst();
        CompletedTestBatch.Validate("Test Run No.", GetNextTestBatchNo());
        CompletedTestBatch.Validate("Test Batch Name", ActiveTestBatch."Batch Name");
        CompletedTestBatch.Validate("Start DateTime", ActiveTestBatch."Start DateTime");
        CompletedTestBatch.Validate("End DateTime", CurrentDateTime());
        CompletedTestBatch.Insert(true);

        MoveSessionsToCompleted(CompletedTestBatch);
    end;

    local procedure MoveSessionsToCompleted(CompletedTestBatch: Record "ALD Completed Test Batch")
    var
        ActiveTestSession: Record "ALD Active Test Session";
        CompletedTestSession: Record "ALD Completed Test Session";
    begin
        ActiveTestSession.LockTable();
        if ActiveTestSession.FindSet() then
            repeat
                CompletedTestSession.TransferFields(ActiveTestSession, true);
                CompletedTestSession.Validate("Test Run No.", CompletedTestBatch."Test Run No.");
                CompletedTestSession.Insert(true);

                MoveTasksToCompleted(CompletedTestSession);
            until ActiveTestSession.Next() = 0;
    end;

    local procedure MoveTasksToCompleted(CompletedTestSession: Record "ALD Completed Test Session")
    var
        ActiveTestTask: Record "ALD Active Test Task";
        CompletedTestTask: Record "ALD Completed Test Task";
    begin
        ActiveTestTask.LockTable();
        ActiveTestTask.SetRange("Batch Name", CompletedTestSession."Test Batch Name");
        ActiveTestTask.SetRange("Session No.", CompletedTestSession."Session No.");
        ActiveTestTask.SetRange("Session Clone No.", CompletedTestSession."Clone No.");
        if ActiveTestTask.FindSet(true) then
            repeat
                CompletedTestTask.Validate("Test Run No.", CompletedTestSession."Test Run No.");
                CompletedTestTask.TransferFields(ActiveTestTask, true);
                CompletedTestTask.Insert(true);
            until ActiveTestTask.Next() = 0;
    end;

    local procedure RunSessionControlLoop()
    var
        LoadTestSetup: Record "ALD Setup";
        ActiveTestSession: Record "ALD Active Test Session";
    begin
        LoadTestSetup.Get();
        LoadTestSetup.TestField("Task Update Frequency");

        while not ALDTestExecute.AllTestsCompleted() do begin
            ActiveTestSession.SetRange(State, ActiveTestSession.State::Ready);
            ActiveTestSession.SetFilter("Scheduled Start DateTime", '<=%1', CurrentDateTime);
            if ActiveTestSession.FindSet(true) then
                repeat
                    StartTestSession(ActiveTestSession);
                until ActiveTestSession.Next() = 0;

            Commit();
            Sleep(LoadTestSetup."Task Update Frequency");
        end;

        MoveBatchToCompleted();
    end;

    local procedure StartTestSession(var ActiveTestSession: Record "ALD Active Test Session")
    var
        SessionCompanyName: Text;
    begin
        if DelChr(ActiveTestSession."Company Name", '<>', ' ') = '' then
            SessionCompanyName := CompanyName()
        else
            SessionCompanyName := ActiveTestSession."Company Name";

        if StartSession(
            ActiveTestSession."Client Session ID", Codeunit::"ALD Session Task Controller", SessionCompanyName, ActiveTestSession)
        then begin
            ActiveTestSession.Validate(State, ActiveTestSession.State::Running);
            ActiveTestSession.Validate("Start DateTime", CurrentDateTime);
        end
        else
            ActiveTestSession.Validate(State, ActiveTestSession.State::Failed);

        ActiveTestSession.Modify(true);
        Commit();
    end;

    procedure TerminateActiveSessions()
    var
        ActiveTestSession: Record "ALD Active Test Session";
        ActiveTestBatch: Record "ALD Active Test Batch";
    begin
        if ActiveTestSession.FindSet(true) then
            repeat
                StopSession(ActiveTestSession."Client Session ID");
                ActiveTestSession.Validate(State, ActiveTestSession.State::Terminated);
                ActiveTestSession.Validate("End DateTime", CurrentDateTime());
                ActiveTestSession.Modify(true);
            until ActiveTestSession.Next() = 0;

        if ActiveTestBatch.FindFirst() then begin
            StopSession(ActiveTestBatch."Controller Session ID");
            // TODO: Batch should also have a state
            //ActiveTestBatch.Validate(State, ActiveTestBatch.State::Terminated);
            ActiveTestBatch.Validate("End DateTime", CurrentDateTime());
            ActiveTestBatch.Modify(true);
        end;
    end;

    var
        ALDTestExecute: Codeunit "ALD Test - Execute";
}