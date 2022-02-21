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
            group(ErrorInfo)
            {
                ShowCaption = false;

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
                    MultiLine = true;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        InStr: InStream;
        ErrorLine: Text;
        LineFeed: Char;
    begin
        LineFeed := 10;
        ErrorText := '';
        Rec.CalcFields("Error Text");
        if Rec."Error Text".HasValue() then begin
            Rec."Error Text".CreateInStream(InStr);
            while not InStr.EOS do begin
                InStr.ReadText(ErrorLine);
                ErrorText += ErrorLine + LineFeed;
            end;
        end;
    end;

    var
        ErrorText: Text;
}