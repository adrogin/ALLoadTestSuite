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
                field(ErrorTextControl; ErrorText)
                {
                    Caption = 'Error Text';
                    ApplicationArea = All;
                    ToolTip = 'Text of the error which interrupted the task.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        InStr: InStream;
    begin
        ErrorText := '';
        Rec.CalcFields("Error Text");
        if Rec."Error Text".HasValue() then begin
            Rec."Error Text".CreateInStream(InStr);
            InStr.ReadText(ErrorText);
        end;
    end;

    var
        ErrorText: Text;
}