page 55105 "ALD Test Session Card"
{
    PageType = Card;
    SourceTable = "ALD Test Session";
    Caption = 'Load Test Session';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(SessionCode; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique ID of the session';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'The text description of the session';
                }
                field(CompanyName; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the company in which the session will be executed';
                }
                field(SessionDelayTime; Rec."Session Start Delay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Delay in ms between the start time of the batch and the start time of the session';
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
            part(SessionTasksSubform; "ALD Test Session Subform")
            {
                SubPageLink = "Session Code" = field(Code);
            }
        }
    }
}
