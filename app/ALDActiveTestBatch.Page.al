page 55106 "ALD Active Test Batch"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "ALD Active Test Batch";
    Caption = 'Active Load Test Batch';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(TestBatch)
            {
                ShowCaption = false;

                field(BatchName; Rec."Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the test batch currently running.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the test batch currently running.';
                }
                field("Start DateTime"; Rec."Start DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the active batch started.';
                }
                field("End DateTime"; Rec."End DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the active batch completed.';
                }
            }

            part(ActiveTestSessions; "ALD Active Sessions Subpage")
            {
                SubPageLink = "Batch Name" = field("Batch Name");
                ApplicationArea = All;
            }

            part(ActiveTestTasks; "ALD Active Tasks Subpage")
            {
                Provider = ActiveTestSessions;
                SubPageLink = "Batch Name" = field("Batch Name"), "No." = field("No."), "Session Clone No." = field("Clone No.");
                ApplicationArea = All;
            }

            usercontrol(TimerAddIn; "ALD Timer Event AddIn")
            {
                trigger AddInLoaded()
                var
                    ALDSetup: Record "ALD Setup";
                begin
                    // TODO: UI update frequency should be controlled by a separate configuration
                    ALDSetup.Get();
                    ALDSetup.TestField("Task Update Frequency");
                    CurrPage.TimerAddIn.SetTimerInterval(ALDSetup."Task Update Frequency");
                end;

                trigger OnTimer()
                begin
                    CurrPage.Update(false);
                    CurrPage.ActiveTestSessions.Page.Update(false);
                end;
            }
        }

        area(FactBoxes)
        {
            part(Errors; "ALD Active Task Errors Factbox")
            {
                ApplicationArea = All;
                Provider = ActiveTestTasks;
                SubPageLink =
                    "Batch Name" = field("Batch Name"), "No." = field("No."),
                    "Session Clone No." = field("Session Clone No."), "Task No." = field("Task No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TerminateBatch)
            {
                Caption = 'Terminate Batch';
                ToolTip = 'Terminates the execution of the active test batch. All test sessions will be stopped immediately.';
                Image = Cancel;
                ApplicationArea = All;
                Enabled = IsActiveBatchRunning;

                trigger OnAction()
                var
                    SessionController: Codeunit "ALD Session Controller";
                begin
                    SessionController.TerminateActiveSessions();
                end;
            }

            action(Rerun)
            {
                Caption = 'Re-run Batch';
                ToolTip = 'Restart the selected test batch.';
                Image = Replan;
                Enabled = not IsActiveBatchRunning;

                trigger OnAction()
                var
                    LoadTestExecute: Codeunit "ALD Test - Execute";
                begin
                    LoadTestExecute.RunTestBatch(Rec."Batch Name");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsActiveBatchRunning := TestExecute.IsActiveBatchRunning();
    end;

    var
        TestExecute: Codeunit "ALD Test - Execute";
        IsActiveBatchRunning: Boolean;
}
