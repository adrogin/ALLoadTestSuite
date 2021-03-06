codeunit 55102 "ALD Session Task Controller"
{
    TableNo = "ALD Active Test Session";

    trigger OnRun()
    begin
        RunSessionTasks(Rec);
    end;

    local procedure RunSessionTasks(var ActiveTestSession: Record "ALD Active Test Session")
    var
        ActiveTestTask: Record "ALD Active Test Task";
        TaskRunner: Codeunit "ALD Task Runner";
        IsTaskSuccessful: Boolean;
        IsSessionSuccessful: Boolean;
    begin
        SetSessionRunningState(ActiveTestSession);

        IsSessionSuccessful := true;
        ActiveTestTask.SetRange("Session No.", ActiveTestSession."Session No.");
        ActiveTestTask.SetRange("Session Clone No.", ActiveTestSession."Clone No.");
        if ActiveTestTask.FindSet() then
            repeat
                SetTaskStatusRunning(ActiveTestTask);

                Commit();
                IsTaskSuccessful := TaskRunner.Run(ActiveTestTask);
                if IsTaskSuccessful then
                    SetTaskStatusCompleted(ActiveTestTask)
                else
                    SetTaskStatusFailed(ActiveTestTask);

                IsSessionSuccessful := IsSessionSuccessful and IsTaskSuccessful;
            until ActiveTestTask.Next() = 0;

        SetSessionFinalState(ActiveTestSession, IsSessionSuccessful);
    end;

    local procedure SetSessionRunningState(var ActiveTestSession: Record "ALD Active Test Session")
    begin
        ActiveTestSession.Validate(State, ActiveTestSession.State::Running);
        ActiveTestSession.Validate("Start DateTime", CurrentDateTime);
        ActiveTestSession.Modify(true);
    end;

    local procedure SetSessionFinalState(var ActiveTestSession: Record "ALD Active Test Session"; IsSuccess: Boolean)
    begin
        if IsSuccess then
            ActiveTestSession.Validate(State, ActiveTestSession.State::Completed)
        else
            ActiveTestSession.Validate(State, ActiveTestSession.State::Failed);

        ActiveTestSession.Validate("End DateTime", CurrentDateTime);
        ActiveTestSession.Modify(true);
    end;

    local procedure SetTaskStatusRunning(var ActiveTestTask: Record "ALD Active Test Task")
    begin
        ActiveTestTask.Validate(State, ActiveTestTask.State::Running);
        ActiveTestTask.Validate("Start DateTime", CurrentDateTime);
        ActiveTestTask.Modify(true);
    end;

    local procedure SetTaskStatusCompleted(var ActiveTestTask: Record "ALD Active Test Task")
    begin
        ActiveTestTask.Validate(State, ActiveTestTask.State::Completed);
        ActiveTestTask.Validate("End DateTime", CurrentDateTime);
        ActiveTestTask.Modify(true);
    end;

    local procedure SetTaskStatusFailed(var ActiveTestTask: Record "ALD Active Test Task")
    var
        ActiveTaskError: Record "ALD Active Task Error";
        BlobOutStream: OutStream;
    begin
        ActiveTestTask.Validate(State, ActiveTestTask.State::Failed);
        ActiveTestTask.Validate("End DateTime", CurrentDateTime);
        ActiveTestTask.Modify(true);

        ActiveTaskError.Validate("Batch Name", ActiveTestTask."Batch Name");
        ActiveTaskError.Validate("Session No.", ActiveTestTask."Session No.");
        ActiveTaskError.Validate("Session Clone No.", ActiveTestTask."Session Clone No.");
        ActiveTaskError.Validate("Task No.", ActiveTestTask."Task No.");
        ActiveTaskError.Validate("Error Code", CopyStr(GetLastErrorCode(), 1, MaxStrLen(ActiveTaskError."Error Code")));
        ActiveTaskError.Validate("Error Text", CopyStr(GetLastErrorText(), 1, MaxStrLen(ActiveTaskError."Error Text")));

        ActiveTaskError."Error Call Stack".CreateOutStream(BlobOutStream);
        BlobOutStream.WriteText(GetLastErrorCallStack());

        ActiveTaskError.Insert(true);
    end;
}