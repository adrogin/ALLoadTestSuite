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
                field(Name; Rec."Session Code")
                {
                    ToolTip = 'A list of sessions comprising the load test.';
                    ApplicationArea = All;
                }
                field("Company Name"; "Company Name")
                {
                    ToolTip = 'The name of the company in which the session will be executed.';
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