page 55109 "ALD Active Task Errors Factbox"
{
    PageType = CardPart;
    SourceTable = "ALD Active Task Error";
    Caption = 'Task Errors';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(ErrorCode; Rec."Error Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Code of the error which interrupted the task.';
                }
                field(ErrorText; Rec."Error Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Error message of the error which interrupted the task.';
                }
            }
        }
    }
}