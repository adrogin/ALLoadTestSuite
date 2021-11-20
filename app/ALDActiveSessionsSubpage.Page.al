page 55107 "ALD Active Sessions Subpage"
{
    PageType = ListPart;
    SourceTable = "ALD Active Test Session";
    Caption = 'Active Test Sessions';

    layout
    {
        area(Content)
        {
            repeater(SessionDetails)
            {
                field(SessionCode; Rec."Session Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sequential number of the session in the batch.';
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Current state of the test session.';
                }
                field(ClientSessionID; Rec."Client Session ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the BC client session.';
                }
                field(ScheduledStartDateTime; Rec."Scheduled Start DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the session is scheduled to start.';
                }
                field(StartDateTime; Rec."Start DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual date and time when the session started.';
                }
                field(EndDateTime; Rec."End DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the session completed or was terminated.';
                }
                field("Duration"; SessionDuration)
                {
                    Caption = 'Duration';
                    ApplicationArea = All;
                    ToolTip = 'The duration of the session.';
                }
                field(CompanyName; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the company in which the session is executed';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SessionDuration := TestExecute.FormatTestDuration(Rec.Duration);
    end;

    var
        TestExecute: Codeunit "ALD Test - Execute";
        SessionDuration: Text;
}