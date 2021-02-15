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
                    ToolTip = 'Date and time when the running batch started.';
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
                SubPageLink = "Batch Name" = field("Batch Name"), "Session No." = field("Session No."), "Session Clone No." = field("Clone No.");
                ApplicationArea = All;
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
                ApplicationArea = All;

                trigger OnAction()
                var
                    SessionController: Codeunit "ALD Session Controller";
                begin
                    SessionController.TerminateActiveSessions();
                end;
            }
        }
    }
}