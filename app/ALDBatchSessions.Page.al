page 55102 "ALD Batch Sessions"
{
    PageType = List;
    SourceTable = "ALD Batch Session";
    Caption = 'Batch Sessions';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(BatchSessions)
            {
                Caption = 'Test Sessions';

                field(SequenceNo; Rec."Session Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The sequential number of the session within the batch.';
                }
                field(Name; Rec."Session Code")
                {
                    ToolTip = 'A list of sessions comprising the load test.';
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'The name of the company in which the session will be executed.';
                    ApplicationArea = All;
                }
                field(StartDelay; Rec."Session Start Delay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Delay in ms between the start time of the batch and the start time of the session.';
                }
                field(NoOfClones; Rec."No. of Clones")
                {
                    ApplicationArea = All;
                    ToolTip = 'No. of session clones. Each clone is a separate session running the same set of tasks.';
                }
                field(DelayBetweenClones; Rec."Delay Between Clones")
                {
                    ApplicationArea = All;
                    ToolTip = 'Delay in ms before the start of each clone.';
                }
            }
            part(TasksSubpage; "ALD Test Session Subform")
            {
                SubPageLink = "Session Code" = field("Session Code");
                ApplicationArea = All;
                Caption = 'Tasks';
                Editable = false;
            }
        }
    }
}