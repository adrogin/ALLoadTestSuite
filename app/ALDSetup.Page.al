page 55100 "ALD Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ALD Setup";
    Caption = 'Load Test Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Task Update Frequency"; Rec."Task Update Frequency")
                {
                    ToolTip = 'Specifies how often the status of test tasks is updated.';
                    ApplicationArea = All;
                }
            }
        }
    }
}