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
        ActiveTestBatch.Validate(State, CompletedTestBatch.State::Completed);
        ActiveTestBatch.Validate("End DateTime", CurrentDateTime());
        ActiveTestBatch.Modify(true);

        CompletedTestBatch.TransferFields(ActiveTestBatch);
        CompletedTestBatch.Validate("Test Run No.", GetNextTestBatchNo());
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
        ActiveTestTask.SetRange("No.", CompletedTestSession."No.");
        ActiveTestTask.SetRange("Session Clone No.", CompletedTestSession."Clone No.");
        if ActiveTestTask.FindSet(true) then
            repeat
                CompletedTestTask.Validate("Test Run No.", CompletedTestSession."Test Run No.");
                CompletedTestTask.TransferFields(ActiveTestTask, true);
                CompletedTestTask.Insert(true);

                CopyTaskErrorsToCompleted(CompletedTestTask);
            until ActiveTestTask.Next() = 0;
    end;

    local procedure CopyTaskErrorsToCompleted(CompletedTestTask: Record "ALD Completed Test Task")
    var
        ActiveTaskError: Record "ALD Active Task Error";
        CompletedTaskError: Record "ALD Completed Task Error";
    begin
        ActiveTaskError.SetRange("Batch Name", CompletedTestTask."Batch Name");
        ActiveTaskError.SetRange("No.", CompletedTestTask."No.");
        ActiveTaskError.SetRange("Session Clone No.", CompletedTestTask."Session Clone No.");
        ActiveTaskError.SetRange("Task No.", CompletedTestTask."Task No.");
        if ActiveTaskError.FindSet() then
            repeat
                CompletedTaskError.TransferFields(ActiveTaskError);
                CompletedTaskError.Validate("Test Run No.", CompletedTestTask."Test Run No.");
                CompletedTaskError.Insert(true);
            until ActiveTaskError.Next() = 0;
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
            if ActiveTestSession.FindSet() then begin
                repeat
                    StartTestSession(ActiveTestSession);
                until ActiveTestSession.Next() = 0;

                Commit();
            end;

            Sleep(LoadTestSetup."Task Update Frequency");
        end;

        MoveBatchToCompleted();
    end;

    local procedure StartTestSession(var ActiveTestSession: Record "ALD Active Test Session")
    var
        ActiveClientSession: Record "ALD Active Client Session";
        SessionCompanyName: Text;
        SessionId: Integer;
    begin
        if DelChr(ActiveTestSession."Company Name", '<>', ' ') = '' then
            SessionCompanyName := CompanyName()
        else
            SessionCompanyName := ActiveTestSession."Company Name";

        if StartSession(SessionId, Codeunit::"ALD Session Task Controller", SessionCompanyName, ActiveTestSession) then begin
            ActiveClientSession.Validate("Batch Name", ActiveTestSession."Batch Name");
            ActiveClientSession.Validate("No.", ActiveTestSession."No.");
            ActiveClientSession.Validate("Clone No.", ActiveTestSession."Clone No.");
            ActiveClientSession.Validate("Client Session ID", SessionId);
            ActiveClientSession.Insert(true);
        end
        else begin
            ActiveTestSession.Validate(State, ActiveTestSession.State::Failed);
            ActiveTestSession.Modify(true);
        end;

        Commit();
    end;

    procedure TerminateActiveSessions()
    var
        ActiveTestSession: Record "ALD Active Test Session";
        ActiveTestBatch: Record "ALD Active Test Batch";
    begin
        ActiveTestSession.SetFilter(State, '%1|%2', ActiveTestSession.State::Ready, ActiveTestSession.State::Running);
        if ActiveTestSession.FindSet() then
            repeat
                TerminateTestSession(ActiveTestSession);
            until ActiveTestSession.Next() = 0;

        if ActiveTestBatch.FindFirst() then begin
            StopSession(ActiveTestBatch."Controller Session ID");
            ActiveTestBatch.Validate(State, ActiveTestBatch.State::Terminated);
            ActiveTestBatch.Validate("End DateTime", CurrentDateTime());
            ActiveTestBatch.Modify(true);
        end;
    end;

    local procedure TerminateTestSession(var ActiveTestSession: Record "ALD Active Test Session")
    begin
        ActiveTestSession.CalcFields("Client Session ID");
        StopSession(ActiveTestSession."Client Session ID");
        ActiveTestSession.Validate(State, ActiveTestSession.State::Terminated);
        ActiveTestSession.Validate("End DateTime", CurrentDateTime());
        ActiveTestSession.Modify(true);

        TerminateSessionTasks(ActiveTestSession);
    end;

    local procedure TerminateSessionTasks(ActiveTestSession: Record "ALD Active Test Session")
    var
        ActiveTestTask: Record "ALD Active Test Task";
    begin
        ActiveTestTask.SetFilter(State, '%1|%2', ActiveTestTask.State::Ready, ActiveTestTask.State::Running);
        ActiveTestTask.SetRange("Batch Name", ActiveTestSession."Batch Name");
        ActiveTestTask.SetRange("No.", ActiveTestSession."No.");
        ActiveTestTask.SetRange("Session Clone No.", ActiveTestSession."Clone No.");

        if ActiveTestTask.FindFirst() then begin
            ActiveTestTask.Validate(State, ActiveTestTask.state::Terminated);
            ActiveTestTask.Validate("End DateTime", CurrentDateTime());
            ActiveTestTask.Modify(true);
        end;
    end;

    var
        ALDTestExecute: Codeunit "ALD Test - Execute";
}